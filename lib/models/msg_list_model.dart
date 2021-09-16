import 'package:flutter/material.dart';

class MsgListModel extends ChangeNotifier {
  String time;
  String title;

  ///是否已读
  bool _read;
  ///内容 用于列表显示，没有富文本标签
  String text;
  ///内容 用于详情页显示，是富文本
  String content;

  ///附件
  String enclosureName;
  ///附件大小 mb
  String enclosureSize;

  ///附件下载地址
  String enclosureURL;

  ///附件查看地址
  String enclosureViewURL;
  String id;

  ///是否是对账单
  bool forDuiZhangDan;

  ///对账单是否已经签署
  bool _sign;

  ///是否是用于规章文件列表，如果是，没有已读未读的功能几对应的显示
  bool forRegularDoc;

  ///是否已读
  bool get read => _read;

  ///是否拥有附件
  bool get haveEnclosure =>
      (enclosureURL.isNotEmpty || enclosureViewURL.isNotEmpty);
  setRead(bool read) {
    _read = read;
    notifyListeners();
  }

  ///对账单是否已经签署
  bool get sign => _sign;
  setSign(bool sign) {
    _sign = sign;
    notifyListeners();
  }

  MsgListModel({
    this.title = '',
    this.time = '',
    this.content = '',
    this.text = '',
    this.id = '',
    this.forDuiZhangDan = false,
    this.enclosureName = '',
    this.enclosureSize = '',
    this.enclosureURL = '',
    this.enclosureViewURL = '',
    this.forRegularDoc = false,
  }) {
    setRead(false);
    setSign(false);
  }
  MsgListModel.fromJson(Map<String, dynamic> json) {
    title = json['title'] ?? '';
    time = json['createTime'] ?? '';
    content = json['content'] ?? '';
    text = json['text'] ?? '';
    id = json['id'] ?? '';
    enclosureURL = json['filePath'] ?? '';
    enclosureViewURL = json['fileViewPath'] ?? '';
    enclosureSize = json['fileSize'] ?? '';
    enclosureName = json['fileName'] ?? '';
    setRead(json['readStatus'] == '1');
    setSign(false);
    this.forRegularDoc = false;
    this.forDuiZhangDan = false;
  }
}
