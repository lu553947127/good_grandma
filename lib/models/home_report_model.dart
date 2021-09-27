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
  });
  HomeReportModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    userName = json['name'] ?? '';
    avatar = json['avatar'] ?? '';
    time = json['createTime'] ?? '';
    String type = json['type'] ?? '';
    if(type != null){
      postType = int.parse(type);
    }
    target = double.parse(json['target']) ?? 0.0;
    cumulative = double.parse(json['cumulative']) ?? 0.0;
    actual = double.parse(json['actual']) ?? 0.0;

    String thisContent = json['thisContent'];
    summary = AppUtil.getListFromString(thisContent);
    String nextContent = json['nextContent'];
    plans = AppUtil.getListFromString(nextContent);
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.userName;
    data['avatar'] = this.avatar;
    data['createTime'] = this.time;
    data['type'] = this.postType.toString();
    data['target'] = this.target.toString();
    data['cumulative'] = this.cumulative.toString();
    data['actual'] = this.actual.toString();
    // data['thisContent'] = this.thisContent;
    // data['nextContent'] = this.nextContent;
    return data;
  }
}
