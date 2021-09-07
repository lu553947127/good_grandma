import 'package:flutter/material.dart';
import 'package:good_grandma/models/StoreModel.dart';
import 'package:good_grandma/models/declaration_form_model.dart';
import 'package:good_grandma/models/goods_model.dart';
import 'package:good_grandma/pages/order/order_detail_page.dart';
import 'package:good_grandma/pages/work/work_report/work_type_title.dart';
import 'package:good_grandma/widgets/my_declaration_form_cell.dart';

///二级订单
class SecondOrderPage extends StatefulWidget {
  const SecondOrderPage({Key key}) : super(key: key);

  @override
  _SecondOrderPageState createState() => _SecondOrderPageState();
}

class _SecondOrderPageState extends State<SecondOrderPage> {
  String _type = '全部';
  List<Map> _listTitle = [
    {'name': '全部'},
    {'name': '待确认'},
    {'name': '已完成'},
  ];
  List<DeclarationFormModel> _dataArray = [];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('订货订单')),
      body: Scrollbar(
        child: CustomScrollView(
          slivers: [
            //切换选项卡
            WorkTypeTitle(
              color: Colors.transparent,
              type: _type,
              list: _listTitle,
              onPressed: () {
                setState(() {
                  _type = _listTitle[0]['name'];
                });
              },
              onPressed2: () {
                setState(() {
                  _type = _listTitle[1]['name'];
                });
              },
              onPressed3: () {
                setState(() {
                  _type = _listTitle[2]['name'];
                });
              },
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              DeclarationFormModel model = _dataArray[index];
              return MyDeclarationFormCell(
                model: model,
                firstOrder: false,
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
                    _refresh();
                  }
                },
              );
            }, childCount: _dataArray.length)),
            SliverSafeArea(sliver: SliverToBoxAdapter()),
          ],
        ),
      ),
    );
  }

  void _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    _dataArray.clear();
    _dataArray.addAll(List.generate(4, (index) {
      DeclarationFormModel model = DeclarationFormModel();
      model.setCompleted(index % 2 == 0);
      model.time = '2021-08-30 00:00:00';
      model.setStoreModel(StoreModel(name: '客户名称$index'));
      model.setArrays(
          model.goodsList,
          List.generate(
              3,
              (i) => GoodsModel(
                    name: '商品名称$i',
                    image:
                        'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
                    count: 100 + i,
                    spec: '规格：1*40',
                    price: 234.0,
                  )));
      return model;
    }));
    if (mounted) setState(() {});
  }
}
