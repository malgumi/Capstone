import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'job_post_form.dart';

class JobBoardPage extends StatefulWidget {
  @override
  _JobBoardPageState createState() => _JobBoardPageState();
}

class _JobBoardPageState extends State<JobBoardPage> {
  List<JobPost> _jobPosts = [];

  @override
  void initState() {
    super.initState();
    _fetchJobPosts();
  }

  Future<void> _fetchJobPosts() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/jobposts?board_id=2'));

      final jsonData = json.decode(response.body);
      setState(() {
        _jobPosts = jsonData.map<JobPost>((data) => JobPost.fromJson(data)).toList();
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('구인구직 게시판'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            Text(
              '구인구직 게시판',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _jobPosts.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _jobPosts[index].title ?? '',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Row(
                                children: [
                                  Icon(Icons.person),
                                  SizedBox(width: 4.0),
                                  Text(
                                    '학번 ${_jobPosts[index].studentId ?? ''}',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  SizedBox(width: 16.0),
                                  Icon(Icons.calendar_today),
                                  SizedBox(width: 4.0),
                                  Text(
                                    _jobPosts[index].createdAt ?? '',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
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

class JobPost {
  final int id;
  final String title;
  final String? studentId;
  final String? createdAt;

  JobPost({
    required this.id,
    required this.title,
    this.studentId,
    this.createdAt,
  });

  factory JobPost.fromJson(Map<String, dynamic> json) {
    return JobPost(
      id: json['id'],
      title: json['title'],
      studentId: json['student_id'],
      createdAt: json['created_at'],
    );
  }
}




