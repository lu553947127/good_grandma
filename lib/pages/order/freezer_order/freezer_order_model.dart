import 'package:flutter/cupertino.dart';

///冰柜订单模型
class FreezerOrderModel extends ChangeNotifier {

  ///联系人
  String _linkName;

  ///联系电话
  String _linkPhone;

  ///客户Id
  String _customerId;

  ///客户名称
  String _customerName;

  ///收货地址
  String _address;

  ///冰柜列表
  List<FreezerModel> _freezerList;

  ///冰柜列表
  List<Map> freezerMapList;

  FreezerOrderModel() {
    _linkName = '';
    _linkPhone = '';
    _customerId = '';
    _customerName = '';
    _address = '';
    _freezerList = [];
    freezerMapList = [];
  }

  ///联系人
  String get linkName => _linkName;

  ///联系电话
  String get linkPhone => _linkPhone;

  ///客户Id
  String get customerId => _customerId;

  ///客户名称
  String get customerName => _customerName;

  ///收货地址
  String get address => _address;

  ///冰柜列表
  List<FreezerModel> get freezerList => _freezerList;

  setLinkName(String linkName) {
    _linkName = linkName;
    notifyListeners();
  }

  setLinkPhone(String linkPhone) {
    _linkPhone = linkPhone;
    notifyListeners();
  }

  setCustomerId(String customerId) {
    _customerId = customerId;
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
  addModel(FreezerModel model){
    if(_freezerList == null)
      _freezerList = [];
    _freezerList.add(model);
    Map addData = new Map();
    addData['brand'] = model.brand;
    addData['model'] = model.model;
    addData['longCount'] = model.longCount;
    addData['returnCount'] = model.returnCount;
    freezerMapList.add(addData);
    notifyListeners();
  }

  ///编辑当前item
  editModelWith(int index, FreezerModel model){
    if(_freezerList == null)
      _freezerList = [];
    if(index >= _freezerList.length) return;
    _freezerList.setAll(index, [model]);
    Map addData = new Map();
    addData['brand'] = model.brand;
    addData['model'] = model.model;
    addData['longCount'] = model.longCount;
    addData['returnCount'] = model.returnCount;
    freezerMapList.setAll(index, [addData]);
    notifyListeners();
  }

  ///删除单个item
  deleteModelWith(int index){
    if(_freezerList == null)
      _freezerList = [];
    if(index >= _freezerList.length) return;
    _freezerList.removeAt(index);
    freezerMapList.removeAt(index);
    notifyListeners();
  }
}

///冰柜模型数据
class FreezerModel {

  ///品牌id
  String brand;

  ///品牌名称
  String brandName;

  ///型号id
  String model;

  ///型号名称
  String modelName;

  ///长押数量
  String longCount;

  ///反押数量
  String returnCount;

  FreezerModel({
    this.brand = '',
    this.brandName = '',
    this.model = '',
    this.modelName = '',
    this.longCount = '',
    this.returnCount = ''
  });
}
