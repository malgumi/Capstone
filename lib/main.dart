import 'package:capstone/screens/notice.dart';
import 'package:flutter/material.dart';
import 'package:capstone/screens/party_board.dart';
import 'package:capstone/screens/free_board.dart';
import 'package:capstone/screens/login_form.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Capstone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _errorMessage = '';
  bool _isLoading = false;

  Future<void> _logout(BuildContext context) async {
    final url = Uri.parse('http://3.39.88.187:3000/user/logout');
    setState(() => _isLoading = true);
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    print(token);
    if (token == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = '토큰이 없습니다.';
      });
      return;
    }
    final response = await http.post(
      url,
      headers: <String, String>{ //헤더파일 추가
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token,
      },
      body: jsonEncode( {
        'content': 'logout',
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
            (Route<dynamic> route) => false,
      );
    } else {
      // handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Capstone'),
        backgroundColor: Color(0xffC1D3FF),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Notice()),
                );
              },
              child: Text(
                '공지 알림톡',
                style: TextStyle(fontSize: 20),

              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                backgroundColor: Color(0xffC1D3FF),
              ),

            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PartyBoardScreen()),
                );
              },
              child: Text(
                '구인구직 게시판',
                style: TextStyle(fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                backgroundColor: Color(0xffC1D3FF),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FreeBoardScreen()),
                );
              },
              child: Text(
                '자유게시판',
                style: TextStyle(fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                backgroundColor: Color(0xffC1D3FF),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text(
                '가입화면',
                style: TextStyle(fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                backgroundColor: Color(0xffC1D3FF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
