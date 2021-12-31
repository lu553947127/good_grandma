import 'package:flutter/cupertino.dart';

///物料订单模型
class MarketMaterialModel extends ChangeNotifier {

  ///出入库状态
  String _state;

  ///入库列表
  List<WarehousingModel> _warehousingList;

  ///入库列表
  List<Map> warehousingMapList;

  ///出库列表
  List<WarehouseModel> _warehouseList;

  ///出库列表
  List<Map> warehouseMapList;

  ///经销商id
  String _customerId;

  ///经销商名称
  String _customerName;

  MarketMaterialModel() {
    _state = '';
    _warehousingList = [];
    warehousingMapList = [];
    _warehouseList = [];
    warehouseMapList = [];
    _customerId = '';
    _customerName = '';
  }

  ///出入库状态
  String get state => _state;

  ///经销商id
  String get customerId => _customerId;

  ///经销商名称
  String get customerName => _customerName;

  ///入库列表
  List<WarehousingModel> get warehousingList => _warehousingList;

  ///出库列表
  List<WarehouseModel> get warehouseList => _warehouseList;


  setState(String state) {
    _state = state;
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

  ///添加入库item
  addWarehousingModel(WarehousingModel model){
    if(_warehousingList == null)
      _warehousingList = [];
    _warehousingList.add(model);
    Map addData = new Map();
    addData['materialAreaId'] = model.materialAreaId;
    addData['loss'] = model.loss;
    addData['surplus'] = model.surplus;
    addData['remarks'] = model.remarks;
    warehousingMapList.add(addData);
    notifyListeners();
  }

  ///编辑入库item
  editWarehousingModelWith(int index, WarehousingModel model){
    if(_warehousingList == null)
      _warehousingList = [];
    if(index >= _warehousingList.length) return;
    _warehousingList.setAll(index, [model]);
    Map addData = new Map();
    addData['materialAreaId'] = model.materialAreaId;
    addData['loss'] = model.loss;
    addData['surplus'] = model.surplus;
    addData['remarks'] = model.remarks;
    warehousingMapList.setAll(index, [addData]);
    notifyListeners();
  }

  ///删除单个item
  deleteWarehousingModelWith(int index){
    if(_warehousingList == null)
      _warehousingList = [];
    if(index >= _warehousingList.length) return;
    _warehousingList.removeAt(index);
    warehousingMapList.removeAt(index);
    notifyListeners();
  }

  ///添加出库item
  addWarehouseModel(WarehouseModel model){
    if(_warehouseList == null)
      _warehouseList = [];
    _warehouseList.add(model);
    Map addData = new Map();
    addData['materialAreaId'] = model.materialAreaId;
    addData['materialName'] = model.materialAreName;
    addData['stock'] = model.stock;
    addData['exWarehouse'] = model.exWarehouse;
    addData['remarks'] = model.remarks;
    warehouseMapList.add(addData);
    notifyListeners();
  }

  ///编辑出库item
  editWarehouseModelWith(int index, WarehouseModel model){
    if(_warehouseList == null)
      _warehouseList = [];
    if(index >= _warehouseList.length) return;
    _warehouseList.setAll(index, [model]);
    Map addData = new Map();
    addData['materialAreaId'] = model.materialAreaId;
    addData['materialName'] = model.materialAreName;
    addData['stock'] = model.stock;
    addData['exWarehouse'] = model.exWarehouse;
    addData['remarks'] = model.remarks;
    warehouseMapList.setAll(index, [addData]);
    notifyListeners();
  }
}

///入库模型数据
class WarehousingModel {

  ///物料id
  String materialAreaId;

  ///物料名称
  String materialAreName;

  ///损耗
  String loss;

  ///入库数量
  String surplus;

  ///备注
  String remarks;

  WarehousingModel({
    this.materialAreaId = '',
    this.materialAreName = '',
    this.loss = '',
    this.surplus = '',
    this.remarks = '',
  });
}

///出库模型数据
class WarehouseModel {

  ///物料id
  String materialAreaId;

  ///物料名称
  String materialAreName;

  ///可用数量
  int stock;

  ///出库数量
  String exWarehouse;

  ///备注
  String remarks;

  WarehouseModel({
    this.materialAreaId = '',
    this.materialAreName = '',
    this.stock = 0,
    this.exWarehouse = '',
    this.remarks = ''
  });
}