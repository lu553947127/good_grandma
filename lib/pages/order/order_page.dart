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

  ///订单级别 1：一级订单 2：二级订单 3：我的报单
  final int orderType;

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();
  List<Map> _listTitle = [
    {'name': '全部'},
    {'name': '待确认'},
    {'name': '待发货'},
    {'name': '待收货'},
    {'name': '已完成'},
    {'name': '驳回'},
  ];
  List<DeclarationFormModel> _dataArray = [];
  int _current = 1;
  int _pageSize = 10;
  int _selIndex = 0;

  @override
  void initState() {
    super.initState();
    // if (widget.orderType == 2) _listTitle.removeAt(1);
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
            return MyDeclarationFormCell(
              model: model,
              firstOrder: widget.orderType == 1,
              onTap: () async {
                bool stateChanged = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => OrderDetailPage(model: model)));
                if (stateChanged != null && stateChanged) {
                  _controller.callRefresh();
                }
              },
            );
          }, childCount: _dataArray.length)),
          SliverSafeArea(sliver: SliverToBoxAdapter()),
        ]);
    return Scaffold(
      appBar: AppBar(title: const Text('订货订单')),
      body: Store.readUserType() == 'zn' //工厂用户
          ? listViews
          : Column(
              children: [
                SwitchTypeTitleWidget(
                    backgroundColor: Colors.white,
                    selIndex: _selIndex,
                    list: _listTitle,
                    onTap: (index) {
                      _selIndex = index;
                      _controller.callRefresh();
                    }),
                Expanded(
                  child: listViews,
                ),
              ],
            ),
      floatingActionButton: Visibility(
        visible: widget.orderType != 3 && Store.readUserType() != 'zn',
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
                          child: AddOrderPage(middleman: widget.orderType == 2),
                        )));
            if (needRefresh != null && needRefresh) _refresh();
          },
        ),
      ),
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
        // 'status': Store.readUserType() == 'zn'//工厂用户只能看到待发货状态的订单
        //     ? 2
        //     : widget.orderType == 2
        //         ? (_selIndex > 0 ? _selIndex + 1 : _selIndex)
        //         : _selIndex
        'status': Store.readUserType() == 'zn'//工厂用户只能看到待发货状态的订单
            ? 2
            : _selIndex
      };
      // print('param = ${jsonEncode(map)}');
      String url = Api.orderList;
      if (widget.orderType == 3) url = Api.myOrderList;
      final val = await requestPost(url, json: jsonEncode(map));
      LogUtil.d('$url value = $val');
      var data = jsonDecode(val.toString());
      if (_current == 1) _dataArray.clear();
      final List<dynamic> list = data['data'];
      // print(list.toString());
      list.forEach((map) {
        DeclarationFormModel model = DeclarationFormModel.fromJson(map);
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
