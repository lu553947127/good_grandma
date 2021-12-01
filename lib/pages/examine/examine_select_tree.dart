import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/provider/select_tree_provider.dart';
import 'package:provider/provider.dart';

///选择oa审批类型
class ExamineSelectTree extends StatefulWidget {
  ExamineSelectTree({Key key}) : super(key: key);

  @override
  _ExamineSelectTreeState createState() => _ExamineSelectTreeState();
}

class _ExamineSelectTreeState extends State<ExamineSelectTree> {

  List<Map> categoryList = [];

  String pid_equal = '0';

  String id = '';

  ///oa类别下级列表
  _categoryList(String pid_equal){
    Map<String, dynamic> map = {
      'pid_equal': pid_equal,
      'size': '-1'
    };

    requestGet(Api.categoryList, param: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---categoryList----$data');
      setState(() {
        categoryList = (data['data']['records'] as List).cast();
        id = pid_equal;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _categoryList(pid_equal);
  }

  @override
  Widget build(BuildContext context) {
    SelectTreeProvider selectTreeProvider = Provider.of<SelectTreeProvider>(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text('请选择审批类型', style: TextStyle(fontSize: 18, color: Colors.black)),
          actions: [
            TextButton(
                child: Text("确定", style: TextStyle(fontSize: 14, color: Color(0xFFC08A3F))),
                onPressed: () {
                  if (selectTreeProvider.horizontalList.length == 1){
                    showToast('选择审批类型不能为空');
                    return;
                  }
                  Map addData = new Map();
                  ///区域名称
                  List<String> areaString = [];
                  for (Map map in selectTreeProvider.horizontalList) {
                    areaString.add(map['name']);
                  }
                  areaString.removeAt(0);
                  addData['name'] = listToString(areaString);

                  ///区域id
                  addData['id'] = id;
                  Navigator.of(context).pop(addData);
                }
            )
          ],
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(top: 10.0, left: 10.0),
                child: Row(
                    children: [
                      Text('审批类型：', style: TextStyle(fontSize: 15, color: Color(0XFF2F4058))),
                      Container(
                          width: 260,
                          height: 30,
                          child: ListView.builder(
                              shrinkWrap:true,//范围内进行包裹（内容多高ListView就多高）
                              scrollDirection: Axis.horizontal,
                              itemCount: selectTreeProvider.horizontalList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 10),
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: index == 0 ? Color(0xFFF1EEEA) : Color(0xFFEEEFF2),
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: Text(selectTreeProvider.horizontalList[index]['name'], style: TextStyle(fontSize: 15,
                                          color: index == 0 ? Color(0xFFC08A3F) : Color(0xFF999999))),
                                    ),
                                    onTap: (){
                                      if (index != 0){
                                        return;
                                      }
                                      _categoryList(selectTreeProvider.horizontalList[index]['id']);
                                      selectTreeProvider.addExamineChild('0', '全部');
                                    }
                                );
                              }
                          )
                      )
                    ]
                )
              )
            ),
            categoryList.length > 0 ?
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return ListTile(
                      title: Center(
                        child: Text(categoryList[index]['name'], style: TextStyle(fontSize: 15, color: Color(0XFF2F4058))),
                      ),
                      onTap: (){
                        _categoryList(categoryList[index]['id']);
                        selectTreeProvider.addExamine(categoryList[index]['id'], categoryList[index]['name']);
                      }
                  );
                }, childCount: categoryList.length)
            ) :
            SliverToBoxAdapter(
                child: Container(
                    margin: EdgeInsets.all(40),
                    child: Image.asset('assets/images/icon_empty_images.png', width: 150, height: 150)
                )
            )
          ]
        )
    );
  }
}

///选择返回回调
Future<Map> showSelectExamineTreeList(BuildContext context) async {
  Map result;
  SelectTreeProvider selectTreeProvider = new SelectTreeProvider('oa');
  result = await Navigator.push(context, MaterialPageRoute(
      builder: (context) => ChangeNotifierProvider<SelectTreeProvider>.value(
          value: selectTreeProvider,
          child: ExamineSelectTree()
      )
  ));
  return result ?? "";
}