import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
import 'package:good_grandma/common/store.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/declaration_form_model.dart';
import 'package:good_grandma/widgets/my_declaration_form_cell.dart';
import 'package:good_grandma/widgets/order_goods_count_view.dart';
import 'package:good_grandma/pages/order/add_order_page.dart';
import 'package:good_grandma/widgets/submit_btn.dart';
import 'package:provider/provider.dart';

///订单详情
class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({Key key, @required this.model}) : super(key: key);
  final DeclarationFormModel model;

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  DeclarationFormModel _model = DeclarationFormModel();
  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _model.setModelWithModel(widget.model);
    _controller.callRefresh();
  }

  @override
  Widget build(BuildContext context) {
    double countWeight = _model.goodsWeightForDetail;
    // print('Store.readUserType() = ${Store.readUserType()}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('订单详情'),
        actions: [
          Visibility(
            visible: (_model.status == 1 &&
                    _model.createUserId == Store.readUserId()) ||
                (_model.status == 5 && Store.readUserType() == 'xsb'),
            child: TextButton(
                onPressed: () async {
                  bool needRefresh = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ChangeNotifierProvider<
                                  DeclarationFormModel>.value(
                                value: _model,
                                child: AddOrderPage(editing: true),
                              )));
                  if (needRefresh != null && needRefresh)
                    _controller.callRefresh();
                },
                child: const Text('编辑',
                    style: const TextStyle(
                        color: AppColors.FFC08A3F, fontSize: 14.0))),
          ),
        ],
      ),
      body: MyEasyRefreshSliverWidget(
          controller: _controller,
          scrollController: _scrollController,
          dataCount: _model.goodsList.length,
          onRefresh: _refresh,
          onLoad: null,
          slivers: [
            _Header(model: _model),
            //驳回理由
            SliverVisibility(
              visible: _model.status == 5 &&
                  _model.reject != null &&
                  _model.reject.isNotEmpty,
              sliver: _TextCell(value: _model.reject, title: '驳回理由'),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              sliver: SliverToBoxAdapter(
                child: Card(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 15.0),
                    child: Column(
                      children: [
                        ..._model.goodsList.map((goodsModel) => Column(
                              children: [
                                DeclarationGoodsCell(goodsModel: goodsModel),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    '总额：¥ ' +
                                        goodsModel.countPrice
                                            .toStringAsFixed(2),
                                    style: const TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                const Divider(),
                              ],
                            )),
                        OrderGoodsCountView(
                          count: _model.goodsCount,
                          countWeight: countWeight,
                          countPrice: _model.goodsPrice,
                          padding: const EdgeInsets.all(0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            //奖励商品
            SliverVisibility(
              visible: _model.rewardGoodsList.isNotEmpty,
              sliver: SliverPadding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
                sliver: SliverToBoxAdapter(
                  child: Card(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('奖励商品',
                              style: const TextStyle(
                                  color: AppColors.FF959EB1, fontSize: 14.0)),
                          ..._model.rewardGoodsList.map((goodsModel) =>
                              DeclarationGoodsCell(goodsModel: goodsModel)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            //备注信息
            SliverVisibility(
              visible: _model.remark != null && _model.remark.isNotEmpty,
              sliver: _TextCell(value: _model.remark, title: '备注信息'),
            ),
            //确认收货
            SliverVisibility(
              visible: _model.status == 3 &&
                  (_model.orderType == 1
                      ? _model.createUserId == Store.readUserId() //一级订单 订单创建人签收
                      : Store.readUserType() == 'ejkh'), //二级订单 二级客户签收
              sliver: SliverToBoxAdapter(
                  child: SubmitBtn(
                      title: '确认收货', onPressed: () => _submitAction(context))),
            ),
            SliverSafeArea(sliver: SliverToBoxAdapter()),
          ]),
      //审核 驳回
      bottomNavigationBar: _btmView(context),
    );
  }

  Widget _btmView(BuildContext context) {
    return (Store.readUserType() == 'ejkh' &&
                (_model.status == 2 || _model.status == 5)) || //二级客户取消订单
            (Store.readUserType() == 'xsb' &&
                _model.status == 5 &&
                _model.orderType == 1) //一级订单城市经理可以在订单驳回后取消订单
        ? Container(
            //二级订单这两个状态下有取消订单的功能
            color: Colors.white,
            padding: EdgeInsets.only(
                left: 15.0,
                right: 15.0,
                top: 15.0,
                bottom: 15.0 + MediaQuery.of(context).padding.bottom),
            child: SizedBox(
              width: 150,
              height: 44,
              child: TextButton(
                  onPressed: () => _cancelAction(context),
                  style: TextButton.styleFrom(
                      backgroundColor: AppColors.FFC08A3F,
                      shape: StadiumBorder()),
                  child: const Text('取消订单',
                      style: TextStyle(color: Colors.white, fontSize: 15.0))),
            ),
          )
        : Visibility(
            visible: _model.orderType == 1 //是否是一级订单
                ? ((_model.status == 1 &&
                            (Store.readUserType() == 'yjkh' ||
                                Store.readUserType() ==
                                    'xsb')) || //一级订单待确认时一级客户和城市经理可以审核
                        (_model.status == 2 &&
                            Store.readUserType() == 'zn')) && //一级订单待发货时工厂可以审核
                    Store.readUserId() != _model.createUserId
                : (_model.status == 2 &&
                    Store.readUserType() == 'yjkh'), //2级订单待收货时可以审核
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(
                  left: 15.0,
                  right: 15.0,
                  top: 15.0,
                  bottom: 15.0 + MediaQuery.of(context).padding.bottom),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 150,
                    height: 44,
                    child: TextButton(
                        onPressed: () => _rejectAction(context),
                        style: TextButton.styleFrom(
                            backgroundColor: AppColors.FF959EB1,
                            shape: StadiumBorder()),
                        child: const Text('驳回',
                            style: TextStyle(
                                color: Colors.white, fontSize: 15.0))),
                  ),
                  SizedBox(
                    width: 150,
                    height: 44,
                    child: TextButton(
                        onPressed: () => _examineAction(context),
                        style: TextButton.styleFrom(
                            backgroundColor: AppColors.FFC08A3F,
                            shape: StadiumBorder()),
                        child: const Text('确认审核',
                            style: TextStyle(
                                color: Colors.white, fontSize: 15.0))),
                  ),
                ],
              ),
            ),
          );
  }

  //取消订单
  void _cancelAction(BuildContext context) async {
    bool result = await AppUtil.bottomConformSheet(context, '是否要取消订单？',
        cancelText: '不取消', doneText: '取消');
    if (result != null && result)
      _examineRequest(context, {'id': _model.id, 'status': 6});
  }

  //驳回
  void _rejectAction(BuildContext context) {
    if (_model.orderType == 1 &&
        (Store.readUserType() == 'xsb' || Store.readUserType() == 'yjkh')) {
      //一级订单：工厂可以审核,可以驳回，城市经理、一级客户只能确认,不能驳回。如果订单被驳回，就一定是驳回到城市经理那，城市经理可以编辑重新提交，也可以取消订单
      AppUtil.showToastCenter('您没有驳回权限');
      return;
    }
    AppUtil.showInputDialog(
      context: context,
      editingController: TextEditingController(),
      focusNode: FocusNode(),
      text: '',
      hintText: '请输入驳回理由',
      callBack: (text) => _examineRequest(
          context, {'id': _model.id, 'status': 5, 'reject': text}),
    );
  }

  //确认审核
  void _examineAction(BuildContext context) async {
    bool result = await AppUtil.bottomConformSheet(context, '是否确认审核？');
    if (result != null && result)
      _examineRequest(context, {'id': _model.id, 'status': 0});
  }

  //审核驳回网络请求
  void _examineRequest(BuildContext context, Map param) async {
    // print('param = ${jsonEncode(param)}');
    requestPost(Api.orderSh, json: jsonEncode(param)).then((value) {
      var data = jsonDecode(value.toString());
      // print('data = $data');
      if (data['code'] == 200) Navigator.pop(context, true);
    });
  }

  //确认收货
  void _submitAction(BuildContext context) async {
    // print('_model.id = ${_model.id}');
    bool result = await AppUtil.bottomConformSheet(context, '是否确认收货？');
    if (result != null && result)
      requestPost(Api.orderConfirm, json: jsonEncode({'id': _model.id}))
          .then((value) {
        var data = jsonDecode(value.toString());
        // print('data = $data');
        if (data['code'] == 200) Navigator.pop(context, true);
      });
  }

  Future<void> _refresh() async {
    try {
      Map<String, dynamic> param = {'id': widget.model.id};
      final val = await requestPost(Api.orderDetail, json: jsonEncode(param));
      // LogUtil.d('${Api.orderDetail} value = $val');
      var data = jsonDecode(val.toString());
      Map<String, dynamic> map = data['data'];
      DeclarationFormModel model = DeclarationFormModel.fromJson(map);
      _model.setModelWithModel(model);
      _controller.finishRefresh(success: true);
      if (mounted) setState(() {});
    } catch (error) {
      _controller.finishRefresh(success: false);
    }
  }
}

class _TextCell extends StatelessWidget {
  const _TextCell({
    Key key,
    @required String title,
    @required String value,
  })  : _value = value,
        _title = title,
        super(key: key);

  final String _title;
  final String _value;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      sliver: SliverToBoxAdapter(
        child: Card(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_title,
                    style: const TextStyle(
                        color: AppColors.FF959EB1, fontSize: 14.0)),
                SizedBox(height: 12.0),
                Text(_value ?? '', style: const TextStyle(fontSize: 14.0)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    Key key,
    @required DeclarationFormModel model,
  })  : _model = model,
        super(key: key);

  final DeclarationFormModel _model;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      sliver: SliverToBoxAdapter(
        child: Card(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(_model.storeModel.name,
                            style: TextStyle(
                                color: _model.showGray()
                                    ? Colors.black
                                    : AppColors.FFE45C26,
                                fontSize: 14.0))),
                    Card(
                      color: _model.showGray()
                          ? AppColors.FFEFEFF4
                          : AppColors.FFE45C26.withOpacity(0.1),
                      shadowColor: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 4.5),
                        child: Text(
                          _model.statusName,
                          style: TextStyle(
                              color: _model.showGray()
                                  ? AppColors.FF959EB1
                                  : AppColors.FFE45C26,
                              fontSize: 14.0),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Image.asset('assets/images/icon_visit_statistics_time.png',
                        width: 12, height: 12),
                    Expanded(
                      child: Text('  ' + _model.time,
                          style: const TextStyle(
                              color: AppColors.FF959EB1, fontSize: 14.0)),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    Image.asset('assets/images/sign_in_local2.png',
                        width: 12, height: 12),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text('收货地址：${_model.address}',
                          style: const TextStyle(
                              color: AppColors.FF959EB1, fontSize: 14.0)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Image.asset('assets/images/ic_login_phone_dark_grey.png',
                        width: 12, height: 12),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text('联系电话：${_model.phone}',
                          style: const TextStyle(
                              color: AppColors.FF959EB1, fontSize: 14.0)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
