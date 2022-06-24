import 'dart:async';
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
import 'package:good_grandma/pages/mine/invoice.dart';
import 'package:good_grandma/pages/mine/receiving_address.dart';
import 'package:good_grandma/pages/order/amount_details.dart';
import 'package:good_grandma/pages/stock/select_customer_page.dart';
import 'package:good_grandma/pages/stock/select_goods_page.dart';
import 'package:good_grandma/pages/work/work_text.dart';
import 'package:good_grandma/widgets/order_add_page_goods_cell.dart';
import 'package:good_grandma/widgets/order_goods_count_view.dart';
import 'package:good_grandma/widgets/post_add_input_cell.dart';
import 'package:good_grandma/widgets/submit_btn.dart';
import 'package:provider/provider.dart';

///新增订单
class AddOrderPage extends StatefulWidget {
  const AddOrderPage({Key key, this.editing = false, this.orderType})
      : super(key: key);

  ///是否是编辑订单
  final bool editing;

  ///订单类型 1 2级订单 3直营订单
  final int orderType;

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

    String userName = Store.readNickName();

    if (_isEdit == false && widget.editing){
      _isEdit = true;
      _orderAmount(addModel.storeModel.id, addModel);
    }

    if (_isEdit == false && widget.orderType != 2) {
      _isEdit = true;
      _dictionary(addModel);
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
                  child: DefaultTextStyle(style: const TextStyle(color: AppColors.FF959EB1, fontSize: 14.0),
                    child: Row(
                      children: [
                        const Text('下单人员'),
                        Spacer(),
                        Text(userName ?? '')
                      ]
                    )
                  )
                )
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
                        MaterialPageRoute(builder: (_) => SelectStorePage(forOrder: true, orderType: widget.orderType)));
                    if (result != null) {
                      addModel.setStoreModel(result);
                      //选择完客户更新销售折扣金额
                      if (widget.orderType == 2 && Store.readPostType() == 'zy'){
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
                        hintText: '请输入客户电话',
                        endWidget: Icon(Icons.chevron_right),
                        onTap: () => AppUtil.showInputDialog(
                            context: context,
                            editingController: _editingController,
                            focusNode: _focusNode,
                            keyboardType: TextInputType.phone,
                            text: '${addModel.phone}',
                            hintText: '${addModel.phone}',
                            callBack: (text) {
                              addModel.setPhone(text);
                            })
                    )
                  )
              ),
              //销售折扣
              SliverToBoxAdapter(
                child: Visibility(
                  visible: widget.orderType == 2 ? Store.readPostType() == 'zy' && addModel.storeModel.id.isNotEmpty :
                  addModel.storeModel.id.isNotEmpty,
                  child: PostAddInputCell(
                      title: '销售折扣',
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
              //收货地址
              SliverToBoxAdapter(
                child: Container(
                    color: Colors.white,
                    child: ListTile(
                      onTap: () async {
                        if (addModel.storeModel.id.isEmpty) {
                          AppUtil.showToastCenter('请先选择客户');
                          return;
                        }

                        Map addressModel = await Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ReceivingAddress(userId: addModel.storeModel.id, orderType: widget.orderType)));
                        addModel.setAddress(addressModel['address']);
                      },
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text('收货地址',
                            style: const TextStyle(
                                color: AppColors.FF2F4058, fontSize: 14.0)),
                      ),
                      subtitle: addModel.address.isNotEmpty
                          ? Text(addModel.address)
                          : Text('请选择收获地址',
                          style: const TextStyle(
                              color: AppColors.FFC1C8D7, fontSize: 14.0)),
                    )
                )
              ),
              SliverToBoxAdapter(child: SizedBox(height: 10.0)),
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
                                      customerId: addModel.storeModel.id);
                                }));
                                if (_selGoodsList != null) {
                                  addModel.setArrays(
                                      addModel.goodsList, _selGoodsList);
                                  //选择完商品更新装车率
                                  addModel.setCarRate("${formatNum((((addModel.goodsStandardCount + addModel.standardCount) / double.parse(addModel.carCount)) * 100), 2)}%");
                                }
                              },
                              icon:
                              const Icon(Icons.add_circle, color: AppColors.FFC68D3E))
                      )
                  )
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    GoodsModel model = addModel.goodsList[index];
                    return AddPageGoodsCell(
                      model: model,
                      middleman: widget.orderType == 2,
                      editingController: _editingController,
                      focusNode: _focusNode,
                      deleteAction: () {
                        addModel.deleteArrayWith(addModel.goodsList, index);
                        addModel.setCarRate("${formatNum((((addModel.goodsStandardCount + addModel.standardCount) / double.parse(addModel.carCount)) * 100), 2)}%");
                      },
                      numberChangeAction: () {
                        addModel.editArrayWith(addModel.goodsList, index, model);
                        addModel.setCarRate("${formatNum((((addModel.goodsStandardCount + addModel.standardCount) / double.parse(addModel.carCount)) * 100), 2)}%");
                      },
                    );
                  }, childCount: addModel.goodsList.length)),
              //商品总数
              widget.orderType == 2 ? SliverToBoxAdapter(
                  child: OrderGoodsCountView(
                      count: addModel.goodsCount,
                      countWeight: countWeight,
                      countPrice: addModel.goodsPrice
                  )
              ) :
              SliverToBoxAdapter(
                  child: OrderGoodsCountView(
                      count: addModel.goodsCount,
                      countWeight: countWeight,
                      countPrice: addModel.goodsPrice,
                      netAmount: (addModel.goodsPrice - addModel.discount),
                      discount: addModel.discount,
                      standardCount: addModel.goodsStandardCount
                  )
              ),
              SliverToBoxAdapter(child: SizedBox(height: 10.0)),
              //发货仓库
              SliverToBoxAdapter(
                  child: Visibility(
                      visible: !(widget.orderType == 2),
                      child: PostAddInputCell(
                          title: '发货仓库',
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
              //配送方式
              SliverToBoxAdapter(
                  child: Visibility(
                      visible: !(widget.orderType == 2),
                      child: PostAddInputCell(
                          title: '配送方式',
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
              //是否拼车
              SliverToBoxAdapter(
                  child: Visibility(
                      visible: !(widget.orderType == 2)  && addModel.selfMention == 2,
                      child: PostAddInputCell(
                          title: '是否拼车',
                          value: addModel.carpooling,
                          hintText: addModel.carpooling,
                          endWidget: Icon(Icons.chevron_right),
                          onTap: () async {
                            String select = await showPicker(['是', '否'], context);
                            addModel.setCarpooling(select.isEmpty ? '否' : select);
                          }
                      )
                  )
              ),
              //拼车码
              SliverToBoxAdapter(
                  child: Visibility(
                      visible: !(widget.orderType == 2)  && addModel.selfMention == 2 && addModel.carpooling == '是',
                      child: PostAddInputCell(
                          title: '拼车码',
                          value: '${addModel.carpoolCode}',
                          hintText: addModel.carpoolCode.isEmpty ? '请输入拼车码' : '${addModel.carpoolCode}',
                          endWidget: TextButton(
                              child: Text('生成', style: TextStyle(color: AppColors.FFC08A3F)),
                              onPressed: (){
                                _createCarpoolCode(addModel);
                              }
                          ),
                          onTap: () => AppUtil.showInputDialog(
                              context: context,
                              editingController: _editingController,
                              focusNode: _focusNode,
                              keyboardType: TextInputType.phone,
                              text: '${addModel.carpoolCode}',
                              hintText: '${addModel.carpoolCode}',
                              callBack: (text) {
                                addModel.setCarpoolCode(text);
                                _carpoolOrder(text, addModel);
                              })
                      )
                  )
              ),
              //拼车客户
              SliverToBoxAdapter(
                  child: Visibility(
                      visible: !(widget.orderType == 2)  && addModel.selfMention == 2 && addModel.carpooling == '是' && addModel.carpoolCustomers.isNotEmpty,
                      child: PostAddInputCell(
                          title: '拼车客户',
                          value: '${addModel.carpoolCustomers}',
                          hintText: '${addModel.carpoolCustomers}',
                          endWidget: null,
                          onTap: null
                      )
                  )
              ),
              //货车车型
              SliverToBoxAdapter(
                  child: Visibility(
                      visible: !(widget.orderType == 2) && addModel.selfMention == 2,
                      child: PostAddInputCell(
                          title: '货车车型',
                          value: '${addModel.carName}',
                          hintText: '请选择货车车型',
                          endWidget: Icon(Icons.chevron_right),
                          onTap: () async {
                            if (addModel.goodsList.isEmpty) {
                              AppUtil.showToastCenter('请先选择商品');
                              return;
                            }
                            Map select = await showSelectSearchList(context, Api.selectCall, '请选择货车车型', 'title');
                            addModel.setCarId(select['id']);
                            addModel.setCarName(select['title']);
                            addModel.setCarCount(select['count']);
                            //计算装车率
                            addModel.setCarRate("${formatNum((((addModel.goodsStandardCount + addModel.standardCount) / double.parse(select['count'])) * 100), 2)}%");
                          }
                      )
                  )
              ),
              //装车率
              SliverToBoxAdapter(
                  child: Visibility(
                      visible: !(widget.orderType == 2) && addModel.selfMention == 2,
                      child: PostAddInputCell(
                          title: '装车率',
                          value: '${addModel.carRate}',
                          hintText: '${addModel.carRate}',
                          endWidget: null,
                          onTap: null
                      )
                  )
              ),
              SliverToBoxAdapter(child: SizedBox(height: 10.0)),
              //订单类型
              SliverToBoxAdapter(
                  child: Visibility(
                      visible: !(widget.orderType == 2),
                      child: PostAddInputCell(
                          title: '订单类型',
                          value: '${addModel.orderTypeIsName}',
                          hintText: '订单类型',
                          endWidget: Icon(Icons.chevron_right),
                          onTap: () async {
                            String select = await showPicker(['普通订单', '渠道客户订单'], context);
                            switch(select){
                              case "普通订单":
                                addModel.setOrderTypeIs(1);
                                addModel.setIsInvoice("否");
                                addModel.setInvoiceType(0);
                                addModel.setInvoiceTypeName('');
                                addModel.setSettlementCus('');
                                addModel.setSettlementCusName('');
                                addModel.setInvoiceId('');
                                addModel.setInvoiceName('');
                                break;
                              case "渠道客户订单":
                                addModel.setOrderTypeIs(2);
                                addModel.setIsInvoice("是");
                                addModel.setInvoiceType(2);
                                addModel.setInvoiceTypeName('专票');
                                break;
                            }
                            addModel.setOrderTypeIsName(select);
                          }
                      )
                  )
              ),
              //是否需要发票
              SliverToBoxAdapter(
                  child: Visibility(
                      visible: !(widget.orderType == 2),
                      child: PostAddInputCell(
                          title: '是否需要发票',
                          value: addModel.isInvoice,
                          hintText: addModel.isInvoice,
                          endWidget: Icon(Icons.chevron_right),
                          onTap: () async {
                            if (addModel.orderTypeIs == 2){
                              showToast('渠道客户订单不能修改');
                              return;
                            }
                            String select = await showPicker(['是', '否'], context);
                            addModel.setIsInvoice(select.isEmpty ? '否' : select);
                          }
                      )
                  )
              ),
              //发票类型
              SliverToBoxAdapter(
                  child: Visibility(
                      visible: !(widget.orderType == 2) && addModel.isInvoice == '是',
                      child: PostAddInputCell(
                          title: '发票类型',
                          value: '${addModel.invoiceTypeName}',
                          hintText: '请选择发票类型',
                          endWidget: Icon(Icons.chevron_right),
                          onTap: () async {
                            if (addModel.orderTypeIs == 2){
                              showToast('渠道客户订单不能修改');
                              return;
                            }
                            String select = await showPicker(['普票', '专票', '收据'], context);
                            switch(select){
                              case "普票":
                                addModel.setInvoiceType(1);
                                addModel.setInvoiceTypeName(select);
                                break;
                              case "专票":
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,//屏蔽点击对话框外部自动关闭
                                    builder: (context) {
                                      return WillPopScope(
                                        onWillPop: () async {
                                          return Future.value(false);//屏蔽返回键关闭弹窗
                                        },
                                        child: AlertDialog(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                          title: Text('增值税专用发票使用规定阅读须知'),
                                          content: SingleChildScrollView(
                                            child: Text(WorkText.text)
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context, false);
                                                  addModel.setInvoiceType(0);
                                                  addModel.setInvoiceTypeName('');
                                                },
                                                child: const Text('取消', style: TextStyle(color: Color(0xFF999999)))),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context, true);
                                                  addModel.setInvoiceType(2);
                                                  addModel.setInvoiceTypeName(select);
                                                },
                                                child: Text('确定', style: TextStyle(color: Color(0xFFC08A3F)))),
                                          ]
                                        )
                                      );
                                    });
                                break;
                              case "收据":
                                addModel.setInvoiceType(3);
                                addModel.setInvoiceTypeName(select);
                                break;
                            }
                          }
                      )
                  )
              ),
              //结算客户
              SliverToBoxAdapter(
                  child: Visibility(
                      visible: !(widget.orderType == 2) && addModel.orderTypeIs == 2,
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
              //开票信息
              SliverToBoxAdapter(
                  child: Visibility(
                      visible: !(widget.orderType == 2) && (addModel.invoiceType == 1 || addModel.invoiceType == 2),
                    child: Container(
                        color: Colors.white,
                        child: ListTile(
                          onTap: () async {
                            if (addModel.storeModel.id.isEmpty) {
                              AppUtil.showToastCenter('请先选择客户');
                              return;
                            }

                            Map select = await Navigator.push(context,
                                MaterialPageRoute(builder: (context) => InvoicePage(userId: addModel.storeModel.id, orderType: widget.orderType)));
                            addModel.setInvoiceId(select['id']);
                            addModel.setInvoiceName('单位名称：${select['title']}\n'
                                '纳税人识别号：${select['taxNo']}\n'
                                '地址：${select['address']}\n'
                                '电话：${select['phone']}\n'
                                '开户银行：${select['bank']}\n'
                                '账号：${select['card']}');
                          },
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text('开票信息',
                                style: const TextStyle(
                                    color: AppColors.FF2F4058, fontSize: 14.0)),
                          ),
                          subtitle: addModel.invoiceName.isNotEmpty
                              ? Text(addModel.invoiceName)
                              : Text('请选择开票信息',
                              style: const TextStyle(
                                  color: AppColors.FFC1C8D7, fontSize: 14.0)),
                        )
                    )
                  )
              ),
              SliverToBoxAdapter(child: SizedBox(height: 10.0)),
              //折扣详情列表
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    DictionaryModel model = addModel.dictionaryModelList[index];
                    return PostAddInputCell(
                        title: model.dictKey,
                        value: model.money,
                        hintText: '请输入',
                        endWidget: null,
                        // endWidget: TextButton(
                        //     child: Text('删除', style: TextStyle(color: AppColors.FFDD0000)),
                        //     onPressed: (){
                        //       addModel.deleteDictionaryArrayWith(addModel.dictionaryModelList, index);
                        //     }
                        // ),
                        onTap: () => AppUtil.showInputDialog(
                            context: context,
                            editingController: _editingController,
                            focusNode: _focusNode,
                            keyboardType: TextInputType.number,
                            text: model.money,
                            hintText: model.money,
                            callBack: (text) {
                              double num = 0;
                              if (widget.editing){
                                num = double.parse(text) + addModel.discount - double.parse(addModel.dictionaryModelList[index].money);
                              }else {
                                num = double.parse(text) + addModel.discount;
                              }

                              if (addModel.goodsPrice < num){
                                showToast('折扣合计不能超过订单总额');
                                return;
                              }
                              model.money = text;
                              addModel.editDictionaryArrayWith(addModel.dictionaryModelList, index, model);
                            })
                    );
                  }, childCount: addModel.dictionaryModelList.length)),
              SliverToBoxAdapter(child: SizedBox(height: 10.0)),
              //备注
              SliverToBoxAdapter(
                  child: Container(
                      color: Colors.white,
                      child: ListTile(
                        onTap: () async {
                          AppUtil.showInputDialog(
                              context: context,
                              editingController: _editingController,
                              focusNode: _focusNode,
                              text: addModel.remark,
                              hintText: '请输入备注',
                              keyboardType: TextInputType.text,
                              callBack: (text) {
                                addModel.setRemark(text);
                              });
                        },
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text('备注',
                              style: const TextStyle(
                                  color: AppColors.FF2F4058, fontSize: 14.0)),
                        ),
                        subtitle: addModel.remark.isNotEmpty
                            ? Text(addModel.remark)
                            : Text('请输入备注',
                            style: const TextStyle(
                                color: AppColors.FFC1C8D7, fontSize: 14.0)),
                      )
                  )
              ),
              SliverSafeArea(
                sliver: SliverToBoxAdapter(
                  child: SubmitBtn(title: '提  交', onPressed: () => _submitAction(context, addModel))
                )
              )
            ]
          )
        )
      )
    );
  }

  ///新增订单
  void _submitAction(BuildContext context, DeclarationFormModel model) async {
    if (model.storeModel.id.isEmpty) {
      AppUtil.showToastCenter('请选择客户');
      return;
    }
    if (model.phone.isEmpty) {
      AppUtil.showToastCenter('客户电话不能为空');
      return;
    }
    if (model.address.isEmpty) {
      AppUtil.showToastCenter('请填写收货地址');
      return;
    }
    if (model.goodsList.isEmpty) {
      AppUtil.showToastCenter('请选择商品');
      return;
    }
    if (!(widget.orderType == 2) && model.warehouseCode.isEmpty) {
      AppUtil.showToastCenter('仓库不能为空');
      return;
    }
    if (!(widget.orderType == 2) && model.selfMention == 0) {
      AppUtil.showToastCenter('配送方式不能为空');
      return;
    }
    if (!(widget.orderType == 2) && model.selfMention == 2 && model.carpooling == '是' && model.carpoolCode.isEmpty) {
      AppUtil.showToastCenter('拼车码不能为空');
      return;
    }
    if (!(widget.orderType == 2) && model.selfMention == 2 && model.carId.isEmpty) {
      AppUtil.showToastCenter('货车车型不能为空');
      return;
    }
    if (!(widget.orderType == 2) && model.orderTypeIs == 0) {
      AppUtil.showToastCenter('订单类型不能为空');
      return;
    }
    if (!(widget.orderType == 2) && model.isInvoice == '是' && model.invoiceType == 0) {
      AppUtil.showToastCenter('发票类型不能为空');
      return;
    }
    if (!(widget.orderType == 2) && model.orderTypeIs == 2 && model.settlementCus.isEmpty) {
      AppUtil.showToastCenter('结算客户不能为空');
      return;
    }
    if (!(widget.orderType == 2) && (model.invoiceType == 1 || model.invoiceType == 2) && model.invoiceId.isEmpty) {
      AppUtil.showToastCenter('开票信息不能为空');
      return;
    }

    for (DictionaryModel model in model.dictionaryModelList) {
      if (model.money.isEmpty){
        AppUtil.showToastCenter('折扣不能为空');
        return;
      }
    }

    Map param = {
      'id':model.id,//用户编辑传订单id
      'middleman': widget.orderType,//订单级别
      'cusId': model.storeModel.id,//客户id
      'cusPhone': model.phone,//联系电话
      'address': model.address,//收货地址
      'orderDetailedList': model.goodsListToString,//选择商品列表
      'warehouseCode': model.warehouseCode,//仓库
      'selfMention': model.selfMention,//配送方式
      'carId': model.carId,//货车车型
      'carpoolCode': model.carpoolCode,//拼车码
      'orderType': model.orderTypeIs,//订单类型
      'invoiceType': model.invoiceType,//发票类型
      'settlementCus': model.settlementCus,//结算客户
      'invoiceId': model.invoiceId,//开票信息
      'giftTotalList': model.dictionaryToList,//销售折扣详情列表
      'remark': model.remark//备注
    };

    if (!(widget.orderType == 2) && model.selfMention == 2 && model.carId.isNotEmpty) {
      if (model.carCount.isEmpty){
        _orderAdd(param);
        return;
      }
      double number = ((model.goodsStandardCount / double.parse(model.carCount)) * 100);
      if (number < 90){
        showDialog(
            context: context,
            builder: (context1) {
              return AlertDialog(
                title: const Text('警告'),
                content: const Text('此订单装车率不足90%，提交后此订单有可能被驳回，确定提交？'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text('取消', style: TextStyle(color: Color(0xFF999999)))),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                        _orderAdd(param);
                      },
                      child: const Text('确定', style: TextStyle(color: Color(0xFFC08A3F)))),
                ],
              );
            });
      }else {
        _orderAdd(param);
      }
    }else {
      _orderAdd(param);
    }
  }

  ///订单提交
  void _orderAdd(Map param) {
    LogUtil.d('请求结果---param----$param');
    requestPost(Api.orderAdd, json: jsonEncode(param)).then((value) {
      var data = jsonDecode(value.toString());
      LogUtil.d('请求结果---orderAdd----$data');
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

  ///获取拼车码
  Future<void> _createCarpoolCode(DeclarationFormModel model) async{
    requestPost(Api.createCarpoolCode).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---createCarpoolCode----$data');
      model.setCarpoolCode(data['data']);
      // _carpoolOrder(data['data'], model);
      //20220618-451066
    });
  }

  ///获取拼车客户
  Future<void> _carpoolOrder(String carpoolCode, DeclarationFormModel model) async{
    Map<String, dynamic> map = {'id': model.id, 'carpoolCode': carpoolCode};
    requestPost(Api.carpoolOrder, json: jsonEncode(map)).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---carpoolOrder----$data');
      if (data['data']['msg'] == 'success'){
        if (data['data']['cus'] != null){
          model.setCarpoolCustomers(data['data']['cus']);
          model.setStandardCount(double.parse(data['data']['standardCount'].toString()));
        }else {
          model.setCarpoolCustomers('');
          model.setStandardCount(0);
        }
        model.setCarRate("${formatNum((((model.goodsStandardCount + model.standardCount) / double.parse(model.carCount)) * 100), 2)}%");
      }else {
        model.setCarpoolCode('');
        model.setCarpoolCustomers('');
        model.setStandardCount(0);
        showToast('${data['data']['msg']}');
      }
    });
  }

  ///折扣详情列表
  Future<void> _dictionary(DeclarationFormModel addModel) async{
    Map<String, dynamic> map = {'code': 'amount_type'};
    requestGet(Api.dictionary, param: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---dictionary----$data');
      List<dynamic> list = data['data'];
      list.removeWhere((map) => map['remark'] == '');

      List<DictionaryModel> _selList = [];
      //默认添加销售折扣为第一条数据
      _selList.add(DictionaryModel(remark: 'giftTotal', dictKey: '销售折扣'));

      list.forEach((element) {
        DictionaryModel model = DictionaryModel(
          id: element['id'],
          remark: element['remark'],
          dictKey: element['dictKey']
        );
        _selList.add(model);
      });

      addModel.setDictArrays(
          addModel.dictionaryModelList, _selList);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _editingController.dispose();
  }
}
