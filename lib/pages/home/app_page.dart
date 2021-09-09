import 'package:flutter/material.dart';
import 'package:good_grandma/pages/contract/contract_page.dart';
import 'package:good_grandma/pages/files/files_page.dart';
import 'package:good_grandma/pages/guarantee/guarantee_page.dart';
import 'package:good_grandma/pages/order/first_order_page.dart';
import 'package:good_grandma/pages/order/second_order_page.dart';
import 'package:good_grandma/pages/regular_doc/regular_doc_page.dart';
import 'package:good_grandma/pages/sales_statistics/sales_statistics_page.dart';
import 'package:good_grandma/pages/sign_in/sign_in_page.dart';
import 'package:good_grandma/pages/marketing_activity/marketing_activity_page.dart';
import 'package:good_grandma/pages/performance/performance_statistics_page.dart';
import 'package:good_grandma/pages/repor_statistics/report_statistics_page.dart';
import 'package:good_grandma/pages/stock/stock_page.dart';
import 'package:good_grandma/pages/track/track_page.dart';
import 'package:good_grandma/pages/work/customer_visit/customer_visit_add.dart';
import 'package:good_grandma/pages/work/freezer_sales/freezer_sales.dart';
import 'package:good_grandma/pages/work/freezer_statistics/freezer_statistics.dart';
import 'package:good_grandma/pages/work/market_material/market_material.dart';
import 'package:good_grandma/pages/work/visit_plan/visit_plan.dart';
import 'package:good_grandma/pages/work/visit_statistics/visit_statistics.dart';
import 'package:good_grandma/pages/work/work_report/work_report.dart';
import 'package:good_grandma/pages/work/work_text.dart';
///应用
class AppPage extends StatelessWidget{
  final VoidCallback shenpiOnTap;
  const AppPage({Key key,@required this.shenpiOnTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    ///功能模块点击
    void _btnOnPressed(BuildContext context, List<Map> list, int index) {
      switch(list[index]['name']){
        case '拜访计划':
          Navigator.push(context, MaterialPageRoute(builder:(context)=> VisitPlan()));
          break;
        case '客户拜访':
          Navigator.push(context, MaterialPageRoute(builder:(context)=> CustomerVisitAdd()));
          break;
        case '工作报告':
          Navigator.push(context, MaterialPageRoute(builder:(context)=> WorkReport()));
          break;
        case '市场物料':
          Navigator.push(context, MaterialPageRoute(builder:(context)=> MarketMaterial()));
          break;
        case '市场活动':
          Navigator.push(context, MaterialPageRoute(builder:(context)=> MarketingActivityPage()));
          break;
        case '报修':
          Navigator.push(context, MaterialPageRoute(builder:(context)=> GuaranteePage()));
          break;
        case '签到':
          Navigator.push(context, MaterialPageRoute(builder:(context)=> SignInPage()));
          break;
        case '规章文件':
          Navigator.push(context, MaterialPageRoute(builder:(context)=> RegularDocPage()));
          break;
        case '一级订单':
          Navigator.push(context, MaterialPageRoute(builder:(context)=> FirstOrderPage()));
          break;
        case '二级订单':
          Navigator.push(context, MaterialPageRoute(builder:(context)=> SecondOrderPage()));
          break;
        case '审批申请':{
          if(shenpiOnTap != null)
            shenpiOnTap();
        }
          break;
        case '营销费用申请':
          break;
        case '营销费用核销':
          break;
        case '客户对账':
          break;
        case '商品销量统计':
          {
            //todo:登录用户类型需要从登录信息中获取
            //分三种登录用户类型,不同类型显示状态不同 1：业务经理，2：管理层，3：客户登录
            int userType = 2;
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SalesStatisticsPage(userType: userType,)));
          }
          break;
        case '企业文件柜':
          Navigator.push(context, MaterialPageRoute(builder:(context)=> FilesPage()));
          break;
        case '拜访统计':
          Navigator.push(context, MaterialPageRoute(builder:(context)=> VisitStatistics()));
          break;
        case '冰柜销量':
          Navigator.push(context, MaterialPageRoute(builder:(context)=> FreezerSales()));
          break;
        case '冰柜统计':
          Navigator.push(context, MaterialPageRoute(builder:(context)=> FreezerStatistics()));
          break;
        case '客户库存':
          Navigator.push(context, MaterialPageRoute(builder:(context)=> StockPage()));
          break;
        case '电子合同':
          Navigator.push(context, MaterialPageRoute(builder:(context)=> ContractPage()));
          break;
        case '业绩统计':
          Navigator.push(context, MaterialPageRoute(builder:(context)=> PerformanceStatisticsPage()));
          break;
        case '报告统计':
          Navigator.push(context, MaterialPageRoute(builder:(context)=> ReportStatisticsPage()));
          break;
        case '行动轨迹':
          Navigator.push(context, MaterialPageRoute(builder:(context)=> TrackPage()));
          break;

      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        brightness: Brightness.light,
        title: Text('应用'),
      ),
      body: Container(
        color: Colors.white,
        child: ListView.builder(
            itemCount: WorkText.listWork.length,
            itemBuilder: (context, index){
              List<Map> list = (WorkText.listWork[index]['list'] as List).cast();
              return Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(WorkText.listWork[index]['title'], style: TextStyle(fontSize: 18, color: Color(0XFF333333))),
                      GridView.builder(
                        shrinkWrap: true,//为true可以解决子控件必须设置高度的问题
                        physics:NeverScrollableScrollPhysics(),//禁用滑动事件
                        padding: EdgeInsets.zero,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 0.9),
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return TextButton(
                              onPressed: () {
                                _btnOnPressed(context, list, index);
                              },
                              style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(list[index]['image'], width: 55.0, height: 55.0),
                                  Text(list[index]['name'], style: TextStyle(fontSize: 14, color: Color(0XFF333333)), overflow: TextOverflow.ellipsis)
                                ],
                              ));
                        }
                      )
                    ],
                  ),
                  decoration: BoxDecoration(//分割线
                    border: Border(bottom: BorderSide(width: 12, color: Color(0xFFF8F9FC))),
                  )
              );
            }
        ),
      )
    );
  }
}