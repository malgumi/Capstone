// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:capstone/screens/drawer.dart';
//
// void main() {
//   runApp(MaterialApp(
//     title: '전체 공지방',
//     home: NoticeTalkScreen(),
//   ));
// }
//
// class NoticeTalkScreen extends StatefulWidget {
//   final int boardId;
//
//   NoticeTalkScreen({required this.boardId});
//
//   @override
//   _NoticeTalkScreenState createState() => _NoticeTalkScreenState();
// }
//
// class _NoticeTalkScreenState extends State<NoticeTalkScreen> {
//   //final List<Message> _messages = [];
//   late Future<List<dynamic>> _notices;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   TextEditingController _contentController = TextEditingController();
//
//   String _errorMessage = '';
//   bool _isLoading = false;
//
//   @override
//   void dispose() {
//     _contentController.dispose();
//     super.dispose();
//   }
//
//   @override
//   void initState() {//게시글 목록을 가져옴
//     super.initState();
//     _notices = fetchNotices();
//   }
//
//   void _submitForm() async {
//     if (!_formKey.currentState!.validate()) return;
//     setState(() => _isLoading = true);
//
//     final storage = FlutterSecureStorage();
//     final token = await storage.read(key: 'token');
//     if (token == null){
//       setState(() {
//         _isLoading = false;
//         _errorMessage = '토큰이 없습니다.';
//         ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text('공지 작성에 실패했습니다. (로그인 만료)')));
//       });
//       return;
//     }
//
//     final Map<String, dynamic> noticeData = {
//       'board_id': widget.boardId,
//       'notice_content': _contentController.text,
//       'notice_file': 'null',
//     }
//   }
// //서버로부터 게시글 목록을 가져옴
//   Future<List<dynamic>> fetchNotices() async {
//     final response = await http
//         .get(Uri.parse('http://3.39.88.187:3000/notice/notices?board_id=3'));
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to load notices');
//     }
//   }
//
//   Widget _buildNoticeItem(BuildContext context, dynamic notice) {
//     return GestureDetector(
//       // onTap: () async {
//       //   await Navigator.push(
//       //     context,
//       //     MaterialPageRoute(
//       //         builder: (context) => NoticeTalkScreen(notice: notice),
//       //     ),
//       //   );
//       //   setState(() {
//       //     _notices = fetchNotices();
//       //   });
//       // },
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8.0),
//         child: Container(
//           padding: EdgeInsets.all(16.0),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16.0),
//             color: Colors.white,
//             border: Border.all(
//               width: 2,
//               color: Colors.grey.withOpacity(0.5),
//             ),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 notice['notice_content'],
//                 style: TextStyle(
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 8.0),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     notice['student_id'].toString().substring(2, 4) + '학번',
//                     style: TextStyle(
//                       fontSize: 14.0,
//                       color: Colors.grey,
//                     ),
//                   ),
//                   Text(
//                     DateFormat('yyyy-MM-dd HH:mm:ss')
//                         .format(DateTime.parse(notice['notice_date'])),
//                     style: TextStyle(
//                       fontSize: 14.0,
//                       color: Colors.grey,
//                     ),
//                   )
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//
// @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           '컴퓨터공학과 전체 공지',
//           textAlign: TextAlign.center,
//           style: TextStyle(color: Colors.black,),
//         ),
//         centerTitle: true,
//         backgroundColor: Color(0xffC1D3FF),
//       ),
//       drawer: MyDrawer(),
//       backgroundColor: Colors.white,//여기까진 고정
//
//       body: Column(
//         children: [
//           FutureBuilder<List<dynamic>>(
//             future: _notices,
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 final notices = snapshot.data!;
//                 return ListView.builder(
//                   itemCount: notices.length,
//                   reverse: true,
//                   itemBuilder: (context, index) {
//                     return _buildNoticeItem(context, notices[index]);
//                   },
//                 );
//               }
//               else if (snapshot.hasError) {
//                 return Center(
//                   child: Text('${snapshot.error}'),
//                 );
//               }
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             },
//           ),
//           Container(
//             child: _buildTextComposer(),//메시지 입력창
//           )
//         ],
//       )
//         //padding: const EdgeInsets.all(16.0),
//
//
//
//       // body: Column(
//       //   children: <Widget>[
//       //     Flexible(
//       //       child: ListView.builder(
//       //         itemCount: notices.length,
//       //         reverse: true,  //최근글이 아래쪽으로 오도록
//       //         itemBuilder: (BuildContext context, int index) {
//       //           //final Message message = _messages[index];
//       //           //final bool isMe = message.sender == currentUser;
//       //
//       //           return Notice(_notices, isMe);
//       //         },
//       //       ),
//       //     ),
//       //     Divider(height: 1.0),
//       //     Container(
//       //       decoration: BoxDecoration(color: Theme.of(context).cardColor),
//       //       child: _buildTextComposer(),
//       //     ),
//       //   ],
//       // ),
//
//     );
//   }
//
// //공지 입력
//   Future<void> notice(String content) async {
//     final url = Uri.parse('http://3.39.88.187:3000/notice/notices?board_id=3');
//     setState(() => _isLoading = true);
//     final storage = FlutterSecureStorage();
//     final token = await storage.read(key: 'token');
//     if (token == null) {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = '토큰이 없습니다.';
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('공지 입력에 실패했습니다.(로그인 만료)')));
//       });
//       return;
//     }
//     final response = await http.post(
//       url,
//       headers: <String, String>{ //헤더파일 추가
//         'Content-Type': 'application/json; charset=UTF-8',
//         'Authorization': token,
//       },
//       body: jsonEncode( {
//         'comment_content': content,
//       }),
//     );
//     if (response.statusCode == 201) {
//       // 입력 성공 처리
//       // 예시:
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('공지가 성공적으로 입력되었습니다.')));
//       _textController.clear(); // 댓글 입력 완료 후, TextField를 초기화합니다.
//       setState(() {
//         _notices = fetchNotices(); // 댓글 리스트를 다시 불러옵니다.
//       });
//     } else {
//       // 실패 처리
//       // 예시:
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('공지 입력에 실패했습니다.')));
//     }
//   }
//   Widget _buildTextComposer() {
//     return IconTheme(
//       data: IconThemeData(color: Theme.of(context).accentColor),
//       child: Container(
//         margin: EdgeInsets.symmetric(horizontal: 8.0),
//         child: Row(
//           children: <Widget>[
//             Flexible(
//               child: TextField(
//                 controller: _textController, // _textController 할당
//                 onSubmitted: _handleSubmitted,
//                 decoration: InputDecoration.collapsed(hintText: '메시지 보내기'),
//               ),
//             ),
//             Container(
//               margin: EdgeInsets.symmetric(horizontal: 4.0),
//               child: IconButton(
//                 icon: Icon(Icons.send),
//                 onPressed: () {
//                   _handleSubmitted(_textController.text); // clear() 함수 호출 추가
//                   _textController.clear(); // TextField의 글자 지우기
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//   void _handleSubmitted(String text) {
//     _textController.clear(); // TextField 내용 지우기
//     setState(() {
//       final message = Message(
//         text: text,
//         sender: currentUser,
//         time: DateFormat('yyyy-MM-dd kk:mm:ss').format(DateTime.now()),
//         isLiked: false,
//         unread: true,
//       );
//       //_notices.insert(0, message);
//     });
//   }
//
//
//   Widget _buildMessage(Message message, bool isMe) {
//     final Container msg = Container(
//         margin: isMe
//             ? EdgeInsets.only(
//           top: 8.0,
//           bottom: 8.0,
//           left: 80.0,
//         )
//             : EdgeInsets.only(
//           top: 8.0,
//           bottom: 8.0,
//         ),
//         padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
//         decoration: BoxDecoration(
//           color: isMe ? Colors.blue[100] : Colors.grey[200],
//           borderRadius: isMe
//               ? BorderRadius.only(
//             topLeft: Radius.circular(15.0),
//             bottomLeft: Radius.circular(15.0),
//           )
//               : BorderRadius.only(
//             topRight: Radius.circular(15.0),
//             bottomRight: Radius.circular(15.0),
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text(
//               message.sender,
//               style: TextStyle(
//                 color: Colors.grey[800],
//                 fontSize: 16.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 8.0),
//             Text(
//               message.text,
//               style: TextStyle(
//                 color: Colors.grey[800],
//                 fontSize: 16.0,
//                 fontWeight: FontWeight.normal,
//               ),
//             ),
//             SizedBox(height: 8.0),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Text(
//                   message.time,
//                   style: TextStyle(
//                     color: Colors.grey[600],
//                     fontSize: 14.0,
//                     fontWeight: FontWeight.normal,
//                   ),
//                 ),
//                 message.isLiked
//                     ? Icon(
//                   Icons.favorite,
//                   color: Colors.red,
//                   size: 16.0,
//                 )
//                     : SizedBox.shrink(),
//               ],
//             ),
//           ],
//         ));
//
//     if (isMe) {
//       return msg;
//     }
//
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Container(
//           margin: EdgeInsets.only(right: 16.0),
//           child: CircleAvatar(
//             child: Text(
//               message.sender[0],
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             backgroundColor: Colors.blue,
//           ),
//         ),
//         msg,
//       ],
//     );
//   }
//
//   final TextEditingController _textController = TextEditingController();
//   final String currentUser = '내 이름';
// }
//
// class Message {
//   final String text;
//   final String sender;
//   final String time;
//   final bool isLiked;
//   final bool unread;
//
//   Message({
//     required this.text,
//     required this.sender,
//     required this.time,
//     required this.isLiked,
//     required this.unread,
//   });
// }