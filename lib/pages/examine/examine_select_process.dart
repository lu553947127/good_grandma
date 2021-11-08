import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/pages/examine/examine_select_tree.dart';
import 'package:good_grandma/widgets/post_add_input_cell.dart';

///oa审批选择流程审核列表页面
class ExamineSelectProcess extends StatefulWidget {
  const ExamineSelectProcess({Key key}) : super(key: key);

  @override
  _ExamineSelectProcessState createState() => _ExamineSelectProcessState();
}

class _ExamineSelectProcessState extends State<ExamineSelectProcess> {

  ///审批流程列表
  List<Map> processList = [];

  ///审批类型
  String examineType = '全部';

  ///可发起的流程列表
  _processList(category){
    Map<String, dynamic> map = {'category': category, 'current': '1', 'size': '999'};
    requestGet(Api.processList, param: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---processList----$data');
      processList = (data['data']['records'] as List).cast();
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    _processList('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text('请选择审批流程',style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
        ),
        body: Container(
          color: Colors.white,
          child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                    child: PostAddInputCell(
                        title: '审批类型',
                        value: examineType,
                        hintText: '请选择审批类型',
                        endWidget: Icon(Icons.chevron_right),
                        onTap: () async {
                          Map map = await showSelectExamineTreeList(context);
                          examineType = map['name'];
                          _processList(map['id']);
                        }
                    )
                ),
                processList.length > 0 ?
                SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return ListTile(
                          title: Center(
                            child: Text(processList[index]['name'], style: TextStyle(fontSize: 15, color: Color(0XFF2F4058))),
                          ),
                          onTap: () {
                            Navigator.of(context).pop(processList[index]);
                          }
                      );
                    }, childCount: processList.length)
                ) :
                SliverToBoxAdapter(
                    child: Container(
                        margin: EdgeInsets.all(40),
                        child: Image.asset('assets/images/icon_empty_images.png', width: 150, height: 150)
                    )
                )
              ]
          )
        )
    );
  }
}

///选择返回回调
Future<Map> showSelectProcessList(BuildContext context) async {
  Map result;
  result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ExamineSelectProcess()));
  return result ?? "";
}
