import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:good_grandma/pages/login/loginEditText.dart';
import 'package:good_grandma/pages/work/work.dart';
import 'loginBackground.dart';
import 'loginBtn.dart';

///忘记密码
class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {

  TextEditingController _phone = TextEditingController();
  TextEditingController _code = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _password2 = TextEditingController();

  Timer _timer;
  int _countdownTime = 60;
  String _autoCodeText = '获取验证码';

  @override
  Widget build(BuildContext context) {

    ///开始倒计时
    void startCountdownTimer() {
      _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) => {
        setState(() {
          if (_countdownTime <= 0) {
            _timer.cancel();
            _countdownTime = 60;
            _autoCodeText = '重新获取';
          } else {
            _countdownTime = _countdownTime - 1;
            _autoCodeText = '等待$_countdownTime秒';
          }
        })
      });
    }

    return Scaffold(
      body: LoginBackground(
        child: Container(
          margin: EdgeInsets.only(top: 245, left: 40, right: 40),
          child: ListView(
            children: <Widget>[
              Text('重置密码',style: TextStyle(fontSize: 20,color: Color(0XFF333333))),
              SizedBox(height: 10),
              LoginEditText(
                textEditingController: _phone,
                text: '请输入手机号',
                images: 'assets/images/ic_login_phone.png',
              ),
              SizedBox(height: 10),
              Stack(
                children: <Widget>[
                  LoginEditText(
                    textEditingController: _code,
                    text: '请输入验证码',
                    images: 'assets/images/ic_login_code.png',
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFC68D3E),Color(0xFFC68D3E)]), borderRadius: BorderRadius.circular(40)),
                      child: FlatButton(
                        child: Text(_autoCodeText, style: TextStyle(fontSize: 12, color: Colors.white)),
                        onPressed: (){
                          final account = _phone.text;
                          if (account.isEmpty) {
                            print("验证码不能为空");
                            return;
                          }
                          startCountdownTimer();
                        },
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              LoginEditText(
                textEditingController: _password,
                text: '请输入新密码',
                images: 'assets/images/ic_login_password.png',
              ),
              SizedBox(height: 10),
              LoginEditText(
                textEditingController: _password2,
                text: '请确认新密码',
                images: 'assets/images/ic_login_password.png',
              ),
              SizedBox(height: 10),
              LoginBtn(
                title: '重置',
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder:(context)=> WorkPage()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
