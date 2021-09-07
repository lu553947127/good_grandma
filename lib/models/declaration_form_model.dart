import 'package:flutter/material.dart';
import 'package:good_grandma/models/StoreModel.dart';
import 'package:good_grandma/models/goods_model.dart';

class DeclarationFormModel extends ChangeNotifier {
  StoreModel _storeModel;
  List<GoodsModel> _goodsList;
  List<GoodsModel> _rewardGoodsList;
  String _phone;
  String _address;
  String _remark;
  String time;

  ///标记订单是否审核完成
  bool _completed;
  String id;

  DeclarationFormModel({this.time = '', this.id = ''}) {
    _storeModel = StoreModel();
    _goodsList = [];
    _rewardGoodsList = [];
    _phone = '';
    _address = '';
    _remark = '';
    _completed = false;
  }

  ///店铺
  StoreModel get storeModel => _storeModel;

  ///商品列表
  List<GoodsModel> get goodsList => _goodsList;

  ///奖励商品列表
  List<GoodsModel> get rewardGoodsList => _rewardGoodsList;

  ///电话
  String get phone => _phone;

  ///地址
  String get address => _address;

  ///备注
  String get remark => _remark;

  ///标记订单是否审核完成
  bool get completed => _completed;

  ///商品总数
  int get goodsCount {
    int count = 0;
    _goodsList.forEach((goodsModel) {
      count += goodsModel.count;
    });
    return count;
  }

  ///商品总重
  double get goodsWeight {
    double count = 0;
    _goodsList.forEach((goodsModel) {
      count += goodsModel.countWeight;
    });
    return count;
  }

  ///商品总额
  double get goodsPrice {
    double count = 0;
    _goodsList.forEach((goodsModel) {
      count += goodsModel.countPrice;
    });
    return count;
  }

  setCompleted(bool completed) {
    _completed = completed;
    notifyListeners();
  }

  setStoreModel(StoreModel storeModel) {
    _storeModel = storeModel;
    notifyListeners();
  }

  setPhone(String phone) {
    _phone = phone;
    notifyListeners();
  }

  setAddress(String address) {
    _address = address;
    notifyListeners();
  }

  setRemark(String remark) {
    _remark = remark;
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

  addToArray(List<GoodsModel> array, GoodsModel goodsModel) {
    if (array == null) array = [];
    array.add(goodsModel);
    notifyListeners();
  }

  editArrayWith(List<GoodsModel> array, int index, GoodsModel goodsModel) {
    if (array == null) array = [];
    if (index >= array.length) return;
    array.setAll(index, [goodsModel]);
    notifyListeners();
  }

  deleteArrayWith(List<GoodsModel> array, int index) {
    if (array == null) array = [];
    if (index >= array.length) return;
    array.removeAt(index);
    notifyListeners();
  }

  setModelWithModel(DeclarationFormModel model) {
    _completed = model.completed;
    _storeModel = model.storeModel;
    _phone = model.phone;
    _address = model.address;
    _remark = model.remark;
    _goodsList = model.goodsList;
    id = model.id;
    time = model.time;
  }
}
