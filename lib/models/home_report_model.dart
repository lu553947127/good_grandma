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
  });
}
