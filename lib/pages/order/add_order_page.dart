import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/StoreModel.dart';
import 'package:good_grandma/models/declaration_form_model.dart';
import 'package:good_grandma/models/goods_model.dart';
import 'package:good_grandma/pages/declaration_form/select_store_page.dart';
import 'package:good_grandma/pages/stock/select_goods_page.dart';
import 'package:good_grandma/widgets/order_add_page_goods_cell.dart';
import 'package:good_grandma/widgets/order_goods_count_view.dart';
import 'package:good_grandma/widgets/post_add_input_cell.dart';
import 'package:good_grandma/widgets/submit_btn.dart';
import 'package:provider/provider.dart';

///新增订单
class AddOrderPage extends StatefulWidget {
  const AddOrderPage({Key key, this.editing = false}) : super(key: key);

  ///是否是编辑订单
  final bool editing;

  @override
  _AddOrderPageState createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  final TextEditingController _editingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    final DeclarationFormModel addModel =
        Provider.of<DeclarationFormModel>(context);

    double countWeight = 0;
    countWeight /= 1000;

    List<Map> list = [
      {'title': '备注', 'hintText': '请输入备注', 'value': addModel.remark},
      {'title': '收货地址', 'hintText': '请输入收货地址', 'value': addModel.address},
    ];

    //TODO:下单人员信息需要从登录用户的信息中获取
    String userName = '李四';
    return WillPopScope(
      onWillPop: () => AppUtil.onWillPop(context),
      child: Scaffold(
        appBar: AppBar(title: Text(widget.editing ? '编辑订单' : '新增订单')),
        body: Scrollbar(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: DefaultTextStyle(
                    style: const TextStyle(
                        color: AppColors.FF959EB1, fontSize: 14.0),
                    child: Row(
                      children: [
                        Text('下单人员'),
                        Spacer(),
                        Text(userName ?? ''),
                      ],
                    ),
                  ),
                ),
              ),
              //客户名称
              SliverToBoxAdapter(
                child: PostAddInputCell(
                  title: '客户',
                  value: addModel.storeModel.name,
                  hintText: '请选择客户',
                  endWidget: Icon(Icons.chevron_right),
                  onTap: () async {
                    StoreModel result = await Navigator.push(context,
                        MaterialPageRoute(builder: (_) => SelectStorePage()));
                    if (result != null) addModel.setStoreModel(result);
                  },
                ),
              ),
              //请选择商品
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  child: ListTile(
                    title: const Text('请选择商品',
                        style: TextStyle(
                            color: AppColors.FF2F4058, fontSize: 14.0)),
                    trailing: IconButton(
                        onPressed: () async {
                          List<GoodsModel> _selGoodsList = await Navigator.push(
                              context, MaterialPageRoute(builder: (_) {
                            return SelectGoodsPage(
                                selGoods: addModel.goodsList);
                          }));
                          if (_selGoodsList != null) {
                            addModel.setArrays(
                                addModel.goodsList, _selGoodsList);
                          }
                        },
                        icon:
                            Icon(Icons.add_circle, color: AppColors.FFC68D3E)),
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                GoodsModel model = addModel.goodsList[index];
                return AddPageGoodsCell(
                  model: model,
                  editingController: _editingController,
                  focusNode: _focusNode,
                  deleteAction: () =>
                      addModel.deleteArrayWith(addModel.goodsList, index),
                  numberChangeAction: () =>
                      addModel.editArrayWith(addModel.goodsList, index, model),
                );
              }, childCount: addModel.goodsList.length)),
              //商品总数
              SliverToBoxAdapter(
                child: OrderGoodsCountView(
                  count: addModel.goodsCount,
                  countWeight: countWeight,
                  countPrice: addModel.goodsPrice,
                ),
              ),
              //奖励商品
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    color: Colors.white,
                    child: ListTile(
                      title: const Text('奖励商品',
                          style: TextStyle(
                              color: AppColors.FF2F4058, fontSize: 14.0)),
                      trailing: IconButton(
                          onPressed: () async {
                            List<GoodsModel> _selGoodsList =
                                await Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                              return SelectGoodsPage(
                                  selGoods: addModel.rewardGoodsList);
                            }));
                            if (_selGoodsList != null) {
                              addModel.setArrays(
                                  addModel.rewardGoodsList, _selGoodsList);
                            }
                          },
                          icon: Icon(Icons.add_circle,
                              color: AppColors.FFC68D3E)),
                    ),
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                GoodsModel model = addModel.rewardGoodsList[index];
                return AddPageGoodsCell(
                  model: model,
                  editingController: _editingController,
                  focusNode: _focusNode,
                  deleteAction: () =>
                      addModel.deleteArrayWith(addModel.rewardGoodsList, index),
                  numberChangeAction: () => addModel.editArrayWith(
                      addModel.rewardGoodsList, index, model),
                );
              }, childCount: addModel.rewardGoodsList.length)),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                Map map = list[index];
                String title = map['title'];
                String hintText = map['hintText'];
                String value = map['value'];
                return Column(
                  children: [
                    SizedBox(height: 10.0),
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        onTap: () => _onTap(
                            context: context,
                            index: index,
                            hintText: hintText,
                            value: value),
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(title,
                              style: const TextStyle(
                                  color: AppColors.FF2F4058, fontSize: 14.0)),
                        ),
                        subtitle: value.isNotEmpty
                            ? Text(value)
                            : Text(hintText,
                                style: const TextStyle(
                                    color: AppColors.FFC1C8D7, fontSize: 14.0)),
                      ),
                    ),
                  ],
                );
              }, childCount: list.length)),
              SliverSafeArea(
                sliver: SliverToBoxAdapter(
                  child: SubmitBtn(
                    title: '提  交',
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTap({
    BuildContext context,
    int index,
    String hintText,
    String value,
  }) async {
    final DeclarationFormModel addModel =
        Provider.of<DeclarationFormModel>(context, listen: false);
    AppUtil.showInputDialog(
        context: context,
        editingController: _editingController,
        focusNode: _focusNode,
        text: value,
        hintText: hintText,
        keyboardType: index == 0 ? TextInputType.number : TextInputType.text,
        callBack: (text) {
          switch (index) {
            case 0:
              addModel.setRemark(text);
              break;
            case 1:
              addModel.setAddress(text);
              break;
          }
        });
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _editingController.dispose();
  }
}
