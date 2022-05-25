import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/models/StoreModel.dart';
import 'package:good_grandma/models/declaration_form_model.dart';
import 'package:good_grandma/models/goods_model.dart';
import 'package:good_grandma/widgets/my_declaration_form_cell.dart';
import 'package:good_grandma/widgets/order_goods_count_view.dart';

///报单详情
class DeclarationFormDetailPage extends StatefulWidget {
  const DeclarationFormDetailPage(
      {Key key, @required this.model, this.canDecision = false})
      : super(key: key);
  final bool canDecision;
  final DeclarationFormModel model;

  @override
  _DeclarationFormDetailPageState createState() =>
      _DeclarationFormDetailPageState();
}

class _DeclarationFormDetailPageState extends State<DeclarationFormDetailPage> {
  DeclarationFormModel _model = DeclarationFormModel();

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    double countWeight = _model.goodsWeight;
    countWeight /= 1000;
    return Scaffold(
      appBar: AppBar(title: const Text('报单详情')),
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
            // SliverVisibility(
            //   visible: _model.remark != null && _model.remark.isNotEmpty,
            //   sliver: SliverPadding(
            //     padding: const EdgeInsets.symmetric(
            //         horizontal: 15.0, vertical: 10.0),
            //     sliver: SliverToBoxAdapter(
            //       child: Card(
            //         child: Padding(
            //           padding: const EdgeInsets.symmetric(
            //               horizontal: 20.0, vertical: 15.0),
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               const Text('备注信息',
            //                   style: TextStyle(
            //                       color: AppColors.FF959EB1, fontSize: 12.0)),
            //               SizedBox(height: 12.0),
            //               Text(_model.remark,
            //                   style: TextStyle(
            //                       color: AppColors.FF2F4058, fontSize: 12.0)),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: widget.canDecision,
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
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.FF959EB1,
                      shape: StadiumBorder(),
                    ),
                    child: const Text('驳回',
                        style: TextStyle(color: Colors.white, fontSize: 15.0))),
              ),
              SizedBox(
                width: 150,
                height: 44,
                child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.FFC08A3F,
                      shape: StadiumBorder(),
                    ),
                    child: const Text('确认审核',
                        style: TextStyle(color: Colors.white, fontSize: 15.0))),
              ),
            ],
          ),
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
    // _model.setRemark('备注信息具体内容备注信息具体内容备注信息具体内容备注信息具体内容备注信息具体内容备注信息具体。');
    _model.setArrays(
        _model.goodsList,
        List.generate(
            3,
            (i) => GoodsModel(
                  name: '商品名称$i',
                  image:
                      'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
                  count: 100 + i,
                  // specs: ['规格：1*40'],
                  invoice: 234.0,
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
                    Expanded(child: Text(_model.storeModel.name)),
                    Text(
                      _model.statusName,
                      style: TextStyle(
                          color: _model.status == 4
                              ? Colors.grey
                              : AppColors.FFC08A3F,
                          fontSize: 12.0),
                    ),
                  ],
                ),
                Text(_model.time,
                    style: const TextStyle(
                        color: AppColors.FF959EB1, fontSize: 12.0)),
                const Divider(),
                Text.rich(TextSpan(
                    text: '联系电话：',
                    style: const TextStyle(
                        color: AppColors.FF959EB1, fontSize: 12.0),
                    children: [
                      TextSpan(
                        text: _model.phone,
                        style: const TextStyle(
                          color: AppColors.FF2F4058,
                        ),
                      )
                    ])),
                Text.rich(TextSpan(
                    text: '收货地址：',
                    style: const TextStyle(
                        color: AppColors.FF959EB1, fontSize: 12.0),
                    children: [
                      TextSpan(
                        text: _model.address,
                        style: const TextStyle(
                          color: AppColors.FF2F4058,
                        ),
                      )
                    ])),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
