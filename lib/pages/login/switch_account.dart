import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/store.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/home/index_page.dart';

///切换身份页面
class SwitchAccountPage extends StatefulWidget {
  final String postId;
  const SwitchAccountPage({Key key, this.postId}) : super(key: key);

  @override
  _SwitchAccountPageState createState() => _SwitchAccountPageState();
}

class _SwitchAccountPageState extends State<SwitchAccountPage> {

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() async {
    requestPostSwitch(Api.loginPassword, formData: {
      'tenantId': '000000',
      'postId': widget.postId,
      'grant_type': 'switch',
      'scope': 'all',
      'type': 'account',
    }).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---loginPasswordSwitch----$data');
      if (data['error_description'] != null){
        Navigator.pop(context);
        showToast(data['error_description']);
      }else {
        Store.saveToken(data['access_token']);
        Store.saveUserId(data['user_id']);
        Store.saveUserName(data['user_name']);
        Store.saveDeptId(data['dept_id']);
        Store.savePostName(data['post_name']);
        Store.saveNickName(data['nick_name']);
        Store.saveUserAvatar(data['avatar']);
        Store.saveUserType(data['user_type']);
        Store.saveAppRoleId(data['appRole']['id']);
        Store.saveIsExamine(data['appRole']['jurisdiction']);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context)=> IndexPage()), (route) => false);
        // Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=> IndexPage()));
        _getDeptName(data['dept_id']);
      }
    });
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
    return Container(
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator(color: AppColors.FFC68D3E),
      )
    );
  }
}
