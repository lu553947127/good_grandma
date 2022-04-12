import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/employee_model.dart';
import 'package:good_grandma/models/goods_model.dart';
import 'package:good_grandma/models/stock_add_model.dart';
import 'package:good_grandma/pages/stock/select_customer_page.dart';
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
                stockAddModel: _model,
                stockModel: stockModel,
                editingController: _editingController,
                focusNode: _focusNode,
                index: index
              );
            }, childCount: _model.stockList.length)),
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
      AppUtil.showToastCenter('商品不能为空');
      return;
    }
    Map param = {
      'customerId': _model.customer.id,
      'checkList': _model.stockList
          .map((stockModel) => {
                'goodsId': stockModel.goodsModel.id,
                'goodsName': stockModel.goodsModel.name,
                'oneToThree': stockModel.oneToThree,
                'fourToSix': stockModel.fourToSix
              })
          .toList(),
    };
    print('param = ${jsonEncode(param)}');
    requestPost(Api.customerStockAdd, json: jsonEncode(param)).then((value) {
      var data = jsonDecode(value.toString());
      print('data = $data');
      if (data['code'] == 200) Navigator.pop(context, true);
    });
  }

  ///选择商品
  _pickGoodsAction(String customerId, StockAddModel _model) async {
    Map<String, dynamic> map = {
      'current': '1',
      'size': '-1',
      'customerId': customerId
    };
    final val = await requestGet(Api.goodsList, param: map);
    LogUtil.d('${Api.goodsList} value = $val');
    var data = jsonDecode(val.toString());
    final List<dynamic> list = data['data'];
    if (list != null && list.isNotEmpty) {
      list.forEach((element) {

        //防止商品重复选择
        for (StockModel stockModel in _model.stockList) {
          if (element['id'] == stockModel.goodsModel.id){
            return;
          }
        }

        StockModel stockModel = StockModel(key: UniqueKey());
        stockModel.goodsModel = GoodsModel(
            name: element['name'],
            id: element['id'],
            image: element['pic'],
            count: element['count'],
            invoice: double.parse(element['invoice'].toString()),
            middleman: double.parse(element['middleman'].toString()),
            weight: double.parse(element['weight'].toString())
        );
        stockModel.goodsModel.specs.add(SpecModel(spec: element['spec ']));
        _model.addToStockList(stockModel);
      });
    }
  }

  ///选择客户
  _pickCustomerAction(BuildContext context, StockAddModel _model) async {
    Map select = await showSelectSearchList(context, Api.customerList, '请选择客户', 'corporateName');
    EmployeeModel model = EmployeeModel(name: select['corporateName'] ?? '', id: select['id'] ?? '');
    if (model != null) {
      _model.setStockList([]);
      _model.setCustomer(model);
      _pickGoodsAction(model.id, _model);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _editingController?.dispose();
    _focusNode?.dispose();
  }
}
