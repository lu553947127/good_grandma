import 'package:flutter/material.dart';
import 'package:good_grandma/pages/work/freezer_statistics/freezer_statistics_list.dart';
import 'package:good_grandma/pages/work/freezer_statistics/freezer_statistics_type.dart';

///冰柜统计
class FreezerStatistics extends StatefulWidget {
  const FreezerStatistics({Key key}) : super(key: key);

  @override
  _FreezerStatisticsState createState() => _FreezerStatisticsState();
}

class _FreezerStatisticsState extends State<FreezerStatistics> {

  List<Map> list = [
    {'title' : '冰柜编号: 11049901004577', 'brand': '品牌/型号：海蓉 / SD2015-'
      ,'area' : '区 域：大区一 / 山东省 / 济南市', 'name' : '城市经理：张三 / 18888888888','status' : '正常','status2' : '已开柜'},
    {'title' : '冰柜编号: 11049901004577', 'brand': '品牌/型号：海蓉 / SD2015-'
      ,'area' : '区 域：大区一 / 山东省 / 济南市', 'name' : '城市经理：张三 / 18888888888','status' : '损坏','status2' : '未开柜'},
    {'title' : '冰柜编号: 11049901004577', 'brand': '品牌/型号：海蓉 / SD2015-'
      ,'area' : '区 域：大区一 / 山东省 / 济南市', 'name' : '城市经理：张三 / 18888888888','status' : '维修中','status2' : '已开柜'},
    {'title' : '冰柜编号: 11049901004577', 'brand': '品牌/型号：海蓉 / SD2015-'
      ,'area' : '区 域：大区一 / 山东省 / 济南市', 'name' : '城市经理：张三 / 18888888888','status' : '报废','status2' : '已开柜'},
    {'title' : '冰柜编号: 11049901004577', 'brand': '品牌/型号：海蓉 / SD2015-'
      ,'area' : '区 域：大区一 / 山东省 / 济南市', 'name' : '城市经理：张三 / 18888888888','status' : '正常','status2' : '未开柜'},
    {'title' : '冰柜编号: 11049901004577', 'brand': '品牌/型号：海蓉 / SD2015-'
      ,'area' : '区 域：大区一 / 山东省 / 济南市', 'name' : '城市经理：张三 / 18888888888','status' : '维修中','status2' : '未开柜'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("冰柜销量",style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
      ),
      body: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: CustomScrollView(
          slivers: [
            FreezerStatisticsType(
              selEmpBtnOnTap: (selEmployees) {},
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return FreezerStatisticsList(data: list[index]);
                }, childCount: list.length))
          ],
        ),
      ),
    );
  }
}
