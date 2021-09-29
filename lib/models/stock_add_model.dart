import 'package:flutter/material.dart';
import 'package:good_grandma/models/employee_model.dart';
import 'package:good_grandma/models/goods_model.dart';

///商品添加model
class StockAddModel extends ChangeNotifier {
  ///客户
  EmployeeModel _customer;

  ///商品列表
  List<StockModel> _stockList;

  ///客户
  EmployeeModel get customer => _customer;

  ///商品列表
  List<StockModel> get stockList => _stockList;
  StockAddModel() {
    _customer = EmployeeModel();
    _stockList = [];
  }
  setCustomer(EmployeeModel customer) {
    _customer = customer;
    notifyListeners();
  }

  setStockList(List<StockModel> stockList) {
    if (_stockList == null) _stockList = [];
    _stockList.clear();
    _stockList.addAll(stockList);
    notifyListeners();
  }

  addToStockList(StockModel stockModel) {
    if (_stockList == null) _stockList = [];
    _stockList.add(stockModel);
    notifyListeners();
  }

  editStockListWith(int index, StockModel stockModel) {
    if (_stockList == null) _stockList = [];
    if (index >= _stockList.length) return;
    _stockList.setAll(index, [stockModel]);
    notifyListeners();
  }

  deleteStockListWith(int index) {
    if (_stockList == null) _stockList = [];
    if (index >= _stockList.length) return;
    _stockList.removeAt(index);
    notifyListeners();
  }

}

///库存模型
class StockModel {
  GoodsModel goodsModel;

  ///生产时间
  String time;
  StockModel({
    ///key必须传，否则修改数目会出错
    @required Key key,
    this.time = '',
  }) {
    goodsModel = GoodsModel();
  }
}
