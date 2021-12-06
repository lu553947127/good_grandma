import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';

///oa审批选择流程分类页面
class ExamineSelectProcessNew extends StatefulWidget {
  const ExamineSelectProcessNew({Key key}) : super(key: key);

  @override
  _ExamineSelectProcessNewState createState() => _ExamineSelectProcessNewState();
}

class _ExamineSelectProcessNewState extends State<ExamineSelectProcessNew> {
  List<Map> categoryList = [];
  ///审批流程列表
  List<Map> processList = [];

  ///oa类别下级列表
  _categoryList(String pid_equal){
    Map<String, dynamic> map = {
      'pid_equal': pid_equal,
      'size': '-1'
    };

    requestGet(Api.categoryList, param: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---categoryList----$data');
      categoryList = (data['data']['records'] as List).cast();
      if(categoryList.isEmpty){
        _processList(pid_equal);
      }
      if (mounted) setState(() {});
    });
  }

  ///可发起的流程列表
  _processList(category){
    Map<String, dynamic> map = {'category': category, 'current': '1', 'size': '999'};
    requestGet(Api.processList, param: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---processList----$data');
      categoryList = (data['data']['records'] as List).cast();
      processList = (data['data']['records'] as List).cast();
      if (mounted) setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    _categoryList('0');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FC),
      appBar: AppBar(
          title: Text('请选择审批流程'),
          actions: [
            TextButton(
                child: Text("重置", style: TextStyle(fontSize: 14, color: Color(0xFFC08A3F))),
                onPressed: () {
                  processList = [];
                  _categoryList('0');
                }
            )
          ]
      ),
      body:
      categoryList.length > 0 ?
      Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Card(
            child: GridView.builder(
                shrinkWrap: true,//为true可以解决子控件必须设置高度的问题
                physics:NeverScrollableScrollPhysics(),//禁用滑动事件
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.9),
                itemCount: categoryList.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(5.0),
                    child: TextButton(
                        onPressed: () {
                          if (processList.isNotEmpty){
                            Navigator.of(context).pop(processList[index]);
                            return;
                          }
                          _categoryList(categoryList[index]['id']);
                        },
                        style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              MyCacheImageView(
                                imageURL: categoryList[index]['img'],
                                width: 55.0,
                                height: 55.0,
                                errorWidgetChild: Image.asset(
                                    'assets/images/icon_empty_examine.png',
                                    width: 55.0,
                                    height: 55.0),
                              ),
                              Text(categoryList[index]['name'], style: TextStyle(fontSize: 14,
                                  color: Color(0XFF333333)), overflow: TextOverflow.ellipsis ,maxLines: 3)
                            ]
                        ))
                  );
                }
            )
        )
      ) :
      Center(
        child: Container(
            margin: EdgeInsets.all(40),
            child: Image.asset('assets/images/icon_empty_images.png', width: 150, height: 150)
        )
      )
    );
  }
}

///选择返回回调
Future<Map> showSelectProcessListNew(BuildContext context) async {
  Map result;
  result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ExamineSelectProcessNew()));
  return result ?? "";
}
