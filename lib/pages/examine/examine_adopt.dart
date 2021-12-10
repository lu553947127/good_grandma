import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/application.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';

import 'package:good_grandma/pages/examine/examine_detail_title.dart';
import 'package:good_grandma/pages/examine/model/time_select_provider.dart';
import 'package:good_grandma/pages/login/loginBtn.dart';
import 'package:good_grandma/pages/stock/select_customer_page.dart';
import 'package:good_grandma/widgets/activity_add_text_cell.dart';
import 'package:good_grandma/widgets/add_text_select.dart';
import 'package:good_grandma/widgets/introduce_input.dart';
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

  @override
  Widget build(BuildContext context) {
    TimeSelectProvider timeSelectProvider = Provider.of<TimeSelectProvider>(context);
    String copyUser = process['copyUser'];
    String copyUserName = process['copyUserName'];

    List<String> copyUserList = copyUser.split(',');
    List<String> copyUserNameList = copyUserName.split(',');
    if (copyUser.isNotEmpty){
      for(int i = 0; i < copyUserList.length; i++){
        Map addData = new Map();
        addData['id'] = copyUserList[i];
        addData['name'] = copyUserNameList[i];
        timeSelectProvider.userMapList.add(addData);
      }
    }

    ///通过
    _completeTask(){

      List<String> idList = [];
      timeSelectProvider.userMapList.forEach((element) {
        idList.add(element['id']);
      });

      Map<String, dynamic> map = {
        'pass': true,
        'processInstanceId': processInsId,
        'taskId': taskId,
        'comment': comment,
        'copyUser': listToString(idList)
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
              child: InputWidget(
                  placeholder: '请填写$title原因',
                  onChanged: (String txt){
                    comment = txt;
                  }
              )
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 10),
          ),
          SliverToBoxAdapter(
              child: Container(
                  height: 60,
                  color: Colors.white,
                  child: ListTile(
                    title: Text('请选择抄送人', style: TextStyle(color: AppColors.FF070E28, fontSize: 15.0)),
                    trailing: IconButton(
                        onPressed: () async {
                          Map select = await showSelectUserList(context, Api.sendSelectUser, '请选择抄送人', 'name');
                          timeSelectProvider.addUserModel(select['id'], select['name']);
                        },
                        icon: Icon(Icons.add_circle, color: AppColors.FFC68D3E)),
                  )
              )
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                Map userMap = timeSelectProvider.userMapList[index];
                return Column(
                    children: [
                      SizedBox(height: 1),
                      ActivityAddTextCell(
                          title: userMap['name'],
                          hintText: '',
                          value: '',
                          trailing: IconButton(
                              onPressed: (){
                                timeSelectProvider.deleteUserModelWith(index);
                              },
                              icon: Icon(Icons.delete, color: AppColors.FFDD0000)
                          ),
                          onTap: null
                      )
                    ]
                );
              }, childCount: timeSelectProvider.userMapList.length)),
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

  @override
  Widget build(BuildContext context) {
    TimeSelectProvider timeSelectProvider = Provider.of<TimeSelectProvider>(context);
    String copyUser = widget.process['copyUser'];
    String copyUserName = widget.process['copyUserName'];

    List<String> copyUserList = copyUser.split(',');
    List<String> copyUserNameList = copyUserName.split(',');
    if (copyUser.isNotEmpty){
      for(int i = 0; i < copyUserList.length; i++){
        Map addData = new Map();
        addData['id'] = copyUserList[i];
        addData['name'] = copyUserNameList[i];
        timeSelectProvider.userMapList.add(addData);
      }
    }

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

      List<String> idList = [];
      timeSelectProvider.userMapList.forEach((element) {
        idList.add(element['id']);
      });

      Map<String, dynamic> map = {
        'assignee': customerId,
        'taskId': widget.taskId,
        'comment': comment,
        'copyUser': listToString(idList)
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

      List<String> idList = [];
      timeSelectProvider.userMapList.forEach((element) {
        idList.add(element['id']);
      });

      Map<String, dynamic> map = {
        'assignee': customerId,
        'taskId': widget.taskId,
        'comment': comment,
        'copyUser': listToString(idList)
      };

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

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(widget.title, style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: TextSelectView(
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
            )
          ),
          SliverToBoxAdapter(
              child: SizedBox(height: 10)
          ),
          SliverToBoxAdapter(
              child: InputWidget(
                  placeholder: '请填写${widget.title}原因',
                  onChanged: (String txt){
                    comment = txt;
                  }
              )
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 10)
          ),
          SliverToBoxAdapter(
              child: Container(
                  height: 60,
                  color: Colors.white,
                  child: ListTile(
                    title: Text('请选择抄送人', style: TextStyle(color: AppColors.FF070E28, fontSize: 15.0)),
                    trailing: IconButton(
                        onPressed: () async {
                          Map select = await showSelectUserList(context, Api.sendSelectUser, '请选择抄送人', 'name');
                          timeSelectProvider.addUserModel(select['id'], select['name']);
                        },
                        icon: Icon(Icons.add_circle, color: AppColors.FFC68D3E)),
                  )
              )
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                Map userMap = timeSelectProvider.userMapList[index];
                return Column(
                    children: [
                      SizedBox(height: 1),
                      ActivityAddTextCell(
                          title: userMap['name'],
                          hintText: '',
                          value: '',
                          trailing: IconButton(
                              onPressed: (){
                                timeSelectProvider.deleteUserModelWith(index);
                              },
                              icon: Icon(Icons.delete, color: AppColors.FFDD0000)
                          ),
                          onTap: null
                      )
                    ]
                );
              }, childCount: timeSelectProvider.userMapList.length)),
          SliverToBoxAdapter(
            child: Padding(
                padding: EdgeInsets.all(20),
                child: LoginBtn(
                    title: '确定',
                    onPressed: widget.title == '转办' ? _transferTask : _delegateTask
                )
            )
          )
        ]
      )
    );
  }
}

