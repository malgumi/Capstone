import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:capstone/screens/EditPostScreen.dart';

class PostScreen extends StatefulWidget {
  final dynamic post;

  PostScreen({required this.post});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late Future<List<dynamic>> comments;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _errorMessage = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    comments = fetchComments();
  }

  Future<List<dynamic>> fetchComments() async {
    final response = await http.get(Uri.parse(
        'http://localhost:3000/post/comment:?post_id=${widget.post['post_id']}'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load posts');
    }
  }
  void _navigateToEditPostScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPostScreen(
          post: widget.post,
        ),
      ),
    ).then((value) {
      // Refresh post data after editing
      setState(() {
        widget.post['post_title'] = value['post_title'];
        widget.post['post_content'] = value['post_content'];
      });
    });
  }
  Future<void> deletePost() async {

    setState(() => _isLoading = true);
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    if (token == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = '토큰이 없습니다.';
      });
      return;
    }

    final response = await http.post(
      Uri.parse('http://localhost:3000/post/deletepost/${widget.post['post_id']}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token,
      },
    );
    if (response.statusCode == 200) {
      print('게시물 삭제 완료');
    } else {
      throw Exception('Failed to delete post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '자유게시판',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xffC1D3FF),
        centerTitle: true,
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: _navigateToEditPostScreen,
            icon: Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () async {
              await deletePost();
              Navigator.pop(context);
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            Text(
              widget.post['post_title'],
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              widget.post['post_content'],
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.post['student_id'].toString().substring(2, 4) + '학번',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  DateFormat('yyyy-MM-dd HH:mm:ss')
                      .format(DateTime.parse(widget.post['post_date'])),
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.0),
            Divider(
              height: 1.0,
              thickness: 1.0,
              color: Colors.grey[400],
              indent: 0.0,
              endIndent: 0.0,
            ),
            SizedBox(height: 16.0),
            FutureBuilder<List<dynamic>>(
              future: comments,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        '등록된 댓글이 없습니다.',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    );
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data![index]['student_id']
                                          .toString()
                                          .substring(2, 4) +
                                      '학번',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  snapshot.data![index]['comment_content'],
                                  style: TextStyle(
                                    fontSize: 14.0,
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  DateFormat('yyyy-MM-dd HH:mm:ss').format(
                                      DateTime.parse(snapshot.data![index]
                                          ['comment_date'])),
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.grey,
                                  ),
                                ),
                                Divider(),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      '댓글을 불러오는 중 오류가 발생했습니다. ${snapshot.error}',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.red,
                      ),
                    ),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
