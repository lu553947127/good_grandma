import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/application.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/login/loginBtn.dart';
import 'package:good_grandma/widgets/add_content_input.dart';
import 'package:good_grandma/widgets/add_text_input.dart';
import 'package:good_grandma/widgets/add_text_select.dart';
import 'package:good_grandma/widgets/select_form.dart';

///新增拜访计划
class VisitPlanAdd extends StatefulWidget {
  const VisitPlanAdd({Key key}) : super(key: key);

  @override
  _VisitPlanAddState createState() => _VisitPlanAddState();
}

class _VisitPlanAddState extends State<VisitPlanAdd> {

  String title = '';
  String visitTime = '';
  String userId = '';
  String userName = '';
  String address = '';
  String visitContent = '';

  ///新增
  _visitPlanAdd(){

    if (title == ''){
      showToast('标题不能为空');
      return;
    }

    if (visitTime == ''){
      showToast('拜访时间不能为空');
      return;
    }

    if (userId == ''){
      showToast('客户不能为空');
      return;
    }

    if (address == ''){
      showToast('地址不能为空');
      return;
    }

    if (visitContent == ''){
      showToast('拜访内容不能为空');
      return;
    }

    Map<String, dynamic> map = {
      'title': title,
      'visitTime': visitTime,
      'userId': userId,
      'userName': userName,
      'address': address,
      'visitContent': visitContent};

    requestPost(Api.visitPlanAdd, json: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---visitPlanAdd----$data');
      if (data['code'] == 200){
        showToast("添加成功");
        Navigator.of(Application.appContext).pop('refresh');
      }else {
        showToast(data['msg']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("新增拜访计划", style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextInputView(
              leftTitle: '标题',
              rightPlaceholder: '请输入标题',
              rightLength: 90,
              onChanged: (tex){
                title = tex;
              }
            ),
            TextSelectView(
              sizeHeight: 1,
              leftTitle: '拜访时间',
              rightPlaceholder: '请选择拜访时间',
              value: visitTime,
              onPressed: () async{
                String time = await showPickerDate(context);
                setState(() {
                  visitTime = time;
                });
                return time;
              }
            ),
            TextSelectView(
              sizeHeight: 1,
              leftTitle: '客户名称',
              rightPlaceholder: '请选择客户',
              value: userName,
              onPressed: () async{
                Map select = await showSelectList(context, Api.customerList, '请选择客户名称', 'realName');
                LogUtil.d('请求结果---select----$select');
                setState(() {
                  userName = select['realName'];
                  userId = select['id'];
                });
                return select['realName'];
              }
            ),
            TextInputView(
              sizeHeight: 1,
              leftTitle: '客户地址',
              rightLength: 90,
              rightPlaceholder: '关联地址',
              onChanged: (tex){
                address = tex;
              }
            ),
            ContentInputView(
              sizeHeight: 10,
              color: Colors.white,
              leftTitle: '拜访内容',
              rightPlaceholder: '拜访内容',
              onChanged: (tex){
                visitContent = tex;
              }
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: LoginBtn(
                title: '提交',
                onPressed: _visitPlanAdd
              )
            )
          ]
        )
      )
    );
  }
}
