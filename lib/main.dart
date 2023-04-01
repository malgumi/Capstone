import 'package:capstone/screens/notice.dart';
import 'package:capstone/screens/notice_talk.dart';
import 'package:flutter/material.dart';
import 'package:capstone/screens/party_board.dart';
import 'package:capstone/screens/free_board.dart';
import 'package:capstone/screens/signup_form.dart';
import 'package:capstone/screens/login_form.dart';

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

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Capstone'),
        backgroundColor: Color(0xffC1D3FF),
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
