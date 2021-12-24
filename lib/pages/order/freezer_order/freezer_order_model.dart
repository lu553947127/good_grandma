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

  ///订单详情列表
  List<FreezerOModel> _freezerOrderDetailVOList;

  ///订单详情列表
  List<Map> freezerOrderMapList;

  FreezerOrderModel() {
    _linkName = '';
    _linkPhone = '';
    _customerId = '';
    _customerName = '';
    _address = '';
    _freezerList = [];
    freezerMapList = [];
    _freezerOrderDetailVOList = [];
    freezerOrderMapList = [];
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

  ///订单详情列表
  List<FreezerOModel> get freezerOrderDetailVOList => _freezerOrderDetailVOList;

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

  ///添加item
  addOrderModel(FreezerOModel model){
    if(_freezerOrderDetailVOList == null)
      _freezerOrderDetailVOList = [];
    _freezerOrderDetailVOList.add(model);
    Map addData = new Map();
    addData['id'] = model.id;
    addData['orderId'] = model.orderId;
    addData['brand'] = model.brand;
    addData['brandName'] = model.brandName;
    addData['model'] = model.model;
    addData['modelName'] = model.modelName;
    addData['longCount'] = model.longCount;
    addData['returnCount'] = model.returnCount;
    addData['sendCount'] = model.sendCount;
    addData['nowCount'] = model.nowCount;
    freezerOrderMapList.add(addData);
    notifyListeners();
  }

  ///编辑当前item
  editOrderModelWith(int index, FreezerOModel model){
    if(_freezerOrderDetailVOList == null)
      _freezerOrderDetailVOList = [];
    if(index >= _freezerOrderDetailVOList.length) return;
    _freezerOrderDetailVOList.setAll(index, [model]);
    Map addData = new Map();
    addData['id'] = model.id;
    addData['orderId'] = model.orderId;
    addData['brand'] = model.brand;
    addData['brandName'] = model.brandName;
    addData['model'] = model.model;
    addData['modelName'] = model.modelName;
    addData['longCount'] = model.longCount;
    addData['returnCount'] = model.returnCount;
    addData['sendCount'] = model.sendCount;
    addData['nowCount'] = model.nowCount;
    freezerOrderMapList.setAll(index, [addData]);
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
  int longCount;

  ///反押数量
  int returnCount;

  FreezerModel({
    this.brand = '',
    this.brandName = '',
    this.model = '',
    this.modelName = '',
    this.longCount = 0,
    this.returnCount = 0
  });
}

///冰柜订单模型数据
class FreezerOModel {

  ///id
  String id;

  ///订单id
  String orderId;

  ///品牌id
  String brand;

  ///品牌名称
  String brandName;

  ///型号id
  String model;

  ///型号名称
  String modelName;

  ///长押数量
  int longCount;

  ///反押数量
  int returnCount;

  ///总发货数量
  int sendCount;

  ///本次发货数量
  int nowCount;

  FreezerOModel({
    this.id = '',
    this.orderId = '',
    this.brand = '',
    this.brandName = '',
    this.model = '',
    this.modelName = '',
    this.longCount = 0,
    this.returnCount = 0,
    this.sendCount = 0,
    this.nowCount = 0
  });
}
