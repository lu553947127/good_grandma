import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/models/StoreModel.dart';
import 'package:good_grandma/models/declaration_form_model.dart';
import 'package:good_grandma/models/goods_model.dart';
import 'package:good_grandma/pages/declaration_form/add_declaration_form_page.dart';
import 'package:good_grandma/pages/declaration_form/declaration_form_detail_page.dart';
import 'package:good_grandma/pages/work/work_report/work_type_title.dart';
import 'package:good_grandma/widgets/my_declaration_form_cell.dart';
import 'package:provider/provider.dart';

///我的报单
class MyDeclarationFormPage extends StatefulWidget {
  const MyDeclarationFormPage({Key key}) : super(key: key);

  @override
  _MyDeclarationFormPageState createState() => _MyDeclarationFormPageState();
}

class _MyDeclarationFormPageState extends State<MyDeclarationFormPage> {
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
      appBar: AppBar(title: const Text('我的报单')),
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
                onTap: () async {
                  //todo:根据账户信息判断是否能够审核报单
                  bool canDecision = true;
                  bool stateChanged = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => DeclarationFormDetailPage(
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
                        child: AddDeclarationFormPage(),
                      )));
          if (needRefresh != null && needRefresh) {
            _refresh();
          }
        },
      ),
    );
  }

  void _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    _dataArray.clear();
    _dataArray.addAll(List.generate(4, (index) {
      DeclarationFormModel model = DeclarationFormModel();
      model.setStatus(1);
      model.time = '2021-08-30 00:00:00';
      model.setStoreModel(StoreModel(name: '客户名称$index'));
      model.setArrays(
          model.goodsList,
          List.generate(
              3,
              (i) {
                GoodsModel goodsModel = GoodsModel(
                  name: '商品名称$i',
                  image:
                  'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
                  count: 100 + i,
                  invoice: 234.0,
                );
                goodsModel.specs.add(SpecModel(spec: '20'));
                return goodsModel;
              }));
      return model;
    }));
    if (mounted) setState(() {});
  }
}
