import 'package:flutter/cupertino.dart';

///物料订单模型
class MarketingOrderModel extends ChangeNotifier {

  ///区域id
  String _deptId;
  ///区域名称
  String _deptName;
  ///是否随货
  String _withGoods;
  ///经销商名称
  String _customerName;
  ///物料地址
  String _address;
  ///物料列表
  List<MarketingModel> _materList;

  MarketingOrderModel() {
    _deptId = '';
    _deptName = '';
    _withGoods = '2';
    _customerName = '';
    _address = '';
    _materList = [];
    mapList = [];
  }

  ///区域id
  String get deptId => _deptId;

  ///区域名称
  String get deptName => _deptName;

  ///是否随货
  String get withGoods => _withGoods;

  ///经销商名称
  String get customerName => _customerName;

  ///物料地址
  String get address => _address;

  ///物料列表
  List<Map> mapList;

  ///物料列表
  List<MarketingModel> get materList => _materList;


  setDeptId(String deptId) {
    _deptId = deptId;
    notifyListeners();
  }

  setDeptName(String deptName) {
    _deptName = deptName;
    notifyListeners();
  }

  setWithGoods(String withGoods) {
    _withGoods = withGoods;
    notifyListeners();
  }

  setCustomerName(String customerName) {
    _customerName = customerName;
    notifyListeners();
  }

  setAddress(String address) {
    _address = address;
    notifyListeners();
  }

  ///添加item
  addModel(MarketingModel model){
    if(_materList == null)
      _materList = [];
    _materList.add(model);
    Map addData = new Map();
    addData['materialId'] = model.materialId;
    addData['quantity'] = model.quantity;
    addData['unitPrice'] = model.unitPrice;
    mapList.add(addData);
    print('mapList------------$mapList');
    notifyListeners();
  }

  ///编辑当前item
  editModelWith(int index, MarketingModel model){
    if(_materList == null)
      _materList = [];
    if(index >= _materList.length) return;
    _materList.setAll(index, [model]);
    Map addData = new Map();
    addData['materialId'] = model.materialId;
    addData['quantity'] = model.quantity;
    addData['unitPrice'] = model.unitPrice;
    mapList.setAll(index, [addData]);
    notifyListeners();
  }

  ///删除单个item
  deleteModelWith(int index){
    if(_materList == null)
      _materList = [];
    if(index >= _materList.length) return;
    _materList.removeAt(index);
    mapList.removeAt(index);
    notifyListeners();
  }
}

///物料模型数据
class MarketingModel {

  ///物料id
  String materialId;

  ///物料名称
  String materialName;

  ///数量
  String quantity;

  ///现有数量
  int newQuantity;

  ///单价
  String unitPrice;

  MarketingModel({
    this.materialId = '',
    this.materialName = '',
    this.quantity = '',
    this.newQuantity = 0,
    this.unitPrice = ''
  });
}
