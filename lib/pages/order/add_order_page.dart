import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/store.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/StoreModel.dart';
import 'package:good_grandma/models/declaration_form_model.dart';
import 'package:good_grandma/models/goods_model.dart';
import 'package:good_grandma/pages/declaration_form/select_store_page.dart';
import 'package:good_grandma/pages/order/amount_details.dart';
import 'package:good_grandma/pages/stock/select_customer_page.dart';
import 'package:good_grandma/pages/stock/select_goods_page.dart';
import 'package:good_grandma/widgets/order_add_page_goods_cell.dart';
import 'package:good_grandma/widgets/order_goods_count_view.dart';
import 'package:good_grandma/widgets/post_add_input_cell.dart';
import 'package:good_grandma/widgets/submit_btn.dart';
import 'package:provider/provider.dart';

///新增订单
class AddOrderPage extends StatefulWidget {
  const AddOrderPage({Key key, this.editing = false, this.middleman = false})
      : super(key: key);

  ///是否是编辑订单
  final bool editing;

  ///是否是二级订单
  final bool middleman;

  @override
  _AddOrderPageState createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  final TextEditingController _editingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  ///账余
  double orderAmount = 0;
  ///是否是编辑
  bool _isEdit = false;

  @override
  Widget build(BuildContext context) {
    final DeclarationFormModel addModel =
        Provider.of<DeclarationFormModel>(context);

    double countWeight = addModel.goodsWeight;

    List<Map> list = [
      {'title': '备注', 'hintText': '请输入备注', 'value': addModel.remark},
      {'title': '收货地址', 'hintText': '请输入收货地址', 'value': addModel.address},
    ];

    String userName = Store.readNickName();

    if (_isEdit == false && widget.editing){
      _isEdit = true;
      _orderAmount(addModel.storeModel.id, addModel);
    }

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
                        const Text('下单人员'),
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
                        MaterialPageRoute(builder: (_) => SelectStorePage(forOrder: true,middleman: widget.middleman,)));
                    if (result != null) {
                      addModel.setStoreModel(result);
                      addModel.setPhone(result.phone);
                      if (widget.middleman && Store.readPostType() == 'zy'){
                        _orderAmount(result.id, addModel);
                      }else {
                        _orderAmount(result.id, addModel);
                      }
                    }
                  }
                )
              ),
              //客户电话
              SliverToBoxAdapter(
                  child: Visibility(
                    visible: addModel.storeModel.id.isNotEmpty,
                    child: PostAddInputCell(
                        title: '客户电话',
                        value: '${addModel.phone}',
                        hintText: '${addModel.phone}',
                        endWidget: Icon(Icons.chevron_right),
                        onTap: () => AppUtil.showInputDialog(
                            context: context,
                            editingController: _editingController,
                            focusNode: _focusNode,
                            text: '${addModel.phone}',
                            hintText: '${addModel.phone}',
                            callBack: (text) {
                              addModel.setPhone(text);
                            })
                    )
                  )
              ),
              //补货金额
              SliverToBoxAdapter(
                child: Visibility(
                  visible: widget.middleman ? Store.readPostType() == 'zy' && addModel.storeModel.id.isNotEmpty :
                  addModel.storeModel.id.isNotEmpty,
                  child: PostAddInputCell(
                      title: '补货金额',
                      value: '$orderAmount',
                      hintText: '$orderAmount',
                      endWidget: TextButton(
                        child: Text('明细', style: TextStyle(color: AppColors.FFC08A3F)),
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AmountDetails(userId: addModel.storeModel.id)));
                        }
                      ),
                      onTap: null
                  )
                )
              ),
              //是否自提
              SliverToBoxAdapter(
                  child: Visibility(
                      visible: !widget.middleman,
                      child: PostAddInputCell(
                          title: '是否自提',
                          value: '${addModel.selfMentionName}',
                          hintText: '是否自提',
                          endWidget: Icon(Icons.chevron_right),
                          onTap: () async {
                            String select = await showPicker(['自提', '物流'], context);
                            switch(select){
                              case "自提":
                                addModel.setSelfMention(1);
                                break;
                              case "物流":
                                addModel.setSelfMention(2);
                                break;
                            }
                            addModel.setSelfMentionName(select);
                          }
                      )
                  )
              ),
              //发票类型
              SliverToBoxAdapter(
                  child: Visibility(
                      visible: !widget.middleman,
                      child: PostAddInputCell(
                          title: '发票类型',
                          value: '${addModel.invoiceTypeName}',
                          hintText: '请选择发票类型',
                          endWidget: Icon(Icons.chevron_right),
                          onTap: () async {
                            String select = await showPicker(['普票', '专票'], context);
                            switch(select){
                              case "普票":
                                addModel.setInvoiceType(1);
                                break;
                              case "专票":
                                addModel.setInvoiceType(2);
                                break;
                            }
                            addModel.setInvoiceTypeName(select);
                          }
                      )
                  )
              ),
              //是否渠道客户
              SliverToBoxAdapter(
                  child: Visibility(
                      visible: !widget.middleman && addModel.invoiceType == 2,
                      child: PostAddInputCell(
                          title: '是否渠道客户',
                          value: '${addModel.orderTypeIsName}',
                          hintText: '是否渠道客户',
                          endWidget: Icon(Icons.chevron_right),
                          onTap: () async {
                            String select = await showPicker(['普通订单', '渠道客户订单'], context);
                            switch(select){
                              case "普通订单":
                                addModel.setOrderTypeIs(1);
                                break;
                              case "渠道客户订单":
                                addModel.setOrderTypeIs(2);
                                break;
                            }
                            addModel.setOrderTypeIsName(select);
                          }
                      )
                  )
              ),
              //结算客户
              SliverToBoxAdapter(
                  child: Visibility(
                      visible: !widget.middleman && addModel.orderTypeIs == 2,
                      child: PostAddInputCell(
                          title: '结算客户',
                          value: '${addModel.settlementCusName}',
                          hintText: '请选择结算客户',
                          endWidget: Icon(Icons.chevron_right),
                          onTap: () async {
                            Map select = await showSelectSearchList(context, Api.settlementCus, '请选择结算客户', 'corporate');
                            addModel.setSettlementCus(select['userId']);
                            addModel.setSettlementCusName(select['corporate']);
                          }
                      )
                  )
              ),
              //仓库
              SliverToBoxAdapter(
                  child: Visibility(
                      visible: !widget.middleman,
                      child: PostAddInputCell(
                          title: '仓库',
                          value: '${addModel.warehouseName}',
                          hintText: '请选择仓库',
                          endWidget: Icon(Icons.chevron_right),
                          onTap: () async {
                            Map select = await showSelectSearchList(context, Api.warehouse, '请选择仓库', 'title');
                            addModel.setWarehouseCode(select['code']);
                            addModel.setWarehouseName(select['title']);
                          }
                      )
                  )
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
                          if (addModel.storeModel.id.isEmpty) {
                            AppUtil.showToastCenter('请先选择客户');
                            return;
                          }
                          List<GoodsModel> _selGoodsList = await Navigator.push(
                              context, MaterialPageRoute(builder: (_) {
                            return SelectGoodsPage(
                                selGoods: addModel.goodsList,
                                customerId: addModel.storeModel.id,
                                forStock: false);
                          }));
                          if (_selGoodsList != null) {
                            addModel.setArrays(
                                addModel.goodsList, _selGoodsList);
                          }
                        },
                        icon:
                            const Icon(Icons.add_circle, color: AppColors.FFC68D3E)),
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                GoodsModel model = addModel.goodsList[index];
                return AddPageGoodsCell(
                  model: model,
                  middleman: widget.middleman,
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
                  countPrice: widget.middleman
                      ? addModel.goodsMiddlemanPrice
                      : addModel.goodsPrice,
                ),
              ),
              //补货商品(去掉了)
              SliverToBoxAdapter(
                child: Visibility(
                    // visible: widget.middleman ? Store.readPostType() == 'zy' : true,
                  visible: false,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                      color: Colors.white,
                      child: ListTile(
                        title: const Text('补货商品',
                            style: TextStyle(
                                color: AppColors.FF2F4058, fontSize: 14.0)),
                        trailing: IconButton(
                            onPressed: () async {
                              if (addModel.storeModel.id.isEmpty) {
                                AppUtil.showToastCenter('请先选择客户');
                                return;
                              }
                              List<GoodsModel> _selGoodsList =
                              await Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                    return SelectGoodsPage(
                                        selGoods: addModel.rewardGoodsList,
                                        customerId: addModel.storeModel.id,
                                        forStock: false);
                                  }));
                              if (_selGoodsList != null) {
                                addModel.setArrays(
                                    addModel.rewardGoodsList, _selGoodsList);
                              }
                            },
                            icon: Icon(Icons.add_circle,
                                color: AppColors.FFC68D3E))
                      )
                    )
                  )
                )
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                GoodsModel model = addModel.rewardGoodsList[index];
                return AddPageGoodsCell(
                  model: model,
                  middleman: widget.middleman,
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
                    onPressed: () => _submitAction(context, addModel),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitAction(BuildContext context, DeclarationFormModel model) async {
    if (model.storeModel.id.isEmpty) {
      AppUtil.showToastCenter('请选择客户');
      return;
    }
    if (!widget.middleman && model.selfMention == 0) {
      AppUtil.showToastCenter('是否自提不能为空');
      return;
    }
    if (!widget.middleman && model.invoiceType == 0) {
      AppUtil.showToastCenter('发票类型不能为空');
      return;
    }
    if (!widget.middleman && model.invoiceType == 2 && model.orderTypeIs == 0) {
      AppUtil.showToastCenter('是否渠道客户不能为空');
      return;
    }
    if (!widget.middleman && model.invoiceType == 2 && model.orderTypeIs == 2 && model.settlementCus.isEmpty) {
      AppUtil.showToastCenter('结算客户不能为空');
      return;
    }
    if (!widget.middleman && model.warehouseCode.isEmpty) {
      AppUtil.showToastCenter('仓库不能为空');
      return;
    }
    if (model.goodsList.isEmpty) {
      AppUtil.showToastCenter('请选择商品');
      return;
    }
    if (model.rewardGoodsList.isNotEmpty) {
      if (model.goodsRewardPrice > orderAmount) {
        AppUtil.showToastCenter('抱歉，总价不能超过补货金额');
        return;
      }
    }
    if (model.address.isEmpty) {
      AppUtil.showToastCenter('请填写收货地址');
      return;
    }
    Map param = {
      'customerId': model.storeModel.id,
      'cusPhone': model.phone,
      'address': model.address,
      'remark': model.remark,
      'selfMention': model.selfMention,
      'totalPrice':
          widget.middleman ? model.goodsMiddlemanPrice : model.goodsPrice,
      'totalWeight': model.goodsWeight,
      'totalCount': model.goodsCount,
      'goodsList': model.goodsListToString,
      'gifts': model.rewardGoodsListToString,
      'middleman': widget.middleman ? 2 : 1,
      'id':model.id,
      'invoiceType': model.invoiceType,
      'orderType': model.orderTypeIs,
      'settlementCus': model.settlementCus,
      'warehouseCode': model.warehouseCode
    };
    print('param = ${jsonEncode(param)}');
    requestPost(Api.orderAdd, json: jsonEncode(param)).then((value) {
      var data = jsonDecode(value.toString());
      // print('data = $data');
      if (data['code'] == 200) Navigator.pop(context, true);
    });
  }

  ///获取账余
  Future<void> _orderAmount(String userId, DeclarationFormModel model) async{
    Map<String, dynamic> map = {'userId': userId, 'orderId': widget.editing ? model.id : ''};
    LogUtil.d('请求结果---map----$map');
    requestGet(Api.orderAmount, param: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---orderAmount----$data');
      orderAmount = double.parse(data['data']) ?? 0;
      if (mounted) setState(() {});
    });
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
        keyboardType: TextInputType.text,
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
