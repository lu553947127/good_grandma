import 'package:flutter/material.dart';
import 'package:good_grandma/models/employee_model.dart';
import 'package:good_grandma/models/goods_model.dart';

///商品添加model
class StockAddModel extends ChangeNotifier {
  ///客户
  EmployeeModel _customer;

  ///商品列表
  List<StockModel> _stockList;

  List<GoodsModel> _goodsList;

  ///客户
  EmployeeModel get customer => _customer;

  ///商品列表
  List<StockModel> get stockList => _stockList;

  ///商品列表
  List<GoodsModel> get goodsList => _goodsList;
  StockAddModel() {
    _customer = EmployeeModel();
    _stockList = [];
    _goodsList = [];
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

  setArrays(
      List<GoodsModel> array,
      List<GoodsModel> values,
      ) {
    if (array == null) array = [];
    array.clear();
    array.addAll(values);
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
    _goodsList.removeAt(index);
    notifyListeners();
  }

}

///库存模型
class StockModel {
  GoodsModel goodsModel;

  ///1-3月存量
  String oneToThree;
  ///4-6月存量
  String fourToSix;
  ///7-9月存量
  String sevenToTwelve;
  ///9月以上存量
  String eighteenToUp;

  StockModel({
    ///key必须传，否则修改数目会出错
    @required Key key,
    this.oneToThree = '',
    this.fourToSix = '',
    this.sevenToTwelve = '',
    this.eighteenToUp = ''
  }) {
    goodsModel = GoodsModel();
  }
}
