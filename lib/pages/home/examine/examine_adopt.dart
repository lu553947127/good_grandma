import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/application.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/employee_model.dart';

import 'package:good_grandma/pages/home/examine/examine_detail_title.dart';
import 'package:good_grandma/pages/login/loginBtn.dart';
import 'package:good_grandma/pages/stock/select_customer_page.dart';
import 'package:good_grandma/widgets/add_text_select.dart';
import 'package:good_grandma/widgets/introduce_input.dart';

///审核意见页面
class ExamineAdopt extends StatelessWidget {
  final String title;
  var process;
  final String type;
  final String processIsFinished;
  final String processInsId;
  final String taskId;
  final String wait;
  ExamineAdopt({Key key
    , this.title
    , this.process
    , this.type
    , this.processIsFinished
    , this.processInsId
    , this.taskId, this.wait
  }) : super(key: key);

  String comment = '';

  ///通过
  _completeTask(){

    Map<String, dynamic> map = {
      'pass': true,
      'processInstanceId': processInsId,
      'taskId': taskId,
      'comment': comment};

    requestPost(Api.completeTask, json: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---completeTask----$data');

      if (data['code'] == 200){
        showToast("$title成功");
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
        title: Text(title,style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
      ),
      body: CustomScrollView(
        slivers: [
          ExamineDetailTitle(
            avatar: process['user']['avatar'],
            title: process['processDefinitionName'],
            time: '提交时间: ${process['createTime']}',
            wait: wait,
            status: processIsFinished,
            type: type
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 15),
          ),
          SliverToBoxAdapter(
            child: InputWidget(
              placeholder: '请填写$title原因',
              onChanged: (String txt){
                comment = txt;
              }
            )
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: LoginBtn(
                title: '确定',
                onPressed: _completeTask
              )
            )
          )
        ]
      )
    );
  }
}

///转办和委托
class ExamineOperation extends StatefulWidget {
  final String title;
  final String taskId;

  const ExamineOperation({Key key, this.title, this.taskId}) : super(key: key);

  @override
  _ExamineOperationState createState() => _ExamineOperationState();
}

class _ExamineOperationState extends State<ExamineOperation> {

  String customerId = '';
  String customerName = '';
  String comment = '';

  ///转办
  _transferTask(){
    if (customerId == '') {
      showToast("客户不能为空");
      return;
    }

    if (comment == '') {
      showToast("转办原因不能为空");
      return;
    }

    Map<String, dynamic> map = {
      'assignee': customerId,
      'taskId': widget.taskId,
      'comment': comment};

    requestPost(Api.transferTask, json: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---transferTask----$data');
      if (data['code'] == 200){
        showToast("${widget.title}成功");
        Navigator.of(Application.appContext).pop('refresh');
      }else {
        showToast(data['msg']);
      }
    });
  }

  ///委托
  _delegateTask(){
    if (customerId == '') {
      showToast("客户不能为空");
      return;
    }

    if (comment == '') {
      showToast("委托原因不能为空");
      return;
    }

    Map<String, dynamic> map = {
      'assignee': customerId,
      'taskId': widget.taskId,
      'comment': comment};

    requestPost(Api.delegateTask, json: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---delegateTask----$data');
      if (data['code'] == 200){
        showToast("${widget.title}成功");
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
        title: Text(widget.title, style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
      ),
      body: Column(
        children: [
          TextSelectView(
              sizeHeight: 0,
              leftTitle: '客户名称',
              rightPlaceholder: '请选择客户',
              value: customerName,
              onPressed: () async{
                EmployeeModel model = await Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return SelectCustomerPage(url: Api.allUser);
                }));

                setState(() {
                  customerId = model.id;
                  customerName = model.name;
                });

                return model.name;
              }
          ),
          SizedBox(height: 15),
          InputWidget(
            placeholder: '请填写${widget.title}原因',
            onChanged: (String txt){
              comment = txt;
            }
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: LoginBtn(
                title: '确定',
                onPressed: widget.title == '转办' ? _transferTask : _delegateTask
            )
          )
        ]
      )
    );
  }
}

