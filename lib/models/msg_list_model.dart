import 'package:flutter/material.dart';

class MsgListModel extends ChangeNotifier {
  String time;
  String title;
  ///是否已读
  bool _read;
  String content;
  ///附件
  String enclosureName;
  String enclosureSize;
  String enclosureURL;
  String id;
  ///是否是对账单
  bool forDuiZhangDan;
  ///对账单是否已经签署
  bool _sign;
  ///是否是用于规章文件列表，如果是，没有已读未读的功能几对应的显示
  bool forRegularDoc;

  ///是否已读
  bool get read => _read;
  setRead(bool read){
    _read = read;
    notifyListeners();
  }
  ///对账单是否已经签署
  bool get sign => _sign;
  setSign(bool sign){
    _sign = sign;
    notifyListeners();
  }

  MsgListModel({
    this.title = '',
    this.time = '',
    this.content = '',
    this.enclosureName = '',
    this.forDuiZhangDan = false,
    this.id = '',
    this.enclosureSize = '',
    this.enclosureURL = '',
    this.forRegularDoc = false,
  }) {
    setRead(false);
    setSign(false);
  }
}