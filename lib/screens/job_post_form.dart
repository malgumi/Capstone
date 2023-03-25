import 'package:flutter/material.dart';

class JobPostForm extends StatefulWidget {
  @override
  _JobPostFormState createState() => _JobPostFormState();
}

class _JobPostFormState extends State<JobPostForm> {
  final _titleController = TextEditingController();
  final _studentNumberController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _studentNumberController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('글쓰기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            Text(
              '구인구직 게시판 - 글쓰기',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: '제목',
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _studentNumberController,
              decoration: InputDecoration(
                labelText: '학번',
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: '내용',
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                //TODO: 구현해야 함
              },
              child: Text('작성 완료'),
            ),
          ],
        ),
      ),
    );
  }
}
