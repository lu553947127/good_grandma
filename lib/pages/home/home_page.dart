import 'dart:convert';
import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
import 'package:good_grandma/common/store.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/home_report_model.dart';
import 'package:good_grandma/models/main_provider.dart';
import 'package:good_grandma/pages/contract/contract_page.dart';
import 'package:good_grandma/pages/files/files_page.dart';
import 'package:good_grandma/pages/guarantee/guarantee_page.dart';
import 'package:good_grandma/pages/marketing_activity/marketing_activity_page.dart';
import 'package:good_grandma/pages/order/freezer_order/freezer_order.dart';
import 'package:good_grandma/pages/order/material_order/material_order.dart';
import 'package:good_grandma/pages/order/order_page.dart';
import 'package:good_grandma/pages/performance/performance_statistics_page.dart';
import 'package:good_grandma/pages/regular_doc/regular_doc_page.dart';
import 'package:good_grandma/pages/repor_statistics/report_statistics_page.dart';
import 'package:good_grandma/pages/sales_statistics/sales_statistics_page.dart';
import 'package:good_grandma/pages/scan/scan_detail.dart';
import 'package:good_grandma/pages/sign_in/sign_in_page.dart';
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
import 'package:good_grandma/widgets/home_group_title.dart';
import 'package:good_grandma/widgets/home_msg_title.dart';
import 'package:good_grandma/widgets/home_plan_cell.dart';
import 'package:good_grandma/widgets/home_report_cell.dart';
import 'package:good_grandma/widgets/home_table_header.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

///首页
class HomePage extends StatefulWidget {
  final Function(int index) switchTabbarIndex;

  const HomePage({Key key, @required this.switchTabbarIndex}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _Body();
}

class _Body extends State<HomePage> {
  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();
  String _msgTime = '';
  String _msgCount = '0';
  List<HomeReportModel> _reportList = [];
  int _current = 1;
  int _pageSize = 7;

  ///首页应用菜单列表
  List<Map> homepageList = [];

  ///首页权限列表
  List<dynamic> jurisdictionList = [];

  ///是否有拜访计划
  bool isVisitPlan = false;

  ///是否有工作报告
  bool isWorkReport = false;

  MainProvider _mainProvider;

  @override
  void initState() {
    super.initState();
    _controller.callRefresh();
    _getVersion();
    getPhoneBrand();
  }

