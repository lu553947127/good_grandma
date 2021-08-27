import 'package:flutter/material.dart';
import 'package:good_grandma/models/day_post_add_model.dart';
import 'package:good_grandma/models/home_report_model.dart';
import 'package:good_grandma/models/month_post_add_model.dart';
import 'package:good_grandma/models/post_add_zn_model.dart';
import 'package:good_grandma/models/week_post_add_model.dart';
import 'package:good_grandma/pages/work/work_report/day_post_add_page.dart';
import 'package:good_grandma/pages/work/work_report/month_post_add_page.dart';
import 'package:good_grandma/pages/work/work_report/post_add_zn_page.dart';
import 'package:good_grandma/pages/work/work_report/week_post_add_page.dart';
import 'package:good_grandma/pages/work/work_report/work_select_type.dart';
import 'package:good_grandma/pages/work/work_report/work_type_title.dart';
import 'package:good_grandma/widgets/home_report_cell.dart';
import 'package:provider/provider.dart';

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
          title: Text("工作报告",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w700)),
        ),
        body: SafeArea(
          child: Scrollbar(
            child: CustomScrollView(slivers: [
              //切换选项卡
              WorkTypeTitle(
                color: Colors.white,
                type: '我收到的',
                list: [
                  {'name': '我收到的'},
                  {'name': '我提交的'},
                  {'name': '我的草稿'},
                ],
                onPressed: () {},
                onPressed2: () {},
                onPressed3: () {},
              ),
              //筛选
              WorkSelectType(
                selEmpBtnOnTap: (selEmployees) {},
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                HomeReportModel model = _reportList[index];
                return HomeReportCell(model: model);
              }, childCount: _reportList.length))
            ]),
          ),
        ),
        floatingActionButton: PopupMenuButton<String>(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Image.asset('assets/images/ic_work_add.png',
              width: 70, height: 70),
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
          onSelected: (name) {
            bool isZhiNeng = true;
            if (name == '日报') {
              DayPostAddModel model = DayPostAddModel();
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return ChangeNotifierProvider<DayPostAddModel>.value(
                    value: model, child: DayPostAddPage());
              }));
            } else if (name == '周报') {
              if(isZhiNeng){
                PostAddZNModel model = PostAddZNModel();
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return ChangeNotifierProvider<PostAddZNModel>.value(
                      value: model, child: PostAddZNPage());
                }));
              }else{
                WeekPostAddModel model = WeekPostAddModel();
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return ChangeNotifierProvider<WeekPostAddModel>.value(
                      value: model, child: WeekPostAddPage());
                }));
              }
            } else if (name == '月报') {
              if(isZhiNeng){
                PostAddZNModel model = PostAddZNModel();
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return ChangeNotifierProvider<PostAddZNModel>.value(
                      value: model, child: PostAddZNPage(isWeek: false));
                }));
              }else{
                MonthPostAddModel model = MonthPostAddModel();
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return ChangeNotifierProvider<MonthPostAddModel>.value(
                      value: model, child: MonthPostAddPage());
                }));
              }
            }
          },
        ));
  }

  void _getBaoGaoList() async {
    for (int i = 0; i < 3; i++) {
      _reportList.add(HomeReportModel(
        avatar:
            'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
        userName: '冯岩昌',
        time: '2012-05-29 16:31:50',
        postType: i + 1,
        target: 45667.0,
        cumulative: 34567.0,
        actual: 12345441.0,
        summary: [
          '和冯经理拜访经销商和冯经理拜访经销商和冯经理',
          '开柜费用核销',
          '经销商补货，开柜，录入冰柜',
          '和冯经理拜访经销商和冯经理拜访经销商和冯经理和冯经理拜访经销商和冯经理拜访经销商和冯经理和冯经理拜访经销商和冯经理拜访经销商和冯经理和冯经理拜访经销商和冯经理拜访经销商和冯经理',
          '经销商沟通冰柜达成沟通冰柜沟通冰柜沟通冰柜沟通冰柜沟通冰柜沟通冰柜沟通冰柜',
          '和冯经理拜访经销商和冯经理拜访经销商和冯经理',
        ],
        plans: [
          '和冯经理拜访经销商和冯经理拜访经销商和冯经理',
          '开柜费用核销',
          '经销商补货，开柜，录入冰柜',
          '和冯经理拜访经销商和冯经理拜访经销商和冯经理',
          '经销商沟通冰柜达成沟通冰柜沟通冰柜沟通冰柜沟通冰柜沟通冰柜沟通冰柜沟通冰柜',
          '和冯经理拜访经销商和冯经理拜访经销商和冯经理',
          '经销商补货，开柜，录入冰柜',
          '和冯经理拜访经销商和冯经理拜访经销商和冯经理',
        ],
      ));
    }
    if (mounted) setState(() {});
  }
}
