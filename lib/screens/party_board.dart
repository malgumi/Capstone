import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'job_post_form.dart';
//test용 주석 추가

void main() {
  runApp(MaterialApp(
    title: '구인구직 게시판',
    home: PartyBoardScreen(),
  ));
}

class PartyBoardScreen extends StatefulWidget {
  @override
  _FreeBoardScreenState createState() => _FreeBoardScreenState();
}

class _FreeBoardScreenState extends State<PartyBoardScreen> {
  late Future<List<dynamic>> _jobposts;

  @override
  void initState() {
    super.initState();
    _jobposts = _fetchPosts();
  }

  Future<List<dynamic>> _fetchPosts() async {
    final response = await http.get(Uri.parse('http://localhost:3000/jobposts?board_id=2'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Widget _buildPostItem(BuildContext context, dynamic post) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  post['student_id'].toString(),
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  post['post_date'],
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '구인구직게시판',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _jobposts,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final jobposts = snapshot.data!;
                    return ListView.builder(
                      itemCount: jobposts.length,
                      itemBuilder: (context, index) {
                        return _buildPostItem(context, jobposts[index]);
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => JobPostForm()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}