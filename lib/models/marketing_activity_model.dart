import 'package:flutter/cupertino.dart';

///市场活动模型
class MarketingActivityModel extends ChangeNotifier {
  String id;
  String status;
  int statusId;

  ///发布时间
  String _name;
  String _startTime;
  String _endTime;
  String _customerName;
  String _costTotal;
  String _purchaseMoney;
  String _purchaseRatio;
  String _sketch;

  ///费用信息列表
  List<CostModel> _costList;

  ///费用信息列表
  List<Map> costMapList;

  ///试吃品列表
  List<SampleModel> _sampleList;

  ///试吃品列表
  List<Map> sampleMapList;

  MarketingActivityModel({
    id: '',
    status: '',
  }) {
    _name = '';
    _startTime = '';
    _endTime = '';
    _customerName = '';
    _costTotal = '';
    _purchaseMoney = '';
    _purchaseRatio = '';
    _sketch = '';
    _costList = [];
    costMapList = [];
    _sampleList = [];
    sampleMapList = [];

    if (id == ''){
      addCostModel(CostModel(
          costType: '1',
          costTypeName: '促销员费用',
          costCash: '',
          costDescribe: ''
      ));
      addCostModel(CostModel(
          costType: '2',
          costTypeName: '生动化工具费',
          costCash: '',
          costDescribe: ''
      ));
    }
  }

  ///活动名称
  String get name => _name;

  ///开始时间
  String get startTime => _startTime;

  ///结束时间
  String get endTime => _endTime;

  ///上级通路客户
  String get customerName => _customerName;

  ///申请资源费用合计
  String get costTotal => _costTotal;

  ///预计进货额
  String get purchaseMoney => _purchaseMoney;

  ///预计进货投入产出比
  String get purchaseRatio => _purchaseRatio;

  ///活动简述
  String get sketch => _sketch;

  ///费用信息列表
  List<CostModel> get costList => _costList;

  ///试吃品列表
  List<SampleModel> get sampleList => _sampleList;

  ///发布时间
  String createTime = '';

  ///费用信息列表
  List<dynamic> activityCostList = [];

  ///试吃品列表
  List<dynamic> activityCosts = [];

  ///试吃品
  String materialName = '';

  MarketingActivityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    _name = json['name'] ?? '';
    _startTime = json['starttime'] ?? '';
    _endTime = json['endtime'] ?? '';
    _customerName = json['customerName'].toString() ?? '';
    _costTotal = json['costtotal'] ?? '';
    _purchaseMoney = json['purchasemoney'] ?? '';
    _purchaseRatio = json['purchaseratio'] ?? '';
    _sketch = json['sketch'] ?? '';
    createTime = json['createTime'] ?? '';
    activityCostList = json['activityCostList'] ?? '';
    activityCosts = json['activityCosts'] ?? '';
    materialName = json['materialName'] ?? '';
    statusId = json['status'] ?? '';
  }

  setName(String name) {
    _name = name;
    notifyListeners();
  }

  setStartTime(String startTime) {
    _startTime = startTime;
    notifyListeners();
  }

  setEndTime(String endTime) {
    _endTime = endTime;
    notifyListeners();
  }

  setCustomerName(String customerName) {
    _customerName = customerName;
    notifyListeners();
  }

  setCostTotal(String costTotal) {
    _costTotal = costTotal;
    notifyListeners();
  }

  setPurchaseMoney(String purchaseMoney) {
    _purchaseMoney = purchaseMoney;
    notifyListeners();
  }

  setPurchaseRatio(String purchaseRatio) {
    _purchaseRatio = purchaseRatio;
    notifyListeners();
  }

  setSketch(String sketch) {
    _sketch = sketch;
    notifyListeners();
  }

  ///添加试吃品
  addSampleModel(SampleModel model){
    if(_sampleList == null)
      _sampleList = [];
    _sampleList.add(model);
    Map addData = new Map();
    addData['materialAreaId'] = model.materialAreaId;
    addData['sample'] = model.sample;
    addData['costDescribe'] = model.costDescribe;
    sampleMapList.add(addData);
    notifyListeners();
  }

  ///编辑当前item
  editSampleModelWith(int index, SampleModel model){
    if(_sampleList == null)
      _sampleList = [];
    if(index >= _sampleList.length) return;
    _sampleList.setAll(index, [model]);
    Map addData = new Map();
    addData['materialAreaId'] = model.materialAreaId;
    addData['sample'] = model.sample;
    addData['costDescribe'] = model.costDescribe;
    sampleMapList.setAll(index, [addData]);
    notifyListeners();
  }

  ///删除单个item
  deleteSampleModelWith(int index){
    if(_sampleList == null)
      _sampleList = [];
    if(index >= _sampleList.length) return;
    _sampleList.removeAt(index);
    sampleMapList.removeAt(index);
    notifyListeners();
  }

  ///添加item
  addCostModel(CostModel model){
    if(_costList == null)
      _costList = [];
    _costList.add(model);
    Map addData = new Map();
    addData['costType'] = model.costType;
    addData['costCash'] = model.costCash;
    addData['costDescribe'] = model.costDescribe;
    costMapList.add(addData);
    notifyListeners();
  }

  ///编辑当前item
  editCostModelWith(int index, CostModel model){
    if(_costList == null)
      _costList = [];
    if(index >= _costList.length) return;
    _costList.setAll(index, [model]);
    Map addData = new Map();
    addData['costType'] = model.costType;
    addData['costCash'] = model.costCash;
    addData['costDescribe'] = model.costDescribe;
    costMapList.setAll(index, [addData]);
    notifyListeners();
  }

  ///删除单个item
  deleteCostModelWith(int index){
    if(_costList == null)
      _costList = [];
    if(index >= _costList.length) return;
    _costList.removeAt(index);
    costMapList.removeAt(index);
    notifyListeners();
  }
}

///费用模型数据
class CostModel {

  ///费用类别
  String costType;

  ///费用类别名称
  String costTypeName;

  ///现金
  String costCash;

  ///费用描述
  String costDescribe;

  CostModel({
    this.costType = '',
    this.costTypeName = '',
    this.costCash = '',
    this.costDescribe = ''
  });
}

///试吃品模型数据
class SampleModel {

  ///物料id
  String materialAreaId;

  ///物料名称
  String materialAreaName;

  ///现有数量
  int newQuantity;

  ///数量
  int sample;

  ///费用描述
  String costDescribe;

  SampleModel({
    this.materialAreaId = '',
    this.materialAreaName = '',
    this.newQuantity = 0,
    this.sample = 0,
    this.costDescribe = ''
  });
}
