import 'package:flutter/material.dart';
import 'package:good_grandma/models/employee_model.dart';

///商品添加model
class StockAddModel extends ChangeNotifier {
  ///客户
  List<EmployeeModel> _customers;

  ///商品列表
  List<StockModel> _stockList;

  ///客户
  List<EmployeeModel> get customers => _customers;

  ///商品列表
  List<StockModel> get stockList => _stockList;
  StockAddModel() {
    _customers = [];
    _stockList = [];
  }
  setCustomers(List<EmployeeModel> customers) {
    if (_customers == null) _customers = [];
    _customers.clear();
    _customers.addAll(customers);
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
  List<GoodsModel> goodsList;

  ///整箱40只个数
  String fBoxNum;

  ///整箱20只个数
  String tBoxNum;

  ///非整箱(支)个数
  String unboxNum;

  ///生产时间
  String time;
  StockModel({
    this.fBoxNum = '',
    this.tBoxNum = '',
    this.unboxNum = '',
    this.time = '',
  }) {
    goodsList = [];
  }
}

///商品模型
class GoodsModel {
  String name;
  String id;
  String image;
  bool isSelected;

  GoodsModel({
    this.name = '',
    this.id = '',
    this.image = '',
    this.isSelected = false,
  });
}
