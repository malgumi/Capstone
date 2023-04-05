import 'package:flutter/material.dart';
import 'package:capstone/main.dart';
import 'package:capstone/screens/party_board.dart';
import 'package:capstone/screens/free_board.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:capstone/screens/login_form.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}


class _MyDrawerState extends State<MyDrawer> {
  String _errorMessage = '';
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _studentinfo();
  }


  void logout(BuildContext context) async {
    final storage = new FlutterSecureStorage();
    await storage.delete(key: 'token');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false,
    );
  }

  String? _accountName;
  String? _accountEmail;
  void _studentinfo() async {

    setState(() => _isLoading = true);

    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    if (token == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = '토큰이 없습니다.';
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('게시글 작성에 실패했습니다. (로그인 만료)')));
      });
      return;
    }


    final response = await http.get(
      Uri.parse('http://3.39.88.187:3000/user/student'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token,
      },
    );

    if (response.statusCode == 201) {
      // Success

      final responseData = jsonDecode(response.body);
      setState(() {
        _accountName = responseData[0]['student_id'].toString();
        _accountEmail = responseData[0]['name'];


      });
    } else {
      // Failure
      setState(() {
        final responseData = jsonDecode(response.body);

        _isLoading = false;
        _errorMessage = responseData['message'];
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Color(0xffC1D3FF),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: AssetImage('assets/profile.png'),
                    backgroundColor: Colors.white,
                  ),

                  onDetailsPressed: _studentinfo,
                  accountName: Text(_accountName ?? ''),
                  accountEmail: Text(_accountEmail ?? ''),

                ),
                ListTile(
                  leading: Icon(Icons.home, color: Colors.grey[800]),
                  title: Text('홈'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.announcement, color: Colors.grey[800]),
                  title: Text('공지사항'),
                  onTap: () {
                    // 메뉴 1을 클릭할 때의 동작을 정의합니다.
                  },
                ),
                ListTile(
                  leading: Icon(Icons.chat, color: Colors.grey[800]),
                  title: Text('구인구직 게시판'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PartyBoardScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.article, color: Colors.grey[800]),
                  title: Text('자유게시판'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FreeBoardScreen()),
                    );
                  },
                ),
                ListTile(
                  title: Text('내 정보 업데이트'),
                  onTap: _studentinfo,
                ),

              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.grey[800]),
            title: Text('로그아웃'),
            onTap: () {
              logout(context);
            },
          ),
        ],
      ),
    );
  }
}