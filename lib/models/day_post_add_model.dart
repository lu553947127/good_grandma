import 'package:flutter/material.dart';
import 'package:good_grandma/common/utils.dart';

class DayPostAddModel extends ChangeNotifier {
  DayPostAddModel() {
    _target = '';
    _cumulative = '';
    _actual = '';
    _achievementRate = 0.0;
    _summaries = [];
    _plans = [];
    type = 1;
    id = '';
  }
  String id;

  ///类别 1：日报 2：周报 3：月报
  int type;

  ///本月目标
  String _target;

  ///本月累计
  String _cumulative;

  ///今日销售
  String _actual;

  ///月度达成率
  double _achievementRate;

  ///今日工作总结
  List<String> _summaries;

  ///明日工作计划
  List<String> _plans;

  ///本月目标
  String get target => _target;

  ///本月累计
  String get cumulative => _cumulative;

  ///今日销售
  String get actual => _actual;

  ///月度达成率
  String get achievementRate => _achievementRate.toStringAsFixed(2);

  ///今日工作总结
  List<String> get summaries => _summaries;

  ///明日工作计划
  List<String> get plans => _plans;

  setTarget(String target) {
    _target = target;
    setAchievementRate();
    notifyListeners();
  }

  setCumulative(String cumulative) {
    _cumulative = cumulative;
    setAchievementRate();
    notifyListeners();
  }

  setAchievementRate() {
    if ((target != null && target.isNotEmpty) &&
        (cumulative != null && cumulative.isNotEmpty)) {
      double t = double.parse(target);
      double c = double.parse(cumulative);
      if (t > 0 && c > 0) _achievementRate = c / t;
      _achievementRate *= 100;//换算成百分比
    }
    else{
      _achievementRate = 0.0;
    }
  }

  setActual(String actual) {
    _actual = actual;
    notifyListeners();
  }

  setSummaries(List<String> summaries) {
    if(_summaries == null)
      _summaries = [];
    _summaries.clear();
    _summaries.addAll(summaries);
    notifyListeners();
  }
  addSummary(String text){
    if(_summaries == null)
      _summaries = [];
    _summaries.add(text);
    notifyListeners();
  }
  editSummariesWith(int index,String value){
    if(_summaries == null)
      _summaries = [];
    if(index >= _summaries.length) return;
    _summaries.setAll(index, [value]);
    notifyListeners();
  }

  deleteSummariesWith(int index){
    if(_summaries == null)
      _summaries = [];
    if(index >= _summaries.length) return;
    _summaries.removeAt(index);
    notifyListeners();
  }

  setPlans(List<String> plans) {
    if(_plans == null)
      _plans = [];
    _plans.clear();
    _plans.addAll(plans);
    notifyListeners();
  }
  addPlan(String text){
    if(_plans == null)
      _plans = [];
    _plans.add(text);
    notifyListeners();
  }
  editPlanWith(int index,String value){
    if(_plans == null)
      _plans = [];
    if(index >= _plans.length) return;
    _plans.setAll(index, [value]);
    notifyListeners();
  }

  deletePlanWith(int index){
    if(_plans == null)
      _plans = [];
    if(index >= _plans.length) return;
    _plans.removeAt(index);
    notifyListeners();
  }

  DayPostAddModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    _target = json['target'] ?? '';
    _cumulative = json['cumulative'] ?? '';
    _actual = json['actual'] ?? '';

    String thisContent = json['thisContent'];

    setSummaries(AppUtil.getListFromString(thisContent));
    String nextContent = json['nextContent'];
    setPlans(AppUtil.getListFromString(nextContent));
  }
}
