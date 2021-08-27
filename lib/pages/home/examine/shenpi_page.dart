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

  // List<Map> list = [
  //   {'name' : '请假审批', 'id': '1'},
  //   {'name' : '费用审批', 'id': '2'},
  //   {'name' : '费用核销审批', 'id': '3'},
  //   {'name' : '营销费用审批', 'id': '9'},
  //   {'name' : '对账审批', 'id': '4'},
  //   {'name' : '费用审批', 'id': '5'},
  //   {'name' : '营销费用审批', 'id': '7'}
  //  ];
  List<Map> list;

  ///我的请求列表
  _sendList(){
    Map<String, dynamic> map = {'current': '1', 'size': '10'};
    requestGet(Api.todoList, param: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---todoList----$data');

    });

    requestGet(Api.sendList, param: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---sendList----$data');

    });

    requestGet(Api.doneList, param: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---doneList----$data');

    });
  }

  ///可发起流程列表
  _processList(){
    Map<String, dynamic> map = {'current': '1', 'size': '999'};
    requestGet(Api.processList, param: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---processList----$data');
      if (data['code'] == 200){
        list = (data['data']['records'] as List).cast();
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
              type: '我申请的',
              list: [
                {'name': '我申请的'},
                {'name': '我审批的'},
                {'name': '知会我的'},
              ],
              onPressed: (){},
              onPressed2: (){},
              onPressed3: (){},
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return ExamineView(date: _list[index]);
                }, childCount: _list.length)
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
                return ExamineSelectDialog(list: list);
              }
          );
        },
      ),
    );
  }
}