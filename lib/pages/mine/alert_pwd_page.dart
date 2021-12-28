import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/widgets/submit_btn.dart';

///修改密码
class AlertPWDPAge extends StatefulWidget {
  const AlertPWDPAge({Key key}) : super(key: key);

  @override
  _AlertPWDPAgeState createState() => _AlertPWDPAgeState();
}

class _AlertPWDPAgeState extends State<AlertPWDPAge> {
  FocusNode _focusNode = FocusNode();
  TextEditingController _editingController = TextEditingController();
  FocusNode _focusNode1 = FocusNode();
  TextEditingController _editingController1 = TextEditingController();
  FocusNode _focusNode2 = FocusNode();
  TextEditingController _editingController2 = TextEditingController();

  ///修改登录密码
  void _restPassword(BuildContext context){
    Map<String, dynamic> map = {
      'oldPassword': _editingController.text,
      'newPassword': _editingController1.text,
      'newPasswordAgain': _editingController2.text
    };

    requestGet(Api.restPassword, param: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---restPassword----$data');
      if (data['code'] == 200){
        EasyLoading.showToast("成功");
        Navigator.pop(context);
      }else {
        EasyLoading.showToast(data['msg']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('修改密码')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                      '修改密码',
                      style: const TextStyle(color: AppColors.FF959EB1, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ))
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                TextField(
                  controller: _editingController,
                  focusNode: _focusNode,
                  maxLines: 1,
                  textInputAction: TextInputAction.done,
                  autofocus: true,
                  obscureText: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(),
                    hintText: '请输入旧密码',
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: const TextStyle(
                        color: AppColors.FF959EB1, fontSize: 14),
                  ),
                ),
                const Divider(height: 1),
                TextField(
                  controller: _editingController1,
                  focusNode: _focusNode1,
                  maxLines: 1,
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(),
                    hintText: '请输入新密码',
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: const TextStyle(
                        color: AppColors.FF959EB1, fontSize: 14),
                  ),
                ),
                const Divider(height: 1),
                TextField(
                  controller: _editingController2,
                  focusNode: _focusNode2,
                  maxLines: 1,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(),
                    hintText: '请确认新密码',
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: const TextStyle(
                        color: AppColors.FF959EB1, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          SubmitBtn(title: '确认', onPressed: () {
            if(_editingController.text.isEmpty){
              EasyLoading.showToast('旧密码不能为空');
              return;
            }
            if(_editingController1.text.isEmpty){
              EasyLoading.showToast('新密码不能为空');
              return;
            }
            if(_editingController.text == _editingController1.text){
              EasyLoading.showToast('新密码与旧密码相同');
              return;
            }
            if(_editingController2.text != _editingController1.text){
              EasyLoading.showToast('两次输入的新密码不一致');
              return;
            }
            _restPassword(context);
          }),
        ],
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
    _editingController?.dispose();
    _focusNode?.dispose();
    _editingController1?.dispose();
    _focusNode1?.dispose();
  }
}
