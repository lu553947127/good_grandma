import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
import 'package:good_grandma/models/declaration_form_model.dart';
import 'package:good_grandma/pages/order/add_order_page.dart';
import 'package:good_grandma/pages/order/order_detail_page.dart';
import 'package:good_grandma/widgets/my_declaration_form_cell.dart';
import 'package:good_grandma/widgets/switch_type_title_widget.dart';
import 'package:provider/provider.dart';

///订单list
class OrderPage extends StatefulWidget {
  const OrderPage({Key key, this.middleman = false}) : super(key: key);

  ///是否是二级订单
  final bool middleman;

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();
  List<Map> _listTitle = [
    {'name': '全部'},
    {'name': '待确认'},
    {'name': '已完成'},
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
    return Scaffold(
      appBar: AppBar(title: const Text('订货订单')),
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
          Expanded(
            child: MyEasyRefreshSliverWidget(
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
                      firstOrder: !widget.middleman,
                      onTap: () async {
                        ///根据账户信息判断是否能够审核报单
                        bool canDecision = true;
                        bool stateChanged = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => OrderDetailPage(
                                      model: model,
                                      canDecision: canDecision,
                                    )));
                        if (stateChanged != null && stateChanged) {
                          _controller.callRefresh();
                        }
                      },
                    );
                  }, childCount: _dataArray.length)),
                  SliverSafeArea(sliver: SliverToBoxAdapter()),
                ]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
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
                        child: AddOrderPage(middleman: widget.middleman),
                      )));
          if (needRefresh != null && needRefresh) {
            _refresh();
          }
        },
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
        'middleman': !widget.middleman ? 1 : 2,
        'status': _selIndex
      };
      final val = await requestPost(Api.orderList, json: jsonEncode(map));
      // LogUtil.d('orderCusList value = $val');
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
