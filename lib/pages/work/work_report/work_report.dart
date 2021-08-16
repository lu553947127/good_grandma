import 'package:flutter/material.dart';
import 'package:good_grandma/models/home_report_model.dart';
import 'package:good_grandma/pages/work/work_report/work_select_type.dart';
import 'package:good_grandma/pages/work/work_report/work_type_title.dart';
import 'package:good_grandma/widgets/home_report_cell.dart';

///工作报告
class WorkReport extends StatefulWidget {
  const WorkReport({Key key}) : super(key: key);

  @override
  _WorkReportState createState() => _WorkReportState();
}

class _WorkReportState extends State<WorkReport> {

  List<HomeReportModel> _reportList = [];
  String selectValue;

  @override
  void initState() {
    super.initState();
    _getBaoGaoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("工作报告",style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
      ),
      body: CustomScrollView(
          slivers: [
            WorkTypeTitle(),
            WorkSelectType(),
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  HomeReportModel model = _reportList[index];
                  return HomeReportCell(model: model);
                }, childCount: _reportList.length))
          ]
      ),
      floatingActionButton: PopupMenuButton<String>(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)
        ),
        child: Image.asset('assets/images/ic_work_add.png', width: 70, height: 70),
        itemBuilder: (context) {
          return <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: '日报',
              child: Text('日报'),
            ),
            PopupMenuItem<String>(
              value: '周报',
              child: Text('周报'),
            ),
            PopupMenuItem<String>(
              value: '月报',
              child: Text('月报'),
            )
          ];
        },
      )
    );
  }

  void _getBaoGaoList() async {
    for (int i = 0; i < 3; i++) {
      _reportList.add(HomeReportModel(
        avatar: 'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
        userName: '冯岩昌',
        time: '2012-05-29 16:31:50',
        isWeekType: i % 2 == 0,
        target: 45667.0,
        cumulative: 34567.0,
        actual: 12345441.0,
        summary: [
          '和冯经理拜访经销商和冯经理拜访经销商和冯经理',
          '开柜费用核销',
          '经销商补货，开柜，录入冰柜',
          '和冯经理拜访经销商和冯经理拜访经销商和冯经理和冯经理拜访经销商和冯经理拜访经销商和冯经理和冯经理拜访经销商和冯经理拜访经销商和冯经理和冯经理拜访经销商和冯经理拜访经销商和冯经理',
          '经销商沟通冰柜达成……',
          '和冯经理拜访经销商和冯经理拜访经销商和冯经理',
        ],
        plans: [
          '和冯经理拜访经销商和冯经理拜访经销商和冯经理',
          '开柜费用核销',
          '经销商补货，开柜，录入冰柜',
          '和冯经理拜访经销商和冯经理拜访经销商和冯经理',
          '经销商沟通冰柜达成……',
          '和冯经理拜访经销商和冯经理拜访经销商和冯经理',
          '经销商补货，开柜，录入冰柜',
          '和冯经理拜访经销商和冯经理拜访经销商和冯经理',
        ],
      ));
    }
    if (mounted) setState(() {});
  }
}
