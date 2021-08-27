import 'package:flutter/material.dart';
import 'package:good_grandma/models/week_post_add_model.dart';

class MonthPostAddModel extends ChangeNotifier {
  MonthPostAddModel() {
    _target = '';
    _cumulative = '';
    _actual = '';
    _nextTarget = '';
    _achievementRate = 0.0;
    _itineraries = [
      ItineraryModel(title: '第一周'),
      ItineraryModel(title: '第二周'),
      ItineraryModel(title: '第三周'),
      ItineraryModel(title: '第四周'),
      ItineraryModel(title: '第五周'),
    ];

    _summaries = [];
    _plans = [];
    _reports = [];
  }

  ///本月目标
  String _target;

  ///本月累计
  String _cumulative;

  ///本月实际
  String _actual;

  ///月度达成率
  double _achievementRate;

  ///下周规划进货金额
  String _nextTarget;

  ///本周区域重点工作总结
  List<String> _summaries;

  ///下月行程及工作内容
  List<ItineraryModel> _itineraries;

  ///重点工作内容
  List<String> _plans;

  ///问题反馈以及解决方案
  List<String> _reports;

  ///本月目标
  String get target => _target;

  ///本月累计
  String get cumulative => _cumulative;

  ///下月规划进货金额
  String get nextTarget => _nextTarget;

  ///下月行程及工作内容
  List<ItineraryModel> get itineraries => _itineraries;

  ///本月实际
  String get actual => _actual;

  ///月度达成率
  String get achievementRate => _achievementRate.toStringAsFixed(2);

  ///本周区域重点工作总结
  List<String> get summaries => _summaries;

  ///重点工作内容
  List<String> get plans => _plans;
  ///问题反馈以及解决方案
  List<String> get reports => _reports;

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
      _achievementRate *= 100; //换算成百分比
    } else {
      _achievementRate = 0.0;
    }
  }

  setActual(String actual) {
    _actual = actual;
    notifyListeners();
  }

  setNextTarget(String nextTarget) {
    _nextTarget = nextTarget;
    notifyListeners();
  }

  setSummaries(List<String> summaries) {
    if (_summaries == null) _summaries = [];
    _summaries.clear();
    _summaries.addAll(summaries);
    notifyListeners();
  }

  addSummary(String text) {
    if (_summaries == null) _summaries = [];
    _summaries.add(text);
    notifyListeners();
  }

  editSummariesWith(int index, String value) {
    if (_summaries == null) _summaries = [];
    if (index >= _summaries.length) return;
    _summaries.setAll(index, [value]);
    notifyListeners();
  }

  deleteSummariesWith(int index) {
    if (_summaries == null) _summaries = [];
    if (index >= _summaries.length) return;
    _summaries.removeAt(index);
    notifyListeners();
  }

  setPlans(List<String> plans) {
    if (_plans == null) _plans = [];
    _plans.clear();
    _plans.addAll(plans);
    notifyListeners();
  }

  addPlan(String text) {
    if (_plans == null) _plans = [];
    _plans.add(text);
    notifyListeners();
  }

  editPlanWith(int index, String value) {
    if (_plans == null) _plans = [];
    if (index >= _plans.length) return;
    _plans.setAll(index, [value]);
    notifyListeners();
  }

  deletePlanWith(int index) {
    if (_plans == null) _plans = [];
    if (index >= _plans.length) return;
    _plans.removeAt(index);
    notifyListeners();
  }


  setReports(List<String> reports) {
    if (_reports == null) _reports = [];
    _reports.clear();
    _reports.addAll(reports);
    notifyListeners();
  }

  addReport(String text) {
    if (_reports == null) _reports = [];
    _reports.add(text);
    notifyListeners();
  }

  editReportWith(int index, String value) {
    if (_reports == null) _reports = [];
    if (index >= _reports.length) return;
    _reports.setAll(index, [value]);
    notifyListeners();
  }

  deleteReportWith(int index) {
    if (_reports == null) _reports = [];
    if (index >= _reports.length) return;
    _reports.removeAt(index);
    notifyListeners();
  }

  setItineraryWorks(
      {@required ItineraryModel model, @required List<String> works}) {
    if (model.works == null) model.works = [];
    model.works.clear();
    model.works.addAll(works);
    notifyListeners();
  }

  addItineraryWorks({@required ItineraryModel model, @required String text}) {
    if (model.works == null) model.works = [];
    model.works.add(text);
    notifyListeners();
  }

  editItineraryWorksWith(
      {@required ItineraryModel model,
        @required int index,
        @required String value}) {
    if (model.works == null) model.works = [];
    if (index >= model.works.length) return;
    model.works.setAll(index, [value]);
    notifyListeners();
  }

  deleteItineraryWorksWith(
      {@required ItineraryModel model, @required int index}) {
    if (model.works == null) model.works = [];
    if (index >= model.works.length) return;
    model.works.removeAt(index);
    notifyListeners();
  }
}
