import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/home/examine/examine_select.dart';
import 'package:good_grandma/pages/home/examine/examine_view.dart';
import 'package:good_grandma/pages/work/work_report/work_type_title.dart';
///审批
class ShenPiPage extends StatefulWidget {
  const ShenPiPage({Key key}) : super(key: key);

  @override
  _ShenPiPageState createState() => _ShenPiPageState();
}

class _ShenPiPageState extends State<ShenPiPage> {

  final List<Map> _list = [
    {'title': '事假申请', 'status': '审核中', 'time' : '2012-05-29 16:31:50',
      'list' : [
        {
          "title":"请假类型",
          "content":"事假",
        },
        {
          "title":"请假日期",
          "content":"2021-7-20 — 2021-7-22",
        },
        {
          "title":"请假天数",
          "content":"2天",
        }
      ]
    },
    {'title': '费用申请', 'status': '已审核', 'time' : '2012-05-29 16:31:50',
      'list' : [
        {
          "title":"费用类别",
          "content":"固定费用 - 差旅费用",
        },
        {
          "title":"费用金额",
          "content":"¥1万元",
        }
      ]
    },
  ];

  List<Map> list = [];
  List<Map> sendList = [];
  List<Map> todoList = [];
  List<Map> copyList = [];
  String type = '我申请的';
  List<Map> listTitle = [
    {'name': '我申请的'},
    {'name': '我审批的'},
    {'name': '知会我的'},
  ];
  List<Map> listType;

  ///我的请求列表(我申请的)
  _sendList(){
    Map<String, dynamic> map = {'current': '1', 'size': '999'};
    requestGet(Api.sendList, param: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---sendList----$data');
      setState(() {
        sendList = (data['data']['records'] as List).cast();
        type = listTitle[0]['name'];
        list = sendList;
      });
    });
  }

  ///待办列表(我审批的)
  _todoList(){
    LogUtil.d('请求结果---todoList----');
    Map<String, dynamic> map = {'current': '1', 'size': '999'};
    requestGet(Api.todoList, param: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---todoList----$data');
      setState(() {
        todoList = (data['data']['records'] as List).cast();
        type = listTitle[1]['name'];
        list = todoList;
      });
    });
  }

  ///我的抄送列表(知会我的)
  _copyList(){
    Map<String, dynamic> map = {'current': '1', 'size': '999'};
    requestGet(Api.copyList, param: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---copyList----$data');
      setState(() {
        copyList = (data['data']['records'] as List).cast();
        type = listTitle[2]['name'];
        list = copyList;
      });
    });
  }

  ///可发起流程列表
  _processList(){
    Map<String, dynamic> map = {'current': '1', 'size': '999'};
    requestGet(Api.processList, param: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---processList----$data');
      if (data['code'] == 200){
        listType = (data['data']['records'] as List).cast();
      }else {
        showToast(data['msg']);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _sendList();
    _processList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('审批申请'),
      ),
      body: CustomScrollView(
          slivers: [
            WorkTypeTitle(
              color: null,
              type: type,
              list: listTitle,
              onPressed: (){
                _sendList();
              },
              onPressed2: (){
                _todoList();
              },
              onPressed3: (){
                _copyList();
              },
            ),
            list.length > 0 ?
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return ExamineView(data: list[index]);
                }, childCount: list.length)
            ) :
            SliverToBoxAdapter(
                child: Center(
                    child: Text('暂无数据')
                )
            )
          ]
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color(0xFFC68D3E),
        onPressed: () async{
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return ExamineSelectDialog(list: listType);
              }
          );
        },
      ),
    );
  }
}