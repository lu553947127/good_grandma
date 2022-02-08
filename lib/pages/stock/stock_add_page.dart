import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/employee_model.dart';
import 'package:good_grandma/models/goods_model.dart';
import 'package:good_grandma/models/stock_add_model.dart';
import 'package:good_grandma/pages/stock/select_customer_page.dart';
import 'package:good_grandma/pages/stock/select_goods_page.dart';
import 'package:good_grandma/widgets/stock_add_goods_cell.dart';
import 'package:good_grandma/widgets/submit_btn.dart';
import 'package:provider/provider.dart';

///新增库存
class StockAddPage extends StatefulWidget {
  const StockAddPage({Key key}) : super(key: key);

  @override
  _StockAddPageState createState() => _StockAddPageState();
}

class _StockAddPageState extends State<StockAddPage> {
  final TextEditingController _editingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final StockAddModel _model = Provider.of<StockAddModel>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('新增库存')),
      body: Scrollbar(
        child: CustomScrollView(
          slivers: [
            //客户名称
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                child: ListTile(
                  onTap: () => _pickCustomerAction(context, _model),
                  title: Row(
                    children: [
                      const Text('客户名称',
                          style: TextStyle(
                              color: AppColors.FF2F4058, fontSize: 14.0)),
                      Expanded(
                          child: Text(
                              _model.customer != null &&
                                      _model.customer.name.isNotEmpty
                                  ? _model.customer.name
                                  : '请选择客户',
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                  color: AppColors.FFC1C8D7, fontSize: 14.0))),
                    ],
                  ),
                  trailing: Icon(Icons.chevron_right),
                ),
              ),
            ),
            //商品名称
            SliverToBoxAdapter(
              child: Visibility(
                visible: _model.stockList.length > 0,
                child: ListTile(
                  title: const Text('商品名称',
                      style:
                      TextStyle(color: AppColors.FF959EB1, fontSize: 12.0)),
                ),
              ),
            ),
            //list
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              StockModel stockModel = _model.stockList[index];
              String goodsNames = stockModel.goodsModel.name ?? '';
              return StockAddGoodsCell(
                key: UniqueKey(),
                goodsNames: goodsNames,
                stockModel: stockModel,
                editingController: _editingController,
                focusNode: _focusNode,
                numberChangeAction: (SpecModel specModel) {
                  _model.editStockListWith(index, stockModel);
                },
                pickTimeAction: () async {
                  String time = await showPickerDate(context);
                  if (time != null) {
                    stockModel.time = time;
                    _model.editStockListWith(index, stockModel);
                  }
                },
                deleteAction: () => _model.deleteStockListWith(index),
              );
            }, childCount: _model.stockList.length)),
            SliverToBoxAdapter(
              child: ListTile(
                title: const Text('添加商品',
                    style:
                    TextStyle(color: AppColors.FF959EB1, fontSize: 12.0)),
                trailing: IconButton(
                    onPressed: () => _pickGoodsAction(context, _model),
                    icon: Icon(Icons.add_circle, color: AppColors.FFC68D3E)),
              ),
            ),
            //submit button
            SliverToBoxAdapter(
                child: SubmitBtn(
                    title: '提  交',
                    onPressed: () => _submitAction(context, _model)))
          ],
        ),
      ),
    );
  }

  ///提交
  _submitAction(BuildContext context, StockAddModel _model) async {
    if (_model.customer.id == null || _model.customer.id.isEmpty) {
      AppUtil.showToastCenter('请选择客户');
      return;
    }
    if (_model.stockList.isEmpty) {
      AppUtil.showToastCenter('请选择商品');
      return;
    }
    bool needPickTime = false;
    bool needNumber = false;
    _model.stockList.forEach((stockModel) {
      if (stockModel.time == null || stockModel.time.isEmpty) {
        needPickTime = true;
        return;
      }
      stockModel.goodsModel.specs.forEach((specModel) {
        if (specModel.number == null || specModel.number.isEmpty) {
          needNumber = true;
          return;
        }
      });
    });
    if (needPickTime) {
      AppUtil.showToastCenter('请选择生产日期');
      return;
    }
    if (needNumber) {
      AppUtil.showToastCenter('请填写数量');
      return;
    }
    Map param = {
      'customerId': _model.customer.id,
      'checkList': _model.stockList
          .map((stockModel) => {
                'makeTime': stockModel.time,
                'goodsName': stockModel.goodsModel.name,
                'spec20': _getSpecModelWith(stockModel, '20') != null
                    ? _getSpecModelWith(stockModel, '20').number
                    : '0',
                'spec40': _getSpecModelWith(stockModel, '40') != null
                    ? _getSpecModelWith(stockModel, '40').number
                    : '0',
              })
          .toList(),
    };
    // print('param = ${jsonEncode(param)}');
    requestPost(Api.customerStockAdd, json: jsonEncode(param)).then((value) {
      var data = jsonDecode(value.toString());
      // print('data = $data');
      if (data['code'] == 200) Navigator.pop(context, true);
    });
  }

  SpecModel _getSpecModelWith(StockModel stockModel, String key) {
    List<SpecModel> list = stockModel.goodsModel.specs
        .where((specModel) => specModel.spec.contains(key))
        .toList();
    return list.isNotEmpty ? list.first : null;
  }

  ///选择商品
  _pickGoodsAction(BuildContext context, StockAddModel _model) async {
    if (_model.customer == null || _model.customer.id.isEmpty) {
      AppUtil.showToastCenter('请先选择客户');
      return;
    }
    List<GoodsModel> _selGoodsList =
        await Navigator.push(context, MaterialPageRoute(builder: (_) {
      return SelectGoodsPage(
        selGoods: [],
        customerId: _model.customer.id,
        selectSingle: true,
      );
    }));
    if (_selGoodsList != null && _selGoodsList.isNotEmpty) {
      StockModel stockModel = StockModel(key: UniqueKey());
      stockModel.goodsModel = _selGoodsList.first;
      _model.addToStockList(stockModel);
    }
  }

  ///选择客户
  _pickCustomerAction(BuildContext context, StockAddModel _model) async {
    Map select = await showSelectSearchList(context, Api.customerList, '请选择客户', 'corporateName');
    EmployeeModel model = EmployeeModel(name: select['corporateName'] ?? '', id: select['id'] ?? '');
    if (model != null) {
      _model.setStockList([]);
      _model.setCustomer(model);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _editingController?.dispose();
    _focusNode?.dispose();
  }
}
