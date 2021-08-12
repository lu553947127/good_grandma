import 'package:flutter/material.dart';
import 'package:good_grandma/pages/login/loginBackground.dart';

///登录页面
class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _username = TextEditingController();

  @override
  Widget build(BuildContext context) {

    //手机号码
    Widget _phone(){
      return Container(

        child: TextField(
          controller: _username,
          style: TextStyle(fontSize: 32,color: Color(0xFF333333)),
          decoration: InputDecoration(
              hintText: "请输入账户号码",
              hintStyle: TextStyle(fontSize: 32,color: Color(0XFFCCCCCC)),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Color(0XFFF5F6F6)
                  )
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Color(0XFF89018B)
                  )
              )
          ),
        ),
      );
    }

    return Scaffold(
      body: LoginBackground(
        child: Container(
          margin: EdgeInsets.only(top: 245, left: 40),
          child: ListView(
            children: <Widget>[
              Text('登录',style: TextStyle(fontSize: 20,color: Color(0XFF333333))),
              _phone()
            ],
          ),
        ),
      ),
    );
  }
}
