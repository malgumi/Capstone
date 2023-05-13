import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:capstone/screens/PostScreen.dart';
import 'package:capstone/screens/WritePostScreen.dart';
import 'package:intl/intl.dart';
import 'package:capstone/screens/party_board.dart';
import 'package:capstone/main.dart';
import 'package:capstone/screens/drawer.dart';
void main() {
  runApp(MaterialApp(
    title: '내가 쓴 글',
    home: MyPost(),
  ));
}

class MyPost extends StatefulWidget {
  @override
  _MyPostState createState() => _MyPostState();
}

class _MyPostState extends State<MyPost> {
  late Future<List<dynamic>> _posts;

  @override
  void initState() {
    super.initState();
    _posts = _fetchPosts();
  }
  String _errorMessage = '';
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<List<dynamic>> _fetchPosts() async {
    setState(() => _isLoading = true);

    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    if (token == null) {
      // 예외 처리
      throw Exception('Failed to load token');
    }

    final response = await http.get(
      Uri.parse('http://3.39.88.187:3000/post/mypost'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token,
      },
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {

      throw Exception('Failed to load posts');
    }
  }

  //댓글 갯수 표시 기능 구현중
  Future _fetchCommentsCount() async {
    final response = await http.get(
      Uri.parse('http://3.39.88.187:3000/post/commentsAll'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load comments count');
    }
  }




  Widget _buildPostItem(BuildContext context, dynamic post) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostScreen(post: post),
          ),
        );
        setState(() {
          _posts = _fetchPosts();
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Colors.white,
            border: Border.all(
              width: 2,
              color: Colors.grey.withOpacity(0.5),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post['board_id'] == 1
                    ? '자유게시판'
                    : post['board_id'] == 2
                    ? '구인구직게시판'
                    : post['board_id'] == 4
                    ? 'QNA'
                    : '', // 99인 경우 아무것도 출력하지 않음
                style: TextStyle(
                  fontSize: 10.0,

                ),
              ),
              Text(
                post['post_title'],
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                post['post_content'],
                style: TextStyle(
                  fontSize: 16.0,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    post['student_id'].toString().substring(2, 4) + '학번',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    DateFormat('yyyy-MM-dd HH:mm:ss')
                        .format(DateTime.parse(post['post_date'])),
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '내가 쓴 글',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xffC1D3FF),
        centerTitle: true,
        elevation: 0.0,
      ),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<dynamic>>(
          future: _posts,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final posts = snapshot.data!;
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return _buildPostItem(context, posts[index]);
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}