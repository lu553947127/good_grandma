import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/home/examine/examine_detail.dart';
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

  String type = '我申请的';
  List<Map> listTitle = [
    {'name': '我申请的'},
    {'name': '我审批的'},
    {'name': '知会我的'},
  ];
  ///审批申请列表数据
  List<Map> list = [];
  ///我申请的列表
  List<Map> sendList = [];
  ///我审批的列表
  List<Map> todoList = [];
  ///知会我的列表
  List<Map> copyList = [];
  ///可发起的流程列表
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
  void deactivate() {
    var bool = ModalRoute.of(context).isCurrent;
    if (bool) {
      _sendList();
      _processList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                  String processIsFinished = list[index]['processIsFinished'] == 'unfinished' ? '审核中' : '已审核';
                  return ExamineView(
                    data: list[index],
                    type: type,
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder:(context)=> ExamineDetail(
                        processInsId: list[index]['processInstanceId'],
                        taskId: list[index]['taskId'],
                        type: type,
                        processIsFinished: processIsFinished,
                        status: list[index]['status'],
                      ))).then((value) => _sendList());
                    }
                  );
                }, childCount: list.length)
            ) :
            SliverToBoxAdapter(
                child: Container(
                    margin: EdgeInsets.all(40),
                    child: Image.asset('assets/images/icon_empty_images.png', width: 150, height: 150)
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