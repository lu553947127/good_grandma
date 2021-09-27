import 'package:flutter/cupertino.dart';
import 'package:good_grandma/models/goods_model.dart';

///市场活动模型
class MarketingActivityModel extends ChangeNotifier {
  String _title;
  String id;

  ///发布时间
  String time;
  String _type;
  String _leading;
  String _startTime;
  String _endTime;
  String _sponsor;
  String _budgetCurrent;
  String _budgetCount;
  String _target;
  String _targetCount;
  String _description;
  List<GoodsModel> _goodsList;

  MarketingActivityModel({
    id: '',
    time: '',
  }) {
    _title = '';
    _type = '';
    _leading = '';
    _startTime = '';
    _endTime = '';
    _sponsor = '';
    _budgetCurrent = '';
    _budgetCount = '';
    _target = '';
    _targetCount = '';
    _description = '';
    _goodsList = [];
  }

  ///活动名称
  String get title => _title;

  ///活动类型
  String get type => _type;

  ///负责人
  String get leading => _leading;

  ///开始时间
  String get startTime => _startTime;

  ///结束时间
  String get endTime => _endTime;

  ///主办方
  String get sponsor => _sponsor;

  ///实际成本
  String get budgetCurrent => _budgetCurrent;

  ///预算成本
  String get budgetCount => _budgetCount;

  ///目标群体
  String get target => _target;

  ///目标数量
  String get targetCount => _targetCount;

  ///活动描述
  String get description => _description;

  ///活动商品
  List<GoodsModel> get goodsList => _goodsList;

  // MarketingActivityModel.fromJson(Map<String, dynamic> json) {
  //   _title = json['name'] ?? '';
  //   size = json['size'] ?? '';
  //   isFolder = json['fileId'] == -1 ?? '';
  //   createTime = json['createTime'] ?? '';
  //   id = json['id'] ?? '';
  //   updateTime = json['updateTime'] ?? '';
  //   path = json['path'] ?? '';
  //   author = json['createUserName'] ?? '无';
  //   userId = json['createUser'] ?? '';
  // }

  setTitle(String title) {
    _title = title;
    notifyListeners();
  }

  setType(String type) {
    _type = type;
    notifyListeners();
  }

  setLeading(String leading) {
    _leading = leading;
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

  setSponsor(String sponsor) {
    _sponsor = sponsor;
    notifyListeners();
  }

  setBudgetCount(String budgetCount) {
    _budgetCount = budgetCount;
    notifyListeners();
  }

  setBudgetCurrent(String budgetCurrent) {
    _budgetCurrent = budgetCurrent;
    notifyListeners();
  }

  setTarget(String target) {
    _target = target;
    notifyListeners();
  }

  setTargetCount(String targetCount) {
    _targetCount = targetCount;
    notifyListeners();
  }

  setDescription(String description) {
    _description = description;
    notifyListeners();
  }

  setGoodsList(List<GoodsModel> goodsList) {
    if (_goodsList == null) _goodsList = [];
    _goodsList.clear();
    _goodsList.addAll(goodsList);
    notifyListeners();
  }

  addGoods(GoodsModel goodsModel) {
    if (_goodsList == null) _goodsList = [];
    _goodsList.add(goodsModel);
    notifyListeners();
  }

  editGoodsWith(int index, GoodsModel goodsModel) {
    if (_goodsList == null) _goodsList = [];
    if (index >= _goodsList.length) return;
    _goodsList.setAll(index, [goodsModel]);
    notifyListeners();
  }

  deleteGoodsWith(int index) {
    if (_goodsList == null) _goodsList = [];
    if (index >= _goodsList.length) return;
    _goodsList.removeAt(index);
    notifyListeners();
  }
}
