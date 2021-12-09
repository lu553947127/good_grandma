import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/application.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';

import 'package:good_grandma/pages/examine/examine_detail_title.dart';
import 'package:good_grandma/pages/examine/model/time_select_provider.dart';
import 'package:good_grandma/pages/login/loginBtn.dart';
import 'package:good_grandma/pages/stock/select_customer_page.dart';
import 'package:good_grandma/widgets/add_text_select.dart';
import 'package:good_grandma/widgets/introduce_input.dart';
import 'package:good_grandma/widgets/post_add_input_cell.dart';
import 'package:good_grandma/widgets/select_more_user.dart';
import 'package:provider/provider.dart';

///审核意见页面
class ExamineAdopt extends StatelessWidget {
  final String title;
  final dynamic process;
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
    , this.taskId
    , this.wait
  }) : super(key: key);

  String comment = '';
  String copyUser = '';

  ///通过
  _completeTask(){

    Map<String, dynamic> map = {
      'pass': true,
      'processInstanceId': processInsId,
      'taskId': taskId,
      'comment': comment,
      'copyUser': copyUser
    };

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
    TimeSelectProvider timeSelectProvider = Provider.of<TimeSelectProvider>(context);
    String copyUserName = process['copyUserName'];

    if (copyUserName.isNotEmpty){
      copyUser = process['copyUser'];
      timeSelectProvider.addcopyUserName2(copyUserName);
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(title, style: TextStyle(fontSize: 18, color: Colors.black)),
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
              child: PostAddInputCell(
                  title: '抄送人',
                  value: timeSelectProvider.copyUserName2,
                  hintText: '请选择抄送人',
                  endWidget: Icon(Icons.chevron_right),
                  onTap: () async {
                    Map area = await showMultiSelectList(context, timeSelectProvider, '请选择抄送人');
                    copyUser = area['id'];
                    timeSelectProvider.addcopyUserName2(area['name']);
                  }
              )
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
  final dynamic process;

  const ExamineOperation({Key key, this.title, this.taskId, this.process}) : super(key: key);

  @override
  _ExamineOperationState createState() => _ExamineOperationState();
}

class _ExamineOperationState extends State<ExamineOperation> {

  String customerId = '';
  String customerName = '';
  String comment = '';
  String copyUser = '';

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
      'comment': comment,
      'copyUser': copyUser
    };

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
    TimeSelectProvider timeSelectProvider = Provider.of<TimeSelectProvider>(context);
    String copyUserName = widget.process['copyUserName'];

    if (copyUserName.isNotEmpty){
      copyUser = widget.process['copyUser'];
      timeSelectProvider.addcopyUserName3(copyUserName);
    }
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
                Map select = await showSelectSearchList(context, Api.allUser, '请选择客户', 'name');
                setState(() {
                  customerId = select['id'];
                  customerName = select['name'];
                });
                return select['name'];
              }
          ),
          SizedBox(height: 15),
          PostAddInputCell(
              title: '抄送人',
              value: timeSelectProvider.copyUserName3,
              hintText: '请选择抄送人',
              endWidget: Icon(Icons.chevron_right),
              onTap: () async {
                Map area = await showMultiSelectList(context, timeSelectProvider, '请选择抄送人');
                copyUser = area['id'];
                timeSelectProvider.addcopyUserName3(area['name']);
              }
          ),
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

