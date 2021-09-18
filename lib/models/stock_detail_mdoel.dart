import 'package:flutter/material.dart';

class StockDetailModel extends ChangeNotifier{
  String name;
  String count;
  bool _opened;
  List<StackGoodsListModel> goodsList;

  bool get opened => _opened;

  setOpened(bool opened){
    _opened = opened;
    notifyListeners();
  }

  StockDetailModel({this.name = '', this.count = '', }) {
    setOpened(false);
    this.goodsList = [];
  }

  StockDetailModel.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    count = json['totalInventory'].toString() ?? '';
    setOpened(false);
    goodsList = [];
    if (json['appCustomerCheckData'] != null) {
      List<String> keys = ['oneToThree','fourToSix','sevenToTwelve','thirteenToEighteen','eighteenToUp'];
      keys.forEach((key) {
        StackGoodsListModel model = StackGoodsListModel();
        model.typeName = key;
        json['appCustomerCheckData'].forEach((v) {
          String spec = v['spec'];
          if(spec == '20')
            model.spec20 = v[key].toString() ?? '';
          else if(spec == '40')
            model.spec40 = v[key].toString() ?? '';
        });
        goodsList.add(model);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['count'] = this.count;
    if (this.goodsList != null) {
      data['data'] = this.goodsList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StackGoodsListModel {
  String typeName;
  String spec20;
  String spec40;

  StackGoodsListModel({this.typeName = '', this.spec20 = '', this.spec40 = ''});

  StackGoodsListModel.fromJson(Map<String, dynamic> json) {
    typeName = json['typeName'] ?? '';
    spec20 = json['spec20'].toString() ?? '';
    spec40 = json['spec40'].toString() ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['typeName'] = this.typeName;
    data['spec20'] = this.spec20;
    data['spec40'] = this.spec40;
    return data;
  }
}