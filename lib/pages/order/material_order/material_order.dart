import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/order/material_order/material_order_add.dart';
import 'package:good_grandma/pages/order/material_order/material_order_detail.dart';
import 'package:good_grandma/pages/order/material_order/material_order_model.dart';
import 'package:good_grandma/widgets/switch_type_title_widget.dart';
import 'package:provider/provider.dart';

///物料订单页面
class MaterialOrderPage extends StatefulWidget {
  const MaterialOrderPage({Key key}) : super(key: key);

  @override
  _MaterialOrderPageState createState() => _MaterialOrderPageState();
}

class _MaterialOrderPageState extends State<MaterialOrderPage> {

  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();

  int _current = 1;
  int _pageSize = 10;
  List<Map> materialList = [];
  ///是否有添加权限
  bool isJurisdiction = false;
  String newKey = '';

  List<Map> _listTitle = [];
  int _selIndex = 0;
  String _status = '1';

  @override
  void initState() {
    super.initState();
    _controller.callRefresh();
  }

  @override
  Widget build(BuildContext context) {

    _setTextStatus(status, Map map){
      switch(status){
        case 1:
          return '${map['authName']}';
          break;
        case 2:
          return '审核通过';
          break;
        case 3:
          return '已入库';
          break;
        case 4:
          return '驳回';
          break;
        case 5:
          return '已终止';
          break;
        case 6:
          if (map['ifsplit'] == 0){
            return '已发货';
          }else {
            return '已发货（部分发货）';
          }
          break;
        case 7:
          return '未发货';
          break;
        default:
          return '无';
          break;
      }
    }

    return Scaffold(
        appBar: AppBar(title: Text('物料订单')),
        body: Column(
          children: [
            SwitchTypeTitleWidget(
                backgroundColor: Colors.white,
                selIndex: _selIndex,
                list: _listTitle,
                onTap: (index) {
                  _selIndex = index;
                  _status = _listTitle[index]['status'];
                  _controller.callRefresh();
                }),
            Expanded(child: MyEasyRefreshSliverWidget(
                controller: _controller,
                scrollController: _scrollController,
                dataCount: materialList.length,
                onRefresh: _refresh,
                onLoad: _onLoad,
                slivers: [
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        Map map = materialList[index];
                        String userName = map['userName'];
                        String createTime = map['createTime'];
                        int status = map['status'];
                        String totalPrice = map['totalPrice'].toString();
                        String company = map['company'];
                        return Container(
                            margin: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                                color: Colors.white, borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    offset: Offset(2, 1),
                                    blurRadius: 1.5,
                                  )
                                ]
                            ),
                            child: ListTile(
                                title: Column(
                                    mainAxisSize:MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(userName, style: TextStyle(fontSize: 14, color: Color(0XFFE45C26))),
                                                  SizedBox(height: 10),
                                                  Text(createTime, style: TextStyle(fontSize: 12, color: Color(0XFF959EB1)))
                                                ]
                                            ),
                                            Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFF1E1E2), borderRadius: BorderRadius.circular(3),
                                                ),
                                                child: Text(_setTextStatus(status, map),
                                                    style: TextStyle(fontSize: 10, color: Color(0xFFDD0000)))
                                            )
                                          ]
                                      ),
                                      SizedBox(height: 10),
                                      SizedBox(
                                          width: MediaQuery.of(context).size.width,
                                          height: 1,
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(color: Color(0xFFEFEFF4)),
                                          )
                                      ),
                                      SizedBox(height: 5),
                                      Text('公司: $company',style: TextStyle(fontSize: 12,color: AppColors.FF959EB1)),
                                      SizedBox(height: 5),
                                      Text('总价: $totalPrice',style: TextStyle(fontSize: 12,color: AppColors.FF959EB1))
                                    ]
                                ),
                                onTap: () async {
                                  bool needRefresh = await Navigator.push(context,
                                      MaterialPageRoute(builder:(context)=> MaterialOrderDetail(data: materialList[index])));
                                  if(needRefresh != null && needRefresh){
                                    _controller.callRefresh();
                                  }
                                }
                            )
                        );
                      }, childCount: materialList.length)),
                ]
            ))
          ]
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: AppColors.FFC68D3E,
            onPressed: () async {
              if (isJurisdiction){
                MarketingOrderModel model = MarketingOrderModel();
                bool needRefresh = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                        ChangeNotifierProvider<MarketingOrderModel>.value(
                          value: model,
                          child: MaterialOrderAddPage(id: '', data: null, newKey: newKey),
                        )));
                if(needRefresh != null && needRefresh){
                  _controller.callRefresh();
                }
              }else {
                showToast("抱歉，您没有添加权限");
              }
            }
        )
    );
  }

  Future<void> _refresh() async {
    _current = 1;
    await _downloadData();
    _materialAddAuth();
    _materialGetStatusList();
  }

  Future<void> _onLoad() async {
    _current++;
    await _downloadData();
  }

  ///市场物料列表
  Future<void> _downloadData() async {
    try {
      Map<String, dynamic> map = {'current': _current, 'size': _pageSize, 'status': _status};
      final val = await requestGet(Api.materialOrderList, param: map);
      var data = jsonDecode(val.toString());
      LogUtil.d('请求结果---materialOrderList----$data');
      if (_current == 1) materialList.clear();
      final List<dynamic> list = data['data'];
      list.forEach((map) {
        materialList.add(map);
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

  ///判断是否有新增权限
  Future<void> _materialAddAuth() async{
    Map<String, dynamic> map = {'id': '1539419776077631490'};
    requestPost(Api.materialAddAuth, json: jsonEncode(map)).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---materialAddAuth----$data');
      isJurisdiction = data['data'];
      if (mounted) setState(() {});
    });
  }

  ///物料订单获取订单状态列表
  Future<void> _materialGetStatusList() async{
    requestGet(Api.materialGetStatusList).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---materialGetStatusList----$data');
      _listTitle.clear();
      final List<dynamic> list = data['data'];
      list.forEach((element) {
        Map map = new Map();
        map['name'] = element['dictValue'];
        map['status'] = element['dictKey'];
        _listTitle.add(map);
      });
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    _controller?.dispose();
    super.dispose();
  }
}