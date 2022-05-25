import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/declaration_form_model.dart';
import 'package:good_grandma/models/goods_model.dart';
import 'package:good_grandma/widgets/order_add_page_goods_cell.dart';
import 'package:good_grandma/widgets/order_goods_count_view.dart';
import 'package:good_grandma/widgets/post_add_input_cell.dart';
import 'package:good_grandma/widgets/submit_btn.dart';
import 'package:provider/provider.dart';

///新增报单
class AddDeclarationFormPage extends StatefulWidget {
  const AddDeclarationFormPage({Key key}) : super(key: key);

  @override
  _AddDeclarationFormPageState createState() => _AddDeclarationFormPageState();
}

class _AddDeclarationFormPageState extends State<AddDeclarationFormPage> {
  final TextEditingController _editingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    final DeclarationFormModel addModel =
        Provider.of<DeclarationFormModel>(context);

    double countWeight = 0;
    countWeight /= 1000;

    List<Map> list = [
      {'title': '联系电话', 'hintText': '请输入电话号码', 'value': addModel.phone},
      {'title': '收货地址', 'hintText': '请输入收货地址', 'value': addModel.address},
      // {'title': '备注', 'hintText': '请输入备注', 'value': addModel.remark}
    ];

    return WillPopScope(
      onWillPop: () => AppUtil.onWillPop(context),
      child: Scaffold(
        appBar: AppBar(title: const Text('新增报单')),
        body: Scrollbar(
          child: CustomScrollView(
            slivers: [
              //店铺名称
              SliverToBoxAdapter(
                child: PostAddInputCell(
                  title: '店铺名称',
                  value: addModel.storeModel.name,
                  hintText: '请选择店铺',
                  endWidget: Icon(Icons.chevron_right),
                  onTap: () async {
                    // StoreModel result = await Navigator.push(context,
                    //     MaterialPageRoute(builder: (_) => SelectStorePage()));
                    // if (result != null) addModel.setStoreModel(result);
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
                          // List<GoodsModel> _selGoodsList = await Navigator.push(
                          //     context, MaterialPageRoute(builder: (_) {
                          //   return SelectGoodsPage(
                          //       selGoods: addModel.goodsList,customerId: addModel.storeModel.id);
                          // }));
                          // if (_selGoodsList != null) {
                          //   addModel.setArrays(
                          //       addModel.goodsList, _selGoodsList);
                          // }
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
              addModel.setPhone(text);
              break;
            case 1:
              addModel.setAddress(text);
              break;
            case 2:
              // addModel.setRemark(text);
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
