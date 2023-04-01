import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WritePostScreen extends StatefulWidget {
  final int boardId;

  WritePostScreen({required this.boardId});

  @override
  _WritePostScreenState createState() => _WritePostScreenState();
}

class _WritePostScreenState extends State<WritePostScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  String _errorMessage = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
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

      final Map<String, dynamic> postData = {
      'board_id': widget.boardId,
      'post_title': _titleController.text,
      'post_content': _contentController.text,
      'post_file': 'null', // TODO: Implement file uploading

    };

    final response = await http.post(
      Uri.parse('http://3.39.88.187:3000/post/write'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token,

      },
      body: jsonEncode(postData),
    );
    print(token);



    if (response.statusCode == 201) {
      // Success
      Navigator.pop(context, true);
    } else {
      // Failure
      final responseData = jsonDecode(response.body);
      setState(() {
        _isLoading = false;
        _errorMessage = responseData['message'];
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('글쓰기'),
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: '제목 ',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '제목을 입력하세요.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(
                  hintText: '내용',
                ),
                maxLines: null,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '내용을 입력하세요.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('글쓰기'),
              ),
              SizedBox(height: 8.0),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}