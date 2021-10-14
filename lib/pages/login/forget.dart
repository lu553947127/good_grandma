import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/login/loginEditText.dart';
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

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

    ///获取手机验证码 type 1修改密码  2登录  3更换手机 4签合同
    void _getCode(){
      Map<String, dynamic> map = {'phone': _phone.text, 'type': '1'};
      requestGet(Api.getCode, param: map).then((val) async{
        var data = json.decode(val.toString());
        LogUtil.d('请求结果---getCode----$data');
        if (data['code'] == 200){
          startCountdownTimer();
        }else {
          AppUtil.showToastCenter(data['msg']);
        }
      });
    }

    ///重置密码
    void _restPassword(){

      if(_phone.text.isEmpty){
        Fluttertoast.showToast(msg: '手机号不能为空',gravity: ToastGravity.CENTER);
        return;
      }
      if(_code.text.isEmpty){
        Fluttertoast.showToast(msg: '验证码不能为空',gravity: ToastGravity.CENTER);
        return;
      }
      if(_password.text.isEmpty){
        Fluttertoast.showToast(msg: '新密码不能为空',gravity: ToastGravity.CENTER);
        return;
      }
      if(_password.text != _password2.text){
        Fluttertoast.showToast(msg: '两次输入的新密码不一致',gravity: ToastGravity.CENTER);
        return;
      }

      Map<String, dynamic> map = {
        'phone': _phone.text,
        'code': _code.text,
        'newPassword': _password.text,
        'newPasswordAgain': _password2.text
      };
      requestGet(Api.forgetPassword, param: map).then((val) async{
        var data = json.decode(val.toString());
        LogUtil.d('请求结果---forgetPassword----$data');
        if (data['code'] == 200){
          Navigator.pop(context);
          showToast('重置密码成功');
        }else {
          AppUtil.showToastCenter(data['msg']);
        }
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
                  type: TextInputType.number,
                  passwordVisible: false
              ),
              SizedBox(height: 10),
              Stack(
                children: <Widget>[
                  LoginEditText(
                    textEditingController: _code,
                    text: '请输入验证码',
                    images: 'assets/images/ic_login_code.png',
                      type: TextInputType.number,
                      passwordVisible: false
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(gradient: LinearGradient(
                          colors: [Color(0xFFC68D3E),Color(0xFFC68D3E)]),
                          borderRadius: BorderRadius.circular(40)),
                      child: TextButton(
                        child: Text(_autoCodeText, style: TextStyle(fontSize: 12, color: Colors.white)),
                        onPressed: (){
                          final account = _phone.text;
                          if (account.isEmpty) {
                            showToast("手机号不能为空");
                            return;
                          }
                          _getCode();
                        }
                      )
                    )
                  )
                ]
              ),
              SizedBox(height: 10),
              LoginEditText(
                textEditingController: _password,
                text: '请输入新密码',
                images: 'assets/images/ic_login_password.png',
                  type: TextInputType.visiblePassword,
                  passwordVisible: true
              ),
              SizedBox(height: 10),
              LoginEditText(
                textEditingController: _password2,
                text: '请确认新密码',
                images: 'assets/images/ic_login_password.png',
                  type: TextInputType.visiblePassword,
                  passwordVisible: true
              ),
              SizedBox(height: 10),
              LoginBtn(
                title: '重置',
                onPressed: _restPassword
              )
            ]
          )
        )
      )
    );
  }
}
