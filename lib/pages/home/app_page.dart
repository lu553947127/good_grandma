import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
import 'package:good_grandma/common/store.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/contract/contract_page.dart';
import 'package:good_grandma/pages/files/files_page.dart';
import 'package:good_grandma/pages/guarantee/guarantee_page.dart';
import 'package:good_grandma/pages/order/freezer_order/freezer_order.dart';
import 'package:good_grandma/pages/order/material_order/material_order.dart';
import 'package:good_grandma/pages/order/order_page.dart';
import 'package:good_grandma/pages/regular_doc/regular_doc_page.dart';
import 'package:good_grandma/pages/sales_statistics/sales_statistics_page.dart';
import 'package:good_grandma/pages/sign_in/sign_in_page.dart';
import 'package:good_grandma/pages/marketing_activity/marketing_activity_page.dart';
import 'package:good_grandma/pages/performance/performance_statistics_page.dart';
import 'package:good_grandma/pages/repor_statistics/report_statistics_page.dart';
import 'package:good_grandma/pages/stock/stock_page.dart';
import 'package:good_grandma/pages/track/track_page.dart';
import 'package:good_grandma/pages/work/customer_visit/customer_visit_add.dart';
import 'package:good_grandma/pages/work/customer_visit/customer_visit_edit.dart';
import 'package:good_grandma/pages/work/discount/discount_management.dart';
import 'package:good_grandma/pages/work/freezer_sales/freezer_sales.dart';
import 'package:good_grandma/pages/work/freezer_statistics/freezer_statistics.dart';
import 'package:good_grandma/pages/work/market_material/market_material.dart';
import 'package:good_grandma/pages/work/receivable/receivable.dart';
import 'package:good_grandma/pages/work/visit_plan/visit_plan.dart';
import 'package:good_grandma/pages/work/visit_statistics/visit_statistics.dart';
import 'package:good_grandma/pages/work/work_report/work_report.dart';

///??????
class AppPage extends StatefulWidget {
  final VoidCallback shenpiOnTap;
  const AppPage({Key key,@required this.shenpiOnTap}) : super(key: key);

  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();

  ///??????????????????
  List<Map> appMenuTreeList = [];

  @override
  void initState() {
    super.initState();
    _controller.callRefresh();
  }

  ///??????????????????eqb
  isEqbContract(){
    requestPost(Api.isEqbContract).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('????????????---isEqbContract----$data');
      if (data['msg'] == 'success'){
        Navigator.push(context, MaterialPageRoute(builder:(context)=> ContractPage()));
      }else if (data['msg'] == 'fail_contract'){
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  title: Text('????????????'),
                  content: Text('???????????????????????????????????????????????????'),
                  actions: <Widget>[
                    TextButton(child: Text('??????',style: TextStyle(color: Color(0xFF999999))),onPressed: (){
                      Navigator.of(context).pop('cancel');
                    }),
                    TextButton(child: Text('??????',style: TextStyle(color: Color(0xFFC08A3F))),onPressed: () async {
                      Navigator.of(context).pop('ok');
                      registerContract();
                    })
                  ]
              );
            });
      }else if (data['msg'] == 'fail_customer'){
        AppUtil.showToastCenter('???????????????');
      }
    });
  }

  ///????????????????????????
  registerContract(){
    requestPost(Api.registerContract).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('????????????---registerContract----$data');
      if (data['code'] == 200){
        AppUtil.showToastCenter('??????????????????');
        Navigator.push(context, MaterialPageRoute(builder:(context)=> ContractPage()));
      }else {
        AppUtil.showToastCenter(data['msg']);
      }
    });
  }

  ///???????????????????????????
  isCustomerVisitAdd(){
    requestPost(Api.isCustomerVisit).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('????????????---isCustomerVisit----$data');
      String id = data['data']['id'].toString();
      if (id != '-1'){
        Navigator.push(context, MaterialPageRoute(builder:(context)=> CustomerVisitEdit(data: data['data'])));
      }else {
        Navigator.push(context, MaterialPageRoute(builder:(context)=> CustomerVisitAdd()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    ///??????????????????
    void _btnOnPressed(BuildContext context, Map menu) {
      switch(menu['code']){
        case 'visitPlan'://????????????
          Navigator.push(context, MaterialPageRoute(builder:(context)=> VisitPlan()));
          break;
        case 'customerVisit'://????????????
          isCustomerVisitAdd();
          break;
        case 'workReport'://????????????
          Navigator.push(context, MaterialPageRoute(builder:(context)=> WorkReport()));
          break;
        case 'marketMaterial'://????????????
          Navigator.push(context, MaterialPageRoute(builder:(context)=> MarketMaterial()));
          break;
        case 'marketingActivities'://????????????
          Navigator.push(context, MaterialPageRoute(builder:(context)=> MarketingActivityPage()));
          break;
        case 'reportForRepair'://??????
          Navigator.push(context, MaterialPageRoute(builder:(context)=> GuaranteePage()));
          break;
        case 'signIn'://??????
          Navigator.push(context, MaterialPageRoute(builder:(context)=> SignInPage()));
          break;
        case 'regulatoryDocuments'://????????????
          Navigator.push(context, MaterialPageRoute(builder:(context)=> RegularDocPage()));
          break;
        case 'firstOrder'://????????????
          Navigator.push(context, MaterialPageRoute(builder:(context)=> OrderPage()));
          break;
        case 'secondaryOrder'://????????????
          Navigator.push(context, MaterialPageRoute(builder:(context)=> OrderPage(orderType: 2)));
          break;
        case 'directlyOrder'://????????????
          Navigator.push(context, MaterialPageRoute(builder:(context)=> OrderPage(orderType: 3)));
          break;
        case 'receive'://???????????????
          Navigator.push(context, MaterialPageRoute(builder:(context)=> ReceivableDetail()));
          break;
        case 'amount'://????????????
          Navigator.push(context, MaterialPageRoute(builder:(context)=> DiscountManagement()));
          break;
        case 'freezerOrder'://????????????
          Navigator.push(context, MaterialPageRoute(builder:(context)=> FreezerOrderPage()));
          break;
        case 'materialOrder'://????????????
          Navigator.push(context, MaterialPageRoute(builder:(context)=> MaterialOrderPage()));
          break;
        case 'approvalApplication'://????????????
          if(widget.shenpiOnTap != null) widget.shenpiOnTap();
          break;
        case 'commoditySalesStatistics'://??????????????????
          Navigator.push(context, MaterialPageRoute(builder: (context) => SalesStatisticsPage()));
          break;
        case 'performanceStatistics'://????????????
          Navigator.push(context, MaterialPageRoute(builder:(context)=> PerformanceStatisticsPage()));
          break;
        case 'visitStatistics'://????????????
          Navigator.push(context, MaterialPageRoute(builder:(context)=> VisitStatistics()));
          break;
        case 'actionTrack'://????????????
          Navigator.push(context, MaterialPageRoute(builder:(context)=> TrackPage()));
          break;
        case 'reportStatistics'://????????????
          Navigator.push(context, MaterialPageRoute(builder:(context)=> ReportStatisticsPage()));
          break;
        case 'freezerSales'://????????????
          Navigator.push(context, MaterialPageRoute(builder:(context)=> FreezerSales()));
          break;
        case 'customerInventory'://????????????
          Navigator.push(context, MaterialPageRoute(builder:(context)=> StockPage()));
          break;
        case 'freezerStatistics'://????????????
          Navigator.push(context, MaterialPageRoute(builder:(context)=> FreezerStatistics()));
          break;
        case 'electronicContract'://????????????
          isEqbContract();
          break;
        case 'enterpriseFilingCabinetFile'://???????????????
          Navigator.push(context, MaterialPageRoute(builder:(context)=> FilesPage()));
          break;
      }
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: Text('??????')),
        body: MyEasyRefreshSliverWidget(
            controller: _controller,
            scrollController: _scrollController,
            dataCount: appMenuTreeList.length,
            onRefresh: _refresh,
            onLoad: null,
            slivers: [
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    List<Map> list = (appMenuTreeList[index]['children'] as List).cast();
                    return Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(appMenuTreeList[index]['name'], style: TextStyle(fontSize: 18, color: Color(0XFF333333))),
                              list.length > 0 ?
                              GridView.builder(
                                  shrinkWrap: true,//???true????????????????????????????????????????????????
                                  physics:NeverScrollableScrollPhysics(),//??????????????????
                                  padding: EdgeInsets.zero,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 0.9),
                                  itemCount: list.length,
                                  itemBuilder: (context, index) {
                                    return TextButton(
                                        onPressed: () {
                                          _btnOnPressed(context, list[index]);
                                        },
                                        style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            MyCacheImageView(
                                              imageURL: list[index]['source'],
                                              width: 55.0,
                                              height: 55.0,
                                              errorWidgetChild: Image.asset(
                                                  'assets/images/icon_empty_user.png',
                                                  width: 55.0,
                                                  height: 55.0),
                                            ),
                                            Text(list[index]['name'], style: TextStyle(fontSize: 14,
                                                color: Color(0XFF333333)), overflow: TextOverflow.ellipsis)
                                          ]
                                        ));
                                  }
                              ) :
                              Container()
                            ]
                        ),
                        decoration: BoxDecoration(//?????????
                          border: Border(bottom: BorderSide(width: 12, color: Color(0xFFF8F9FC))),
                        )
                    );
                  }, childCount: appMenuTreeList.length)
              )
            ]
        )
    );
  }

  Future<void> _refresh() async {
   await _appMenuTree();
  }

  ///??????????????????
  Future<void> _appMenuTree() async {
    try {
      Map<String, dynamic> map = {'roleIds': Store.readAppRoleId()};
      final val = await requestGet(Api.appMenuTree, param: map);
      var data = jsonDecode(val.toString());
      LogUtil.d('????????????---appMenuTree----$data');
      final List<dynamic> list = data['data'];
      appMenuTreeList.clear();
      list.forEach((map) {
        appMenuTreeList.add(map);
      });
      bool noMore = false;
      if (appMenuTreeList == null || appMenuTreeList.isEmpty) noMore = true;
      _controller.finishRefresh(success: true);
      _controller.finishLoad(success: true, noMore: noMore);
      if (mounted) setState(() {});
    } catch (error) {
      _controller.finishRefresh(success: false);
      _controller.finishLoad(success: false, noMore: false);
    }
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    _controller?.dispose();
    super.dispose();
  }
}