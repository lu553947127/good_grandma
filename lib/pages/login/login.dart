import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/application.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/store.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/home/index_page.dart';
import 'package:good_grandma/pages/login/forget.dart';
import 'package:good_grandma/pages/login/loginBackground.dart';
import 'package:good_grandma/pages/login/loginBtn.dart';
import 'package:good_grandma/pages/login/loginEditText.dart';
import 'package:good_grandma/widgets/progerss_dialog.dart';

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
  bool _isAccount = false;//是否记住账号
  bool _isPassword = false;//是否记住密码
  bool _isPhone = false;//是否记住手机号
  bool visible = true;//控件显示与隐藏

  Timer _timer;
  int _countdownTime = 60;
  String _autoCodeText = '获取验证码';

  @override
  void initState() {
    super.initState();
    _username.text = Store.readAccount();
    _password.text = Store.readPassword();
    _account.text = Store.readPhone();

    if (Store.readAccount() != null && Store.readAccount().isNotEmpty){
      _isAccount = true;
    }

    if (Store.readPassword() != null && Store.readPassword().isNotEmpty){
      _isPassword = true;
    }

    if (Store.readPhone() != null && Store.readPhone().isNotEmpty){
      _isPhone = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  ///获取部门名称
  _getDeptName(dept_id){
    Map<String, dynamic> map = {'id': dept_id};
    requestGet(Api.getDeptName, param: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---getDeptName----$data');
      Store.saveDeptName(data['data']);
    });
  }

  @override
  Widget build(BuildContext context) {
    Application.appContext = context;

    ///密码登录
    _loginPassword() async{
      final username = _username.text;
      final password = _password.text;

      if (username.isEmpty || password.isEmpty) {
        showToast("用户名和密码不能为空");
        return;
      }

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return NetLoadingDialog(
              requestCallBack: null,
              outsideDismiss: false
            );
          });

      requestPostLogin(Api.loginPassword, formData: {
        'tenantId': '000000',
        'username': username,
        'password': passwordMD5(password),
        'grant_type': 'app',
        'scope': 'all',
        'type': 'account',
      }).then((val) async{
        var data = json.decode(val.toString());
        LogUtil.d('请求结果---loginPassword----$data');
        if (data['error_description'] != null){
          Navigator.pop(context);
          // showToast(data['error_description']);
          showToast('登录失败');
        }else {
          if (_isAccount){
            Store.saveAccount(_username.text);
          }else {
            Store.removeAccount();
          }
          if (_isPassword){
            Store.savePassword(_password.text);
          }else {
            Store.removePassword();
          }
          Store.saveToken(data['access_token']);
          Store.saveUserId(data['user_id']);
          Store.saveUserName(data['user_name']);
          Store.saveDeptId(data['dept_id']);
          Store.savePostName(data['post_name']);
          Store.saveNickName(data['nick_name']);
          Store.saveUserAvatar(data['avatar']);
          Store.saveUserType(data['user_type']);
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context)=> IndexPage()), (route) => false);
          // Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=> IndexPage()));
          _getDeptName(data['dept_id']);
        }
      });
    }

    ///验证码登录
    _loginCode() async {
      final account = _account.text;
      final code = _code.text;

      if (account.isEmpty || code.isEmpty) {
        showToast("手机号和验证码不能为空");
        return;
      }

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return NetLoadingDialog(
              requestCallBack: null,
              outsideDismiss: false,
            );
          });

      requestPostLogin(Api.loginPassword, formData: {
        'tenantId': '000000',
        'phone': account,
        'code': code,
        'grant_type': 'phone',
        'scope': 'all',
        'type': 'account',
      }).then((val) async{
        var data = json.decode(val.toString());
        LogUtil.d('请求结果---loginPassword----$data');
        if (data['error_description'] != null){
          Navigator.pop(context);
          showToast(data['error_description']);
        }else {
          if (_isPhone){
            Store.savePhone(_account.text);
          }else {
            Store.removePhone();
          }
          Store.saveToken(data['access_token']);
          Store.saveUserId(data['user_id']);
          Store.saveUserName(data['user_name']);
          Store.saveDeptId(data['dept_id']);
          Store.savePostName(data['post_name']);
          Store.saveNickName(data['nick_name']);
          Store.saveUserAvatar(data['avatar']);
          Store.saveUserType(data['user_type']);
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context)=> IndexPage()), (route) => false);
          // Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=> IndexPage()));
          _getDeptName(data['dept_id']);
        }
      });
    }

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
      Map<String, dynamic> map = {'phone': _account.text, 'type': '2'};
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
                type: TextInputType.text,
                passwordVisible: false
            ),
            SizedBox(height: 10),
            LoginEditText(
              textEditingController: _password,
              text: '请输入密码',
              images: 'assets/images/ic_login_password.png',
              type: TextInputType.visiblePassword,
              passwordVisible: true
            )
          ]
        )
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
                    decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFC68D3E),Color(0xFFC68D3E)]), borderRadius: BorderRadius.circular(40)),
                    child: TextButton(
                      child: Text(_autoCodeText, style: TextStyle(fontSize: 12, color: Colors.white)),
                      onPressed: (){
                        final account = _account.text;
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
            )
          ]
        )
      );
    }

    ///记住账号 记住密码选择框
    Widget _accountOrPassword(){
      return Visibility(
          visible: visible ? true : false,
          child: Row(
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
                          }
                      ),
                      Text('记住账号',style: TextStyle(fontSize: 14,color: Color(0XFF333333)))
                    ]
                ),
                Row(
                    children: <Widget>[
                      Checkbox(
                          value: _isPassword,
                          activeColor: Color(0xFFC68D3E),
                          onChanged: (value){
                            setState(() {
                              _isPassword = value;
                            });
                          }
                      ),
                      Text('记住密码',style: TextStyle(fontSize: 14,color: Color(0XFF333333)))
                    ]
                )
              ]
          )
      );
    }

    ///记住手机号
    Widget _phone(){
      return Visibility(
          visible: visible ? false : true,
          child: Row(
              children: <Widget>[
                Checkbox(
                    value: _isPhone,
                    activeColor: Color(0xFFC68D3E),
                    onChanged: (value){
                      setState(() {
                        _isPhone = value;
                      });
                    }
                ),
                Text('记住手机号',style: TextStyle(fontSize: 14,color: Color(0XFF333333)))
              ]
          )
      );
    }

    ///验证码登录 忘记密码
    Widget _codeOrForget(){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TextButton(
            child: Text(visible ? '验证码登录' : '密码登录', style: TextStyle(color: Color(0xFF2F4058), fontSize: 12),),
            //点击快速注册、执行事件
            onPressed: (){
              visible = !visible;
              setState(() {});
            }
          ),
          Offstage(
            offstage: visible ? false : true,
            child: TextButton(
              child: Text("忘记密码", style: TextStyle(color: Color(0xFF2F4058), fontSize: 12)),
              //忘记密码按钮，点击执行事件
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder:(context)=> ForgetPassword()));
              }
            )
          )
        ]
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
              _phone(),
              SizedBox(height: 10),
              LoginBtn(
                title: '登录',
                onPressed: visible ? _loginPassword : _loginCode
              ),
              SizedBox(height: 10),
              _codeOrForget()
            ]
          )
        )
      )
    );
  }
}
