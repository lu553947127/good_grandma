import 'package:flutter/material.dart';
import 'package:good_grandma/models/home_report_model.dart';
import 'package:good_grandma/pages/marketing_activity/marketing_activity_page.dart';
import 'package:good_grandma/pages/performance/performance_statistics_page.dart';
import 'package:good_grandma/pages/work/freezer_sales/freezer_sales.dart';
import 'package:good_grandma/pages/work/freezer_statistics/freezer_statistics.dart';
import 'package:good_grandma/pages/work/work_report/work_report.dart';
import 'package:good_grandma/widgets/home_group_title.dart';
import 'package:good_grandma/widgets/home_msg_title.dart';
import 'package:good_grandma/widgets/home_plan_cell.dart';
import 'package:good_grandma/widgets/home_report_cell.dart';
import 'package:good_grandma/widgets/home_table_header.dart';

///首页
class HomePage extends StatefulWidget {
  final Function(int index) switchTabbarIndex;

  const HomePage({Key key,@required this.switchTabbarIndex}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _Body();
}

class _Body extends State<HomePage> {
  String _msgTime = '2021-07-09';
  String _msgCount = '66';
  List<HomeReportModel> _reportList = [];

  @override
  void initState() {
    super.initState();
    _getBaoGaoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("好阿婆"),
        actions: [
          TextButton(
              onPressed: () {},
              child: Image.asset('assets/images/home_scan.png',
                  width: 20.0, height: 20.0)),
        ],
      ),
      body: Scrollbar(
        child: CustomScrollView(
          slivers: [
            //顶部按钮
            HomeTableHeader(onTap: (index){
              _titleBtnOnTap(context,index);
            },),
            //消息通知
            SliverToBoxAdapter(
                child: Visibility(
                    visible: _msgCount != '0',
                    child: HomeGroupTitle(title: '消息通知', showMore: false))),
            //消息cell
            SliverToBoxAdapter(
                child: HomeMsgTitle(msgTime: _msgTime, msgCount: _msgCount,onTap: (){
                  if(widget.switchTabbarIndex != null)
                    widget.switchTabbarIndex(1);
                },)),
            //拜访计划
            SliverToBoxAdapter(
                child: HomeGroupTitle(title: '拜访计划', showMoreBtnOnTap: () {})),
            //日历和计划
            SliverToBoxAdapter(child: HomePlanCell()),
            //工作报告
            SliverToBoxAdapter(
                child: HomeGroupTitle(title: '工作报告', showMoreBtnOnTap: () {})),
            //报告列表
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  HomeReportModel model = _reportList[index];
              return HomeReportCell(model: model);
            }, childCount: _reportList.length)),
          ],
        ),
      ),
    );
  }


  ///按钮点击事件
  void _titleBtnOnTap(BuildContext context, int index) {
    switch(index){
      case 0://工作报告
        Navigator.push(context, MaterialPageRoute(builder:(context)=> WorkReport()));
        break;
      case 1://市场活动
        Navigator.push(context, MaterialPageRoute(builder:(context)=> MarketingActivityPage()));
        break;
      case 2:
        { //审批申请
          if(widget.switchTabbarIndex != null)
            widget.switchTabbarIndex(3);
        }
        break;
      case 3://费用申请
        break;
      case 4://业绩统计
        Navigator.push(context, MaterialPageRoute(builder:(context)=> PerformanceStatisticsPage()));
        break;
      case 5://冰柜销量
        Navigator.push(context, MaterialPageRoute(builder:(context)=> FreezerSales()));
        break;
      case 6://冰柜统计
        Navigator.push(context, MaterialPageRoute(builder:(context)=> FreezerStatistics()));
        break;
      case 7:
        { //更多
          if(widget.switchTabbarIndex != null)
            widget.switchTabbarIndex(2);
        }
        break;
    }
  }

  void _getBaoGaoList() async {
    for (int i = 0; i < 3; i++) {
      _reportList.add(HomeReportModel(
        avatar: 'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
        userName: '猫和老鼠',
        time: '2012-05-29 16:31:50',
        postType: i +1,
        target: 45667.0,
        cumulative: 34567.0,
        actual: 12345441.0,
        summary: [
          '和冯经理拜访经销商和冯经理拜访经销商和冯经理',
          '和冯经理拜访经销商和冯经理拜访经销商和冯经理',
          '和冯经理拜访经销商和冯经理拜访经销商和冯经理',
          '和冯经理拜访经销商和冯经理拜访经销商和冯经理和冯经理拜访经销商和冯经理拜访经销商和冯经理和冯经理拜访经销商和冯经理拜访经销商和冯经理和冯经理拜访经销商和冯经理拜访经销商和冯经理',
          '和冯经理拜访经销商和冯经理拜访经销商和冯经理',
          '和冯经理拜访经销商和冯经理拜访经销商和冯经理',
        ],
        plans: [
          '和冯经理拜访经销商和冯经理拜访经销商和冯经理',
          '和冯经理拜访经销商和冯经理拜访经销商和冯经理',
          '和冯经理拜访经销商和冯经理拜访经销商和冯经理',
          '和冯经理拜访经销商和冯经理拜访经销商和冯经理',
          '和冯经理拜访经销商和冯经理拜访经销商和冯经理',
          '和冯经理拜访经销商和冯经理拜访经销商和冯经理',
        ],
      ));
    }
    if (mounted) setState(() {});
  }
}
