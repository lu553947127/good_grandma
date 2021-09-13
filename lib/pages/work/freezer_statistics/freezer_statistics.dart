import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/pages/work/freezer_statistics/freezer_statistics_list.dart';
import 'package:good_grandma/pages/work/freezer_statistics/freezer_statistics_type.dart';

///冰柜统计
class FreezerStatistics extends StatefulWidget {
  const FreezerStatistics({Key key}) : super(key: key);

  @override
  _FreezerStatisticsState createState() => _FreezerStatisticsState();
}

class _FreezerStatisticsState extends State<FreezerStatistics> {

  List<Map> freezerList = [];

  ///冰柜销量列表
  _freezerList(){
    Map<String, dynamic> map = {'current': '1', 'size': '999'};
    requestGet(Api.freezerList, param: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---freezerList----$data');
      setState(() {
        freezerList = (data['data'] as List).cast();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _freezerList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("冰柜统计",style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
      ),
      body: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: CustomScrollView(
          slivers: [
            FreezerStatisticsType(
              selEmpBtnOnTap: (selEmployees) {},
            ),
            freezerList.length > 0 ?
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return FreezerStatisticsList(data: freezerList[index]);
                }, childCount: freezerList.length)) :
            SliverToBoxAdapter(
                child: Container(
                    margin: EdgeInsets.all(40),
                    child: Image.asset('assets/images/icon_empty_images.png', width: 150, height: 150)
                )
            )
          ],
        ),
      ),
    );
  }
}
