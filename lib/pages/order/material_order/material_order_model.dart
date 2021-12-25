import 'package:flutter/cupertino.dart';

///物料订单模型
class MarketingOrderModel extends ChangeNotifier {

  ///物料列表
  List<MarketingModel> _materList;

  MarketingOrderModel() {
    _materList = [];
    mapList = [];
  }

  ///物料列表
  List<Map> mapList;

  ///物料列表
  List<MarketingModel> get materList => _materList;

  ///添加item
  addModel(MarketingModel model){
    if(_materList == null)
      _materList = [];
    _materList.add(model);
    Map addData = new Map();
    addData['materialId'] = model.materialId;
    addData['quantity'] = model.quantity;
    addData['unitPrice'] = model.unitPrice;
    addData['withGoods'] = model.withGoods;
    addData['deptId'] = model.deptId;
    addData['customerId'] = model.customerId;
    addData['address'] = model.address;
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
    addData['withGoods'] = model.withGoods;
    addData['deptId'] = model.deptId;
    addData['customerId'] = model.customerId;
    addData['address'] = model.address;
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

  ///是否随货
  String withGoods;

  ///区域id
  String deptId;

  ///区域名称
  String deptName;

  ///经销商名称
  String customerId;

  ///经销商名称
  String customerName;

  ///物料地址
  String address;

  MarketingModel({
    this.materialId = '',
    this.materialName = '',
    this.quantity = '',
    this.newQuantity = 0,
    this.unitPrice = '',
    this.deptId = '',
    this.deptName = '',
    this.withGoods = '2',
    this.customerId = '',
    this.customerName = '',
    this.address = ''
  });
}
