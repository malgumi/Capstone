import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WritePostScreen extends StatefulWidget {
  @override
  _WritePostScreenState createState() => _WritePostScreenState();
}

class _WritePostScreenState extends State<WritePostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('새 글쓰기'),
        backgroundColor: Color(0xffC1D3FF),
      ),
      body: Container(
        child: Text('글쓰기 화면'),
      ),
    );
  }
}