  @override
  Widget build(BuildContext context) {
    _mainProvider = Provider.of<MainProvider>(context);
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("好阿婆"),
          actions: [
            TextButton(
                onPressed: () {
                  getQrcodeState();
                },
                child: Image.asset('assets/images/home_scan.png',
                    width: 20.0, height: 20.0)),
          ]),
      body: MyEasyRefreshSliverWidget(
          controller: _controller,
          scrollController: _scrollController,
          dataCount: _reportList.length + 1,
          onRefresh: _refresh,
          onLoad: _onLoad,
          slivers: [
            //顶部按钮
            HomeTableHeader(
                onTap: (menu) => _titleBtnOnTap(context, menu),
                homepageList: homepageList,
                mainProvider: _mainProvider
            ),
            //消息通知
            SliverToBoxAdapter(
                child: Visibility(
                    visible: _msgCount != '0',
                    child: HomeGroupTitle(title: '消息通知', showMore: false)
                )
            ),
            //消息cell
            SliverToBoxAdapter(
                child: HomeMsgTitle(
                    msgTime: _msgTime,
                    msgCount: _msgCount,
                    onTap: () {
                      if (widget.switchTabbarIndex != null)
                        widget.switchTabbarIndex(1);
                    }
                )
            ),
            //拜访计划
            SliverToBoxAdapter(
                child: Visibility(
                  visible: isVisitPlan,
                  child: HomeGroupTitle(
                      title: '拜访计划',
                      showMoreBtnOnTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => VisitPlan()));
                      })
                )),
            //日历和计划
            SliverToBoxAdapter(child: Visibility(
                visible: isVisitPlan,
                child: HomePlanCell()
            )),
            //工作报告
            SliverToBoxAdapter(
                child: Visibility(
                  visible: isWorkReport,
                  child: HomeGroupTitle(
                      title: '工作报告',
                      showMoreBtnOnTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WorkReport())))
                )),
            //报告列表
            isWorkReport && _reportList.length > 0
                ? SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                    HomeReportModel model = _reportList[index];
                    return HomeReportCell(model: model);
                  }, childCount: _reportList.length))
                : SliverToBoxAdapter(
                    child: Container(
                        margin: EdgeInsets.all(40),
                        child: Image.asset(
                            'assets/images/icon_empty_images.png',
                            width: 150,
                            height: 150)))
          ]),
      // body: buildScrollbar(context),'
    );
  }

  ///按钮点击事件
  void _titleBtnOnTap(BuildContext context, Map menu) {
    switch(menu['code']){
      case 'visitPlan'://拜访计划
        Navigator.push(context, MaterialPageRoute(builder:(context)=> VisitPlan()));
        break;
      case 'customerVisit'://客户拜访
        isCustomerVisitAdd();
        break;
      case 'workReport'://工作报告
        Navigator.push(context, MaterialPageRoute(builder:(context)=> WorkReport()));
        break;
      case 'marketMaterial'://市场物料
        Navigator.push(context, MaterialPageRoute(builder:(context)=> MarketMaterial()));
        break;
      case 'marketingActivities'://市场活动
        Navigator.push(context, MaterialPageRoute(builder:(context)=> MarketingActivityPage()));
        break;
      case 'reportForRepair'://报修
        Navigator.push(context, MaterialPageRoute(builder:(context)=> GuaranteePage()));
        break;
      case 'signIn'://签到
        Navigator.push(context, MaterialPageRoute(builder:(context)=> SignInPage()));
        break;
      case 'regulatoryDocuments'://规章文件
        Navigator.push(context, MaterialPageRoute(builder:(context)=> RegularDocPage()));
        break;
      case 'firstOrder'://一级订单
        Navigator.push(context, MaterialPageRoute(builder:(context)=> OrderPage()));
        break;
      case 'secondaryOrder'://二级订单
        Navigator.push(context, MaterialPageRoute(builder:(context)=> OrderPage(orderType: 2)));
        break;
      case 'directlyOrder'://直营订单
        Navigator.push(context, MaterialPageRoute(builder:(context)=> OrderPage(orderType: 3)));
        break;
      case 'receive'://应收明细账
        Navigator.push(context, MaterialPageRoute(builder:(context)=> ReceivableDetail()));
        break;
      case 'amount'://折扣管理
        Navigator.push(context, MaterialPageRoute(builder:(context)=> DiscountManagement()));
        break;
      case 'freezerOrder'://冰柜订单
        Navigator.push(context, MaterialPageRoute(builder:(context)=> FreezerOrderPage()));
        break;
      case 'materialOrder'://物料订单
        Navigator.push(context, MaterialPageRoute(builder:(context)=> MaterialOrderPage()));
        break;
      case 'approvalApplication'://审批申请
        if (widget.switchTabbarIndex != null) widget.switchTabbarIndex(3);
        break;
      case 'commoditySalesStatistics'://商品销量统计
        Navigator.push(context, MaterialPageRoute(builder: (context) => SalesStatisticsPage()));
        break;
      case 'performanceStatistics'://业绩统计
        Navigator.push(context, MaterialPageRoute(builder:(context)=> PerformanceStatisticsPage()));
        break;
      case 'visitStatistics'://拜访统计
        Navigator.push(context, MaterialPageRoute(builder:(context)=> VisitStatistics()));
        break;
      case 'actionTrack'://行动轨迹
        Navigator.push(context, MaterialPageRoute(builder:(context)=> TrackPage()));
        break;
      case 'reportStatistics'://报告统计
        Navigator.push(context, MaterialPageRoute(builder:(context)=> ReportStatisticsPage()));
        break;
      case 'freezerSales'://冰柜销量
        Navigator.push(context, MaterialPageRoute(builder:(context)=> FreezerSales()));
        break;
      case 'customerInventory'://客户库存
        Navigator.push(context, MaterialPageRoute(builder:(context)=> StockPage()));
        break;
      case 'freezerStatistics'://冰柜统计
        Navigator.push(context, MaterialPageRoute(builder:(context)=> FreezerStatistics()));
        break;
      case 'electronicContract'://电子合同
        isEqbContract();
        break;
      case 'enterpriseFilingCabinetFile'://企业文件柜
        Navigator.push(context, MaterialPageRoute(builder:(context)=> FilesPage()));
        break;
      case 'more'://更多
        if (widget.switchTabbarIndex != null) widget.switchTabbarIndex(2);
        break;
    }
  }

  Future<void> _refresh() async {
    _homepageList();
    _getMsgCountRequest();
    _current = 1;
    _downloadData();
    _orderCount();
  }

  Future<void> _onLoad() async {
    _current++;
    _downloadData();
  }

  ///工作计划列表
  Future<void> _downloadData() async {
    try {
      Map<String, dynamic> map = {
        'current': _current,
        'size': _pageSize,
        'status': 2,
        'type': '',
        'userids': '',
        'startTime': '',
        'endTime': '',
      };
      // print('param = ${jsonEncode(map)}');
      final val = await requestPost(Api.reportList, json: jsonEncode(map));
      // LogUtil.d('reportList value = $val');
      final data = jsonDecode(val.toString());
      if (_current == 1) _reportList.clear();
      final List<dynamic> list = data['data'];
      list.forEach((map) {
        HomeReportModel model = HomeReportModel.fromJson(map);
        _reportList.add(model);
      });
      bool noMore = false;
      if (list == null || list.isEmpty) noMore = true;
      _controller.finishRefresh(success: true);
      _controller.finishLoad(success: true, noMore: noMore);
      if (mounted) setState(() {});
    } catch (error) {
      _controller.finishRefresh(success: false);
      _controller.finishLoad(success: false, noMore: false);
    }
  }

  ///首页菜单列表
  Future<void> _homepageList() async {
    Map<String, dynamic> map = {'roleIds': Store.readAppRoleId()};
    requestGet(Api.homepageList, param: map).then((value) {
      var data = jsonDecode(value.toString());
      LogUtil.d('请求结果---homepageList----$data');
      homepageList = (data['data']['menuList'] as List).cast();
      homepageList.add({'source': 'assets/images/home_more.png', 'name': '更多' , 'code': 'more'});
      jurisdictionList = (data['data']['jurisdictionList'] as List).cast();

      ///判断首页菜单下方功能是否显示
      jurisdictionList.forEach((element) {
        if (element == 'visitPlan'){
          isVisitPlan = true;
        }
        if (element == 'workReport'){
          isWorkReport = true;
        }
      });
      if (mounted) setState(() {});
    });
  }

  ///获取未读消息显示
  Future<void> _getMsgCountRequest() async {
    requestGet(Api.getCategoryCount).then((value) {
      var data = jsonDecode(value.toString());
      final List<dynamic> list = data['data'];
      if (list.isNotEmpty) {
        int count = 0;
        list.forEach((map) {
          String read = map['read'] ?? '0';
          count += int.parse(read);
          if (_msgTime.isEmpty) {
            String time = map['createTime'] ?? '';
            if (time.isNotEmpty) _msgTime = time;
          }
        });
        if (mounted) setState(() => _msgCount = count.toString());
      }
    });
  }

  ///启动相机开始扫码
  Future<void> getQrcodeState() async {
    String qrcode;
    try {
      var result = await BarcodeScanner.scan(
        options: ScanOptions(
          strings: const {
            "cancel": "取消",
            "flash_on": "打开闪光",
            "flash_off": "关闭闪光",
          }
        )
      );
      qrcode = result.rawContent;
    } on PlatformException {
      qrcode = 'Failed to get platform version.';
    }
    print('qrcode==========$qrcode');

    if (qrcode.isNotEmpty){
      Map<String, dynamic> map = {'code': qrcode};
      ///扫码识别冰柜信息
      requestGet(Api.analysisCode, param: map).then((val) {
        var data = json.decode(val.toString());
        LogUtil.d('请求结果---analysisCode----$data');
        Navigator.push(context, MaterialPageRoute(builder: (context) => ScanDetail(data: data['data'])));
      });
    }
  }

  ///获取版本号，判断是否升级
  _getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    ///版本号
    String buildNumber = packageInfo.buildNumber;
    print('版本号---buildNumber----$buildNumber');
    print('版本号---version----${packageInfo.version}');
    if (Platform.isAndroid) {
      Map<String, dynamic> map = {'type': 'android'};
      requestGet(Api.upgrade, param: map).then((val) async{
        var data = json.decode(val.toString());
        print('请求结果---androidVersion----$data');
        if (int.parse(data['data']['edition']) > int.parse(buildNumber)){
          _versionDialog(data['data']['path'], data['data']['content']);
        }
      });
    }
  }

  ///版本升级弹窗
  _versionDialog(url, content) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              return Future.value(false);//屏蔽返回键关闭弹窗
            },
            child: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              title: Text('有新版本，是否升级？'),
              content: Text(content),
              actions: <Widget>[
                TextButton(child: Text('确认', style: TextStyle(color: Color(0xFFC68D3E))), onPressed: (){
                  // Navigator.of(context).pop('ok');
                  _launchURL(url);
                })
              ]
            )
          );
        });
  }

  ///用内置浏览器打开网页
  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      EasyLoading.showToast('Could not launch $url');
    }
  }

  ///判断是否注册eqb
  isEqbContract(){
    requestPost(Api.isEqbContract).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---isEqbContract----$data');
      if (data['msg'] == 'success'){
        Navigator.push(context, MaterialPageRoute(builder:(context)=> ContractPage()));
      }else if (data['msg'] == 'fail_contract'){
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  title: Text('温馨提示'),
                  content: Text('您还未开通电子合同账号，是否开通？'),
                  actions: <Widget>[
                    TextButton(child: Text('取消',style: TextStyle(color: Color(0xFF999999))),onPressed: (){
                      Navigator.of(context).pop('cancel');
                    }),
                    TextButton(child: Text('确认',style: TextStyle(color: Color(0xFFC08A3F))),onPressed: () async {
                      Navigator.of(context).pop('ok');
                      registerContract();
                    })
                  ]
              );
            });
      }else if (data['msg'] == 'fail_customer'){
        AppUtil.showToastCenter('客户不存在');
      }
    });
  }

  ///注册电子合同账号
  registerContract(){
    requestPost(Api.registerContract).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---registerContract----$data');
      if (data['code'] == 200){
        AppUtil.showToastCenter('开通账号成功');
        Navigator.push(context, MaterialPageRoute(builder:(context)=> ContractPage()));
      }else {
        AppUtil.showToastCenter(data['msg']);
      }
    });
  }

  ///判断是否有拜访记录
  isCustomerVisitAdd(){
    requestPost(Api.isCustomerVisit).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---isCustomerVisit----$data');
      String id = data['data']['id'].toString();
      if (id != '-1'){
        Navigator.push(context, MaterialPageRoute(builder:(context)=> CustomerVisitEdit(data: data['data'])));
      }else {
        Navigator.push(context, MaterialPageRoute(builder:(context)=> CustomerVisitAdd()));
      }
    });
  }

  ///获取手机品牌型号
  void getPhoneBrand() async{
    DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
    if(Platform.isAndroid){
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      LogUtil.d('brand----${androidInfo.brand}');
      Store.saveBrand(androidInfo.brand);
    }
  }

  ///获取待审核数量
  _orderCount(){
    requestPost(Api.orderCount).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---orderCount----$data');
      _mainProvider.setCountOne(data['data']['countOne']);
      _mainProvider.setCountZy(data['data']['countZy']);
      _mainProvider.setCountZc(data['data']['countZc']);
      _mainProvider.setCountWl(data['data']['countWl']);
      _mainProvider.setCountBg(data['data']['countBg']);
    });
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    _controller?.dispose();
    super.dispose();
  }
}
