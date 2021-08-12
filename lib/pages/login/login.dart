import 'dart:async';
import 'package:flutter/material.dart';
import 'package:good_grandma/pages/home/home.dart';
import 'package:good_grandma/pages/login/forget.dart';
import 'package:good_grandma/pages/login/loginBackground.dart';
import 'package:good_grandma/pages/login/loginBtn.dart';
import 'package:good_grandma/pages/login/loginEditText.dart';
import 'package:good_grandma/pages/work/work.dart';

///登录页面
class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _account = TextEditingController();
  TextEditingController _code = TextEditingController();
  bool _isAccount= false;//是否记住账号
  bool _isPassword= false;//是否记住密码
  bool visible = true;//控件显示与隐藏

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

    ///账号密码登录布局
    Widget _accountView(){
      return Offstage(
        offstage: visible ? false : true,
        child: Column(
          children: <Widget>[
            LoginEditText(
              textEditingController: _username,
              text: '请输入账号',
              images: 'assets/images/ic_login_name.png',
            ),
            SizedBox(height: 10),
            LoginEditText(
              textEditingController: _password,
              text: '请输入密码',
              images: 'assets/images/ic_login_password.png',
            )
          ],
        ),
      );
    }

    ///验证码登录布局
    Widget _codeView(){
      return Offstage(
        offstage: visible ? true : false,
        child: Column(
          children: <Widget>[
            LoginEditText(
              textEditingController: _account,
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
                        final account = _account.text;
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
            )
          ],
        ),
      );
    }

    ///记住账号 记住密码选择框
    Widget _accountOrPassword(){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Checkbox(
                value: _isAccount,
                activeColor: Color(0xFFC68D3E),
                onChanged: (value){
                  setState(() {
                    _isAccount = value;
                  });
                },
              ),
              Text('记住账号',style: TextStyle(fontSize: 14,color: Color(0XFF333333)))
            ],
          ),
          Offstage(
            offstage: visible ? false : true,
            child: Row(
              children: <Widget>[
                Checkbox(
                  value: _isPassword,
                  activeColor: Color(0xFFC68D3E),
                  onChanged: (value){
                    setState(() {
                      _isPassword = value;
                    });
                  },
                ),
                Text('记住密码',style: TextStyle(fontSize: 14,color: Color(0XFF333333)))
              ],
            ),
          )
        ],
      );
    }

    ///验证码登录 忘记密码
    Widget _codeOrForget(){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
            child: Text(visible ? '验证码登录' : '密码登录', style: TextStyle(color: Color(0xFF2F4058), fontSize: 12),),
            //点击快速注册、执行事件
            onPressed: (){
              visible = !visible;
              setState(() {});
            },
          ),
          Offstage(
            offstage: visible ? false : true,
            child: FlatButton(
              child: Text("忘记密码", style: TextStyle(color: Color(0xFF2F4058), fontSize: 12)),
              //忘记密码按钮，点击执行事件
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder:(context)=> ForgetPassword()));
              },
            ),
          )
        ],
      );
    }

    return Scaffold(
      body: LoginBackground(
        child: Container(
          margin: EdgeInsets.only(top: 245, left: 40, right: 40),
          child: ListView(
            children: <Widget>[
              Text(visible ? '登录' : '手机登录',style: TextStyle(fontSize: 20,color: Color(0XFF333333))),
              SizedBox(height: 20),
              _accountView(),
              _codeView(),
              _accountOrPassword(),
              SizedBox(height: 10),
              LoginBtn(
                title: '登录',
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder:(context)=> HomePage()));
                },
              ),
              SizedBox(height: 10),
              _codeOrForget()
            ],
          ),
        ),
      ),
    );
  }
}
