import 'package:flutter/material.dart';

class WeekPostAddModel extends ChangeNotifier {
  WeekPostAddModel() {
    _target = '';
    _cumulative = '';
    _actual = '';
    _nextTarget = '';
    _achievementRate = 0.0;
    _itineraries = [
      ItineraryModel(title: '周一'),
      ItineraryModel(title: '周二'),
      ItineraryModel(title: '周三'),
      ItineraryModel(title: '周四'),
      ItineraryModel(title: '周五'),
      ItineraryModel(title: '周六'),
    ];
    _cities = [
      CityPlanModel(title: '周一'),
      CityPlanModel(title: '周二'),
      CityPlanModel(title: '周三'),
      CityPlanModel(title: '周四'),
      CityPlanModel(title: '周五'),
      CityPlanModel(title: '周六'),
    ];

    _summaries = [];
    _plans = [];
  }

  ///本月目标
  String _target;

  ///本月累计
  String _cumulative;

  ///本周实际
  String _actual;

  ///月度达成率
  double _achievementRate;

  ///下周规划进货金额
  String _nextTarget;

  ///本周行程及工作内容
  List<ItineraryModel> _itineraries;

  ///本周区域重点工作总结
  List<String> _summaries;

  ///城市列表
  List<CityPlanModel> _cities;

  ///下周工作内容
  List<String> _plans;

  ///本月目标
  String get target => _target;

  ///本月累计
  String get cumulative => _cumulative;

  ///下周规划进货金额
  String get nextTarget => _nextTarget;

  ///本周行程及工作内容
  List<ItineraryModel> get itineraries => _itineraries;

  ///本周实际
  String get actual => _actual;

  ///月度达成率
  String get achievementRate => _achievementRate.toStringAsFixed(2);

  ///本周区域重点工作总结
  List<String> get summaries => _summaries;

  ///城市列表
  List<CityPlanModel> get cities => _cities;

  ///下周工作内容
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

  setCities(List<CityPlanModel> cities) {
    if (_cities == null) _cities = [];
    _cities.clear();
    _cities.addAll([
      CityPlanModel(title: '周一'),
      CityPlanModel(title: '周二'),
      CityPlanModel(title: '周三'),
      CityPlanModel(title: '周四'),
      CityPlanModel(title: '周五'),
      CityPlanModel(title: '周六'),
    ]);
    notifyListeners();
  }

  editCityWith({int index, String city,List<int> selectedIndexes,List<String> selectedNames}) {
    if (_cities == null)
      _cities = [
        CityPlanModel(title: '周一'),
        CityPlanModel(title: '周二'),
        CityPlanModel(title: '周三'),
        CityPlanModel(title: '周四'),
        CityPlanModel(title: '周五'),
        CityPlanModel(title: '周六'),
      ];
    if (index >= _cities.length) return;
    CityPlanModel model = _cities[index];
    model.city = city;
    model.selectedIndexes = selectedIndexes;
    model.selectedNames = selectedNames;
    notifyListeners();
  }

  deleteCityWith(int index) {
    if (_cities == null)
      _cities = [
        CityPlanModel(title: '周一'),
        CityPlanModel(title: '周二'),
        CityPlanModel(title: '周三'),
        CityPlanModel(title: '周四'),
        CityPlanModel(title: '周五'),
        CityPlanModel(title: '周六'),
      ];
    if (index >= _cities.length) return;
    CityPlanModel model = _cities[index];
    model.city = '';
    model.selectedIndexes = [];
    model.selectedNames = [];
    notifyListeners();
  }

  bool _cityCheck(int index) {
    if (_cities == null)
      _cities = [
        CityPlanModel(title: '周一'),
        CityPlanModel(title: '周二'),
        CityPlanModel(title: '周三'),
        CityPlanModel(title: '周四'),
        CityPlanModel(title: '周五'),
        CityPlanModel(title: '周六'),
      ];
    if (index >= _cities.length) return false;
    return true;
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

///行程
class ItineraryModel {
  String title;
  String tempWork;
  List<String> works;
  ItineraryModel({this.title = '', this.tempWork = ''}) {
    works = [];
  }
}

///城市
class CityPlanModel {
  ///WEEK
  String title;
  String city;
  List<int> selectedIndexes;
  List<String> selectedNames;
  CityPlanModel({this.title = '', this.city = ''}) {
    selectedIndexes = [];
    selectedNames = [];
  }
}
