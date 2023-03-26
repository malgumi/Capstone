import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget { //StatefulWidget 로 설정
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> { //LoginPage  --> _LoginPageState 로 이동
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController student_id = TextEditingController();  //각각 변수들 지정
  TextEditingController password = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() { //initState 초기화를 위해 필요한 저장공간.
    super.initState();
    student_id = TextEditingController(text: ""); //변수를 여기서 초기화함.
    password = TextEditingController(text: "");
  }

  @override
  void dispose() {
    student_id.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) { //Widget 여기서 UI화면 작성
    return Scaffold(
        appBar: AppBar(
        title: Text('로그인'), //APP BAR 만들기
        ),
        body: Padding( //body는 appbar아래 화면을 지정.
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Center( //가운데로 지정
            child: ListView( //ListView - children으로 여러개 padding설정
                shrinkWrap: true,
                children: <Widget>[
            Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField( //TextFormField
              controller: student_id, //student_id이 TextEditingController
              validator: (value) =>
              (value!.isEmpty) ? "학번을 입력해 주세요" : null, //hint 역할
              style: style,
              decoration: InputDecoration( //textfield안에 있는 이미지
                  prefixIcon: Icon(Icons.email),
                  labelText: "학번", //hint
                  border: OutlineInputBorder()), //클릭시 legend 효과
            ),
          ),
          Padding( //두번째 padding <- LIstview에 속함.
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                  obscureText: true,
                  controller: password,
                  validator: (value) =>
                  (value!.isEmpty) ? "비밀번호를 입력해 주세요" : null, //아무것도 누르지 않은 경우 이 글자 뜸.
              style: style,
              decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock),
              labelText: "비밀번호",
              border: OutlineInputBorder()),
        ),
      ),
      Padding( //세번째 padding
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Material(
          elevation: 5.0, //그림자효과
          borderRadius: BorderRadius.circular(30.0), //둥근효과
          color: const Color(0xffC1D3FF),
          child: MaterialButton( //child - 버튼을 생성
            onPressed: () {
              if (_formKey.currentState!.validate()) {

              }
            },
            child: Text(
              "로그인",
              style: style.copyWith(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      SizedBox(height: 10), //View같은 역할 중간에 띄는 역할
      Center( //Center <- Listview
        child: InkWell( //InkWell을 사용 -- onTap이 가능한 이유임.
          child: Text(
            '가입하기',
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpPage()),
            );
          },
        ),
      ),

    ],
        ),
    ),
    ),
    ),
    );
}
}
/// 회원가입 화면
class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController student_id = TextEditingController();
  TextEditingController password= TextEditingController();
  TextEditingController password2 = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    student_id = TextEditingController(text: "");
    password = TextEditingController(text: "");
    password2 = TextEditingController(text: "");
  }

  @override
  void dispose() {
    student_id.dispose();
    password.dispose();
    password2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text("계정 만들기"),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: student_id,
                  validator: (value) =>
                  (value!.isEmpty) ? "학번을 입력 해 주세요" : null,
                  style: style,
                  decoration: InputDecoration(
                      labelText: "학번",
                      border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  obscureText: true,
                  controller: password,
                  validator: (value) =>
                  (value!.isEmpty) ? "비밀번호를 입력 해 주세요" : null,
                  style: style,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: "비밀번호",
                      border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  obscureText: true,
                  controller: password2,
                  validator: (value) =>
                  (value != password.text) ? "비밀번호가 다릅니다" : null,
                  style: style,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: "비밀번호 확인",
                      border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30.0),
                  color: const Color(0xffC1D3FF),
                  child: MaterialButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      "회원 가입",
                      style: style.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
