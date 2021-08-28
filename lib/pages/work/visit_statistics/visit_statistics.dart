import 'package:flutter/material.dart';
import 'package:good_grandma/pages/work/visit_statistics/visit_statistics_list.dart';
import 'package:good_grandma/pages/work/visit_statistics/visit_statistics_select.dart';
import 'package:good_grandma/pages/work/visit_statistics/visit_statistics_type.dart';

///拜访统计
class VisitStatistics extends StatefulWidget {
  const VisitStatistics({Key key}) : super(key: key);

  @override
  _VisitStatisticsState createState() => _VisitStatisticsState();
}

class _VisitStatisticsState extends State<VisitStatistics> {

  List<Map> list = [
    {'title' : '拜访鲁信影城营业点经营情况', 'name': '拜访人：张三'
      ,'time' : '拜访日期: 2021-05-29 16:00:00', 'customer' : '拜访客户：鲁信影城','status' : '未开始'},
    {'title' : '拜访鲁信影城营业点经营情况', 'name': '拜访人：张三'
      ,'time' : '拜访日期: 2021-05-29 16:00:00', 'customer' : '拜访客户：鲁信影城','status' : '进行中'},
    {'title' : '拜访鲁信影城营业点经营情况', 'name': '拜访人：张三'
      ,'time' : '拜访日期: 2021-05-29 16:00:00', 'customer' : '拜访客户：鲁信影城','status' : '已结束'},
    {'title' : '拜访鲁信影城营业点经营情况', 'name': '拜访人：张三'
      ,'time' : '拜访日期: 2021-05-29 16:00:00', 'customer' : '拜访客户：鲁信影城','status' : '已结束'},
    {'title' : '拜访鲁信影城营业点经营情况', 'name': '拜访人：张三'
      ,'time' : '拜访日期: 2021-05-29 16:00:00', 'customer' : '拜访客户：鲁信影城','status' : '未开始'},
    {'title' : '拜访鲁信影城营业点经营情况', 'name': '拜访人：张三'
      ,'time' : '拜访日期: 2021-05-29 16:00:00', 'customer' : '拜访客户：鲁信影城','status' : '进行中'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("拜访统计",style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
      ),
      body: CustomScrollView(
        slivers: [
          VisitStatisticsSelect(
            color: Colors.white,
            type: '员工统计',
            list: [
              {'name': '员工统计'},
              {'name': '客户统计'},
            ],
            onPressed: () {},
            onPressed2: () {}
          ),
          VisitStatisticsType(
            selEmpBtnOnTap: (selEmployees) {},
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return VisitStatisticsList(data: list[index]);
              }, childCount: list.length))
        ],
      )
    );
  }
}
