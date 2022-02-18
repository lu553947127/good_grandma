import 'package:flutter/material.dart';

class StockDetailModel extends ChangeNotifier {
  String name;
  String count;
  bool _opened;
  List<StackGoodsListModel> goodsList;

  bool get opened => _opened;

  setOpened(bool opened) {
    _opened = opened;
    notifyListeners();
  }

  StockDetailModel({
    this.name = '',
    this.count = '',
  }) {
    setOpened(false);
    this.goodsList = [];
  }

  StockDetailModel.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    count = json['totalInventory'].toString() ?? '';
    setOpened(false);
    goodsList = [];
    if (json['appCustomerCheckData'] != null) {
      List<String> keys = [
        'oneToThree',
        'fourToSix',
        'sevenToTwelve',
        'eighteenToUp'
      ];
      keys.forEach((key) {
        StackGoodsListModel model = StackGoodsListModel();
        model.typeName = key;
        json['appCustomerCheckData'].forEach((v) {
          switch(key){
            case 'oneToThree':
              model.oneToThree = v['oneToThree'].toString();
              break;
            case 'fourToSix':
              model.fourToSix = v['fourToSix'].toString();
              break;
            case 'sevenToTwelve':
              model.sevenToTwelve = v['sevenToTwelve'].toString();
              break;
            case 'eighteenToUp':
              model.eighteenToUp = v['eighteenToUp'].toString();
              break;
          }
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
  String oneToThree;
  String fourToSix;
  String sevenToTwelve;
  String eighteenToUp;

  StackGoodsListModel({this.typeName = ''});

  StackGoodsListModel.fromJson(Map<String, dynamic> json) {
    typeName = json['typeName'] ?? '';
    oneToThree = json['oneToThree'].toString() ?? '';
    fourToSix = json['fourToSix'].toString() ?? '';
    sevenToTwelve = json['sevenToTwelve'].toString() ?? '';
    eighteenToUp = json['eighteenToUp'].toString() ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['typeName'] = this.typeName;
    data['oneToThree'] = this.oneToThree;
    data['fourToSix'] = this.fourToSix;
    data['sevenToTwelve'] = this.sevenToTwelve;
    data['eighteenToUp'] = this.eighteenToUp;
    return data;
  }
}
