import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
import 'package:good_grandma/common/store.dart';
import 'package:good_grandma/models/declaration_form_model.dart';
import 'package:good_grandma/pages/order/add_order_page.dart';
import 'package:good_grandma/pages/order/order_detail_page.dart';
import 'package:good_grandma/widgets/my_declaration_form_cell.dart';
import 'package:good_grandma/widgets/switch_type_title_widget.dart';
import 'package:provider/provider.dart';

///订单list
class OrderPage extends StatefulWidget {
  const OrderPage({Key key, this.orderType = 1}) : super(key: key);

  ///订单级别 1：一级订单 2：二级订单 3：直营订单
  final int orderType;

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();
  List<Map> _listTitle = [
    {'name': '驳回'},
    {'name': '审核中'},
    {'name': '备货中'},
    {'name': '已发货'}
  ];
  List<DeclarationFormModel> _dataArray = [];
  int _current = 1;
  int _pageSize = 10;
  int _selIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller.callRefresh();
  }

  @override
  Widget build(BuildContext context) {
    Widget listViews = MyEasyRefreshSliverWidget(
        controller: _controller,
        scrollController: _scrollController,
        dataCount: _dataArray.length,
        onRefresh: _refresh,
        onLoad: _onLoad,
        slivers: [
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            DeclarationFormModel model = _dataArray[index];

            return widget.orderType == 0 ? MyDeclarationFormCell(
                model: model,
                orderType: widget.orderType,
                onTap: () async {
                  bool stateChanged = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => OrderDetailPage(model: model)));
                  if (stateChanged != null && stateChanged) {
                    _controller.callRefresh();
                  }
                }
            ) :
            OrderNewListItem(
              model: model,
                onTap: () async {
                  bool stateChanged = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => OrderDetailPage(model: model)));
                  if (stateChanged != null && stateChanged) {
                    _controller.callRefresh();
                  }
                }
            );
          }, childCount: _dataArray.length)),
          SliverSafeArea(sliver: SliverToBoxAdapter())
        ]);
    return Scaffold(
      appBar: AppBar(title: Text(widget.orderType == 3 ? '直营订单' : '订货订单')),
      body: Column(
          children: [
            SwitchTypeTitleWidget(
                backgroundColor: Colors.white,
                selIndex: _selIndex,
                list: _listTitle,
                onTap: (index) {
                  _selIndex = index;
                  _controller.callRefresh();
                }),
            Expanded(child: listViews)
          ]
      ),
      floatingActionButton: Visibility(
        visible: Store.readUserType() != 'zn',
        child: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: AppColors.FFC68D3E,
          onPressed: () async {
            DeclarationFormModel model = DeclarationFormModel();
            bool needRefresh = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        ChangeNotifierProvider<DeclarationFormModel>.value(
                          value: model,
                          child: AddOrderPage(orderType: widget.orderType),
                        )));
            if (needRefresh != null && needRefresh) _refresh();
          }
        )
      )
    );
  }

  Future<void> _refresh() async {
    _current = 1;
    _downloadData();
  }

  Future<void> _onLoad() async {
    _current++;
    _downloadData();
  }

  Future<void> _downloadData() async {
    try {
      Map<String, dynamic> map = {
        'current': _current,
        'size': _pageSize,
        'middleman': widget.orderType,
        'status': Store.readUserType() == 'zn'//工厂用户只能看到待发货状态的订单
            ? 2
            : _selIndex
      };
      final val = await requestPost(Api.orderList, json: jsonEncode(map));
      LogUtil.d('${Api.orderList} value = $val');
      var data = jsonDecode(val.toString());
      if (_current == 1) _dataArray.clear();
      final List<dynamic> list = data['data'];
      list.forEach((map) {
        DeclarationFormModel model = DeclarationFormModel.fromJsonList(map);
        _dataArray.add(model);
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

  @override
  void dispose() {
    super.dispose();
    _scrollController?.dispose();
    _controller?.dispose();
  }
}
