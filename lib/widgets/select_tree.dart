import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/store.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/provider/select_tree_provider.dart';
import 'package:provider/provider.dart';

///选择区域页面
class SelectListFormPage extends StatefulWidget {
  final String type;
  SelectListFormPage({Key key, this.type}) : super(key: key);

  @override
  _SelectListFormPageState createState() => _SelectListFormPageState();
}

class _SelectListFormPageState extends State<SelectListFormPage> {

  List<Map> treeList = [];

  ///全国的区域id
  String parentId = '1123598813738675201';

  ///全国区域名称
  String deptName = '全国';

  ///区域id
  String deptId = '';

  ///区域下级列表
  _deptNextList(parentId){
    Map<String, dynamic> map = {'parentId': parentId};
    requestGet(Api.deptNextList, param: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---deptNextList----$data');
      setState(() {
        treeList = (data['data'] as List).cast();
        deptId = parentId;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.type == '全国'){
      _deptNextList(parentId);
    }else {
      _deptNextList(Store.readDeptId());
    }
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
        title: Text('请选择区域', style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
        actions: [
          TextButton(
              child: Text("确定", style: TextStyle(fontSize: 14, color: Color(0xFFC08A3F))),
              onPressed: () {
                if (widget.type == '全国'){
                  if (selectTreeProvider.horizontalList.length == 1){
                    showToast('选择大区不能为空');
                    return;
                  }
                  Map addData = new Map();
                  ///区域名称
                  List<String> areaString = [];
                  for (Map map in selectTreeProvider.horizontalList) {
                    areaString.add(map['name']);
                  }
                  areaString.removeAt(0);
                  addData['areaName'] = listToString(areaString);

                  ///区域id
                  addData['deptId'] = deptId;
                  Navigator.of(context).pop(addData);
                }else {
                  Map addData = new Map();
                  ///区域名称
                  List<String> areaString = [];
                  for (Map map in selectTreeProvider.horizontalList) {
                    areaString.add(map['name']);
                  }
                  addData['areaName'] = listToString(areaString);

                  ///区域id
                  addData['deptId'] = deptId;
                  Navigator.of(context).pop(addData);
                }
              }
          )
        ],
      ),
      body: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: Row(
                  children: [
                    Text('选择区域：', style: TextStyle(fontSize: 15, color: Color(0XFF2F4058))),
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
                                  _deptNextList(selectTreeProvider.horizontalList[index]['id']);
                                  selectTreeProvider.addDataChild(
                                      widget.type == '全国' ? parentId : Store.readDeptId(),
                                      widget.type == '全国' ? deptName : Store.readDeptName(), 0);
                                }
                            );
                          }
                      )
                    )
                  ]
              ),
            ),
            treeList.length > 0 ?
            Container(
              height: 500,
              child: ListView.builder(
                  itemCount: treeList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                        title: Center(
                          child: Text(treeList[index]['deptName'], style: TextStyle(fontSize: 15, color: Color(0XFF2F4058))),
                        ),
                        onTap: (){
                          _deptNextList(treeList[index]['id']);
                          selectTreeProvider.addData(treeList[index]['id'], treeList[index]['deptName'], treeList[index]['deptCategory']);
                        }
                    );
                  }
              ),
            ) :
            Container(
                margin: EdgeInsets.all(40),
                child: Image.asset('assets/images/icon_empty_images.png', width: 150, height: 150)
            )
          ]
      )
    );
  }
}

///选择返回回调
Future<Map> showSelectTreeList(BuildContext context, String type) async {
  Map result;
  SelectTreeProvider selectTreeProvider = new SelectTreeProvider(type);
  result = await Navigator.push(context, MaterialPageRoute(
      builder: (context) => ChangeNotifierProvider<SelectTreeProvider>.value(
          value: selectTreeProvider,
          child: SelectListFormPage(type: type)
      )
  ));
  return result ?? "";
}