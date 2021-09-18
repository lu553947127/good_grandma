import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/models/StoreModel.dart';
import 'package:good_grandma/models/declaration_form_model.dart';
import 'package:good_grandma/models/goods_model.dart';
import 'package:good_grandma/widgets/my_declaration_form_cell.dart';
import 'package:good_grandma/widgets/order_goods_count_view.dart';
import 'package:good_grandma/pages/order/add_order_page.dart';
import 'package:good_grandma/widgets/submit_btn.dart';
import 'package:provider/provider.dart';

///订单详情
class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage(
      {Key key, @required this.model, this.canDecision = false})
      : super(key: key);
  final bool canDecision;
  final DeclarationFormModel model;

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  DeclarationFormModel _model = DeclarationFormModel();

  @override
  void initState() {
    super.initState();
    _model.setModelWithModel(widget.model);
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    double countWeight = _model.goodsWeight;
    countWeight /= 1000;
    return Scaffold(
      appBar: AppBar(
        title: const Text('订单详情'),
        actions: [
          Visibility(
            visible: !_model.completed,
            child: TextButton(
                onPressed: () async {
                  bool needRefresh = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ChangeNotifierProvider<
                                  DeclarationFormModel>.value(
                                value: _model,
                                child: AddOrderPage(
                                  editing: true,
                                ),
                              )));
                  if (needRefresh != null && needRefresh) {
                    _refresh();
                  }
                },
                child: const Text('编辑',
                    style: const TextStyle(
                        color: AppColors.FFC08A3F, fontSize: 14.0))),
          ),
        ],
      ),
      body: Scrollbar(
        child: CustomScrollView(
          slivers: [
            _Header(model: _model),
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
                                    style: const TextStyle(fontSize: 12.0),
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
            SliverPadding(
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
            SliverVisibility(
              visible: _model.remark != null && _model.remark.isNotEmpty,
              sliver: SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 10.0),
                sliver: SliverToBoxAdapter(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('备注信息',
                              style: TextStyle(
                                  color: AppColors.FF959EB1, fontSize: 12.0)),
                          SizedBox(height: 12.0),
                          Text(_model.remark,
                              style: TextStyle(
                                  color: AppColors.FF2F4058, fontSize: 12.0)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverVisibility(
              visible: !_model.completed,
              sliver: SliverToBoxAdapter(
                child: SubmitBtn(
                    title: '确认收货',
                    onPressed: () async {
                      bool result = await showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (_) {
                            return Container(
                              height:
                                  116 + MediaQuery.of(context).padding.bottom,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20.0)),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(22.0),
                                    child: const Text('是否确认收货？',
                                        style: TextStyle(fontSize: 15.0)),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        width: 137,
                                        height: 40,
                                        child: TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            style: TextButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.FFEFEFF4,
                                              shape: StadiumBorder(),
                                            ),
                                            child: const Text('取消',
                                                style: TextStyle(
                                                    color: AppColors.FF959EB1,
                                                    fontSize: 15.0))),
                                      ),
                                      SizedBox(
                                        width: 137,
                                        height: 40,
                                        child: TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            style: TextButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.FFC08A3F,
                                              shape: StadiumBorder(),
                                            ),
                                            child: const Text('确定',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15.0))),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          });
                      if (result != null && result) {
                        ///确认收货请求
                        setState(() => _model.setCompleted(true));
                      }
                    }),
              ),
            ),
            SliverSafeArea(sliver: SliverToBoxAdapter()),
          ],
        ),
      ),
    );
  }

  void _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    _model.setStoreModel(StoreModel(
      name: _model.storeModel.name,
      phone: '1234567890',
      address: '山东省济南市历下区舜华路',
    ));
    _model.setPhone('1234567890');
    _model.setAddress('山东省济南市历下区舜华路');
    _model.setRemark('备注信息具体内容备注信息具体内容备注信息具体内容备注信息具体内容备注信息具体内容备注信息具体。');
    _model.setArrays(
        _model.goodsList,
        List.generate(
            3,
            (i) => GoodsModel(
                  name: '商品名称$i',
                  image:
                      'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
                  count: 100 + i,
                  // spec: '规格：1*40',
                  price: 234.0,
                  weight: 1000,
                )));
    _model.setArrays(
        _model.rewardGoodsList,
        List.generate(
            2,
            (i) => GoodsModel(
                  name: '商品名称$i',
                  image:
                      'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
                  count: 100 + i,
                  // spec: '规格：1*40',
                  price: 234.0,
                  weight: 1000,
                )));
    if (mounted) setState(() {});
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
                                color: _model.completed
                                    ? Colors.black
                                    : AppColors.FFE45C26,
                                fontSize: 14.0))),
                    Card(
                      color: _model.completed
                          ? AppColors.FFEFEFF4
                          : AppColors.FFE45C26.withOpacity(0.1),
                      shadowColor: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 4.5),
                        child: Text(
                          _model.completed ? '已完成' : '待确认',
                          style: TextStyle(
                              color: _model.completed
                                  ? AppColors.FF959EB1
                                  : AppColors.FFE45C26,
                              fontSize: 12.0),
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
                              color: AppColors.FF959EB1, fontSize: 12.0)),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    Image.asset('assets/images/sign_in_local2.png',
                        width: 12, height: 12),
                    Expanded(
                      child: Text('  收货地址：${_model.address}',
                          style: const TextStyle(
                              color: AppColors.FF959EB1, fontSize: 12.0)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Image.asset('assets/images/ic_login_phone_dark_grey.png',
                        width: 12, height: 12),
                    Expanded(
                      child: Text('  联系电话：${_model.phone}',
                          style: const TextStyle(
                              color: AppColors.FF959EB1, fontSize: 12.0)),
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
