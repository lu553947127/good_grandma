import 'package:flutter/cupertino.dart';

///物料订单模型
class MarketingOrderModel extends ChangeNotifier {

  ///公司
  String _company;

  ///经销商列表
  List<CustomerModel> _customerList;

  MarketingOrderModel() {
    this._company = '';
    _customerList = [];
    customerMapList = [];
  }

  ///公司
  String get company => _company;

  ///经销商列表
  List<Map> customerMapList;

  ///经销商列表
  List<CustomerModel> get customerList => _customerList;

  ///添加item
  addCustomerModel(CustomerModel model, List<Map> materMapList){
    if(_customerList == null)
      _customerList = [];
    _customerList.add(model);
    Map addData = new Map();
    addData['withGoods'] = model.withGoods;
    addData['withGoodsNum'] = model.withGoodsNum;
    addData['deptId'] = model.deptId;
    addData['customerId'] = model.customerId;
    addData['address'] = model.address;
    addData['phone'] = model.phone;
    addData['remarks'] = model.remarks;
    addData['materialDetails'] = model.materMapList;

    if (materMapList != null && materMapList.isNotEmpty){
      materMapList.forEach((element) {
        model.addModel(MarketingModel(
          materialId: element['materialId'],
          materialName: element['materialName'],
          quantity: element['quantity'].toString(),
          unitPrice: element['unitPrice'].toString(),
        ));
      });
    }
    customerMapList.add(addData);
    notifyListeners();
  }

  ///编辑当前item
  editCustomerModelWith(int index, CustomerModel model){
    if(_customerList == null)
      _customerList = [];
    if(index >= _customerList.length) return;
    _customerList.setAll(index, [model]);
    Map addData = new Map();
    addData['withGoods'] = model.withGoods;
    addData['withGoodsNum'] = model.withGoodsNum;
    addData['deptId'] = model.deptId;
    addData['customerId'] = model.customerId;
    addData['address'] = model.address;
    addData['phone'] = model.phone;
    addData['remarks'] = model.remarks;
    addData['materialDetails'] = model.materMapList;
    customerMapList.setAll(index, [addData]);
    notifyListeners();
  }

  ///删除单个item
  deleteCustomerModelWith(int index){
    if(_customerList == null)
      _customerList = [];
    if(index >= _customerList.length) return;
    _customerList.removeAt(index);
    customerMapList.removeAt(index);
    notifyListeners();
  }

  setCompany(str){
    _company = str;
    notifyListeners();
  }
}

///经销商模型数据
class CustomerModel {

  ///是否随货
  String withGoods;

  ///随货订单编号
  String withGoodsNum;

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

  ///联系电话
  String phone;

  ///备注
  String remarks;

  ///物料列表
  List<MarketingModel> materList;

  ///物料列表
  List<Map> materMapList;

  ///预算
  double surplus;

  CustomerModel({
    this.deptId = '',
    this.deptName = '',
    this.withGoods = '2',
    this.withGoodsNum = '',
    this.customerId = '',
    this.customerName = '',
    this.address = '',
    this.phone = '',
    this.remarks = '',
    this.surplus = 0
  }){
    materList = [];
    materMapList = [];
  }

  ///添加item
  addModel(MarketingModel model){
    if(materList == null)
      materList = [];
    materList.add(model);
    Map addData = new Map();
    addData['materialId'] = model.materialId;
    addData['quantity'] = model.quantity;
    addData['unitPrice'] = model.unitPrice;
    materMapList.add(addData);
  }

  ///编辑当前item
  editModelWith(int index, MarketingModel model){
    if(materList == null)
      materList = [];
    if(index >= materList.length) return;
    materList.setAll(index, [model]);
    Map addData = new Map();
    addData['materialId'] = model.materialId;
    addData['quantity'] = model.quantity;
    addData['unitPrice'] = model.unitPrice;
    materMapList.setAll(index, [addData]);
  }

  ///删除单个item
  deleteModelWith(int index){
    if(materList == null)
      materList = [];
    if(index >= materList.length) return;
    materList.removeAt(index);
    materMapList.removeAt(index);
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
