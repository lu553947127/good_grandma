import 'dart:convert';

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

  DeclarationFormModel.fromJson(Map<String, dynamic> json) {
    String name = json['cusName'] ?? '';
    String customerId = json['customerId'] ?? '';
    String phone = json['phone'] ?? '';
    String address = json['address'] ?? '';
    _storeModel = StoreModel(name: name,id: customerId,phone: phone,address: address);
    _goodsList = [];
    if (json['goodsList'] != null) {
      json['goodsList'].forEach((v) {
        goodsList.add(new GoodsModel.fromJsonForList(v));
      });
    }
    _rewardGoodsList = [];
    if (json['gifts'] != null) {
      json['gifts'].forEach((v) {
        _rewardGoodsList.add(new GoodsModel.fromJsonForList(v));
      });
    }
    id = json['id'] ?? '';
    time = json['time'] ?? '';
    _remark = json['remark'] ?? '';
    _phone = json['phone'] ?? '';
    _address = json['address'] ?? '';

    _completed = false;
    int status = json['status'] ?? 1;
    if(status == 2)
      _completed = true;
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

  ///商品二批价总额
  double get goodsMiddlemanPrice {
    double count = 0;
    _goodsList.forEach((goodsModel) {
      count += goodsModel.countMiddlemanPrice;
    });
    return count;
  }

  String get goodsListToString{
    return jsonEncode(_goodsList.map((goodsModel) => goodsModel.toMap()).toList());
  }

  String get rewardGoodsListToString{
    return jsonEncode(_rewardGoodsList.map((goodsModel) => goodsModel.toMap()).toList());
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
    _rewardGoodsList = model.rewardGoodsList;
    id = model.id;
    time = model.time;
  }
}
