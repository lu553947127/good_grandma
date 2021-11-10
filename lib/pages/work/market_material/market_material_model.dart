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

  ///备注
  String _remarks;

  MarketMaterialModel() {
    _state = '';
    _warehousingList = [];
    warehousingMapList = [];
    _warehouseList = [];
    warehouseMapList = [];
    _remarks = '';
  }

  ///出入库状态
  String get state => _state;

  ///备注
  String get remarks => _remarks;

  ///入库列表
  List<WarehousingModel> get warehousingList => _warehousingList;

  ///出库列表
  List<WarehouseModel> get warehouseList => _warehouseList;


  setState(String state) {
    _state = state;
    notifyListeners();
  }

  setRemarks(String remarks) {
    _remarks = remarks;
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
    addData['exWarehouse'] = model.exWarehouse;
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
    addData['exWarehouse'] = model.exWarehouse;
    warehouseMapList.setAll(index, [addData]);
    notifyListeners();
  }

  ///删除单个item
  deleteWarehouseModelWith(int index){
    if(_warehouseList == null)
      _warehouseList = [];
    if(index >= _warehouseList.length) return;
    _warehouseList.removeAt(index);
    warehouseMapList.removeAt(index);
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

  ///数量
  String surplus;

  WarehousingModel({
    this.materialAreaId = '',
    this.materialAreName = '',
    this.loss = '',
    this.surplus = ''
  });
}

///出库模型数据
class WarehouseModel {

  ///物料id
  String materialAreaId;

  ///物料名称
  String materialAreName;

  ///现有数量
  int newQuantity;

  ///数量
  String exWarehouse;

  WarehouseModel({
    this.materialAreaId = '',
    this.materialAreName = '',
    this.newQuantity = 0,
    this.exWarehouse = ''
  });
}