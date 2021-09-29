import 'dart:convert';

import 'package:good_grandma/common/utils.dart';

class HomeReportModel {
  ///头像
  String avatar;

  ///用户名
  String userName;

  ///时间
  String time;

  ///类别：日报1 周报2 月报3
  int postType;

  ///目标
  double target;

  ///累计
  double cumulative;

  ///实际
  double actual;

  ///重点工作总结
  List<String> summary;

  ///下周工作计划
  List<String> plans;

  String id;
  ///是否是职能用户
  bool isZN;

  HomeReportModel({
    this.avatar = '',
    this.userName = '',
    this.time = '',
    this.postType = 1,
    this.target = 0,
    this.cumulative = 0,
    this.actual = 0,
    this.summary,
    this.plans,
    this.id = '',
    this.isZN = false,
  });
  HomeReportModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    userName = json['userName'] ?? '';
    avatar = json['avatar'] ?? '';
    time = json['createTime'] ?? '';
    String type = json['type'] ?? '';
    postType = 1;
    if(type != null && type.isNotEmpty) postType = int.parse(type);
    int zn = json['zn'] ?? 0;
    //0员工
    isZN = (zn != 0);
    target = AppUtil.stringToDouble(json['target']);
    cumulative = AppUtil.stringToDouble(json['cumulative']);
    actual = AppUtil.stringToDouble(json['actual']);
    String thisContent = json['thisContent'];
    // print('thisContent = $thisContent');
    summary = AppUtil.getListFromString(thisContent);
    // print('json = $json');
    String nextContent = json['nextContent'];
    plans = AppUtil.getListFromString(nextContent);
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userName'] = this.userName;
    data['avatar'] = this.avatar;
    data['createTime'] = this.time;
    data['type'] = this.postType.toString();
    data['target'] = this.target.toString();
    data['cumulative'] = this.cumulative.toString();
    data['actual'] = this.actual.toString();
    data['summary'] = jsonEncode(summary.map((e) => e.toString()).toList());
    data['plans'] = jsonEncode(plans.map((e) => e.toString()).toList());
    return data;
  }
}
