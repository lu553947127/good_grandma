import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/utils.dart';

class WeekPostAddNewModel extends ChangeNotifier {
  void fromJson(Map<String, dynamic> map) {
    id = map['id'] ?? '';
    area = map['postName'] ?? '';
    position = area;
    _time = map['time'] ?? '';
    //销量进度追踪（万元）
    _salesTrackingList = [];
    String salesTrackingListS = map['salesTrackingList'] ?? '';
    if (salesTrackingListS.isNotEmpty) {
      List list = jsonDecode(salesTrackingListS);
      // print('list = $list');
      list.forEach((map) {
        SalesTrackingModel model = SalesTrackingModel.fromJson(map);
        _salesTrackingList.add(model);
      });
    }

    //目标达成说明
    //服务器返回数据弄混了summaries和targetDesc
    _targetDesc = map['summaries'] ?? '';

    //本周区域重点工作总结
    _summaries = [];
    String summaries1 = map['targetDesc'] ?? '';
    _summaries = AppUtil.getListFromString(summaries1);

    //本周行程及工作内容
    _initItineraryList();
    List<dynamic> itinerariesS = map['itineraries'] ?? '';
    if (itinerariesS.isNotEmpty) {
      _itineraries.clear();
      itinerariesS.forEach((element) {
        String title = element['title'] ?? '';
        String lastCityName = element['lastCityId'] ?? '';
        String actualCityName = element['actualCityId'] ?? '';
        String work = element['work'] ?? '';
        ItineraryNewModel model = ItineraryNewModel(title: title, work: work);
        model.actualCity = CityPlanModel(city: actualCityName);
        model.lastCity = CityPlanModel(city: lastCityName);
        _itineraries.add(model);
      });
    }

    //下周行程
    _initCities();
    List<dynamic> citiesS = map['cities'] ?? '';
    if(citiesS.isNotEmpty){
      _cities.clear();
      citiesS.forEach((element) {
        String title = element['title'] ?? '';
        String cityName = element['id'] ?? '';
        _cities.add(CityPlanModel(title: title,city: cityName));
      });
    }

    //重点工作内容
    _plans = [];
    String worksS = map['plans'] ?? '';
    _plans = AppUtil.getListFromString(worksS);
    notifyListeners();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id ?? '';
    //时间
    data['time'] = _time ?? '';
    //目标达成说明
    data['targetDesc'] = _targetDesc ?? '';
    //销量进度追踪
    data['salesTrackingList'] =
        jsonEncode(_salesTrackingList.map((e) => e.toJson()).toList());
    //本周行程及工作内容
    data['itineraries'] =
        jsonEncode(_itineraries.map((e) => e.toJson()).toList());
    //本周区域重点工作总结
    data['summaries'] =
        jsonEncode(_summaries.map((e) => e.toString()).toList());
    //下周行程
    data['cities'] = jsonEncode(_cities.map((e) => e.toJson()).toList());
    //重点工作内容
    data['plans'] = jsonEncode(_plans.map((e) => e.toString()).toList());
    return data;
  }

  String position;
  String area;
  String id;

  ///时间
  String _time;

  ///销量进度追踪
  List<SalesTrackingModel> _salesTrackingList;

  ///目标达成说明
  String _targetDesc;

  /// 本周行程及工作内容
  List<ItineraryNewModel> _itineraries;

  ///本周区域重点工作总结
  List<String> _summaries;

  ///下周行程城市列表
  List<CityPlanModel> _cities;

  ///下周工作内容
  List<String> _plans;

  ///时间
  String get time => _time;

  ///销量进度追踪
  List<SalesTrackingModel> get salesTrackingList => _salesTrackingList;

  ///本周目标
  double get target {
    if (_salesTrackingList.isEmpty) return 0;
    double ta = 0;
    _salesTrackingList.forEach((salesTracking) {
      ta += salesTracking.target;
    });
    return ta;
  }

  ///本月实际
  double get actual {
    if (_salesTrackingList.isEmpty) return 0;
    double ta = 0;
    _salesTrackingList.forEach((salesTracking) {
      ta += salesTracking.actual;
    });
    return ta;
  }

  ///本月累计
  double get cumulative {
    if (_salesTrackingList.isEmpty) return 0;
    double ta = 0;
    _salesTrackingList.forEach((salesTracking) {
      ta += salesTracking.cumulative;
    });
    return ta;
  }

  ///月度差额
  double get difference {
    if (_salesTrackingList.isEmpty) return 0;
    double ta = 0;
    _salesTrackingList.forEach((salesTracking) {
      ta += salesTracking.difference;
    });
    return ta;
  }

  ///月度达成率
  double get completionRate {
    if (_salesTrackingList.isEmpty) return 0;
    double ta = 0;
    _salesTrackingList.forEach((salesTracking) {
      ta += salesTracking.completionRate;
    });
    return ta;
  }

  ///下月规划进货金额
  double get nextTarget {
    if (_salesTrackingList.isEmpty) return 0;
    double ta = 0;
    _salesTrackingList.forEach((salesTracking) {
      ta += salesTracking.nextTarget;
    });
    return ta;
  }

  ///目标达成说明
  String get targetDesc => _targetDesc;

  /// 本周行程及工作内容
  List<ItineraryNewModel> get itineraries => _itineraries;

  ///本周区域重点工作总结
  List<String> get summaries => _summaries;

  ///下周行程城市列表
  List<CityPlanModel> get cities => _cities;

  ///下周工作内容
  List<String> get plans => _plans;

  WeekPostAddNewModel() {
    id = '';
    position = '';
    area = '';
    _time = '';
    _salesTrackingList = [];
    _targetDesc = '';
    _initItineraryList();
    _summaries = [];
    _initCities();
    _plans = [];
  }

  setTime(String time) {
    _time = time;
    notifyListeners();
  }

  setTargetDesc(String targetDesc) {
    _targetDesc = targetDesc;
    notifyListeners();
  }

  setSalesTrackingList(List<SalesTrackingModel> salesTrackingList) {
    if (_salesTrackingList == null) _salesTrackingList = [];
    _salesTrackingList.clear();
    _salesTrackingList.addAll(salesTrackingList);
    notifyListeners();
  }

  addToSalesTrackingList(SalesTrackingModel model) {
    if (_salesTrackingList == null) _salesTrackingList = [];
    _salesTrackingList.add(model);
    notifyListeners();
  }

  editSalesTrackingListWith(int index, SalesTrackingModel model) {
    if (_salesTrackingList == null) _salesTrackingList = [];
    if (index >= _salesTrackingList.length) return;
    _salesTrackingList.setAll(index, [model]);
    notifyListeners();
  }

  deleteSalesTrackingListWith(int index) {
    if (_salesTrackingList == null) _salesTrackingList = [];
    if (index >= _salesTrackingList.length) return;
    _salesTrackingList.removeAt(index);
    notifyListeners();
  }

  _initItineraryList() {
    if (_itineraries == null)
      _itineraries = [
        ItineraryNewModel(title: '周一'),
        ItineraryNewModel(title: '周二'),
        ItineraryNewModel(title: '周三'),
        ItineraryNewModel(title: '周四'),
        ItineraryNewModel(title: '周五'),
        ItineraryNewModel(title: '周六'),
      ];
  }

  setItineraries(List<ItineraryNewModel> itineraries) {
    if (_itineraries == null) _itineraries = [];
    _itineraries.clear();
    _itineraries.addAll(itineraries);
    notifyListeners();
  }

  editItineraryNewModelWith(ItineraryNewModel model, int index) {
    _initItineraryList();
    if (index >= _itineraries.length) return;
    _itineraries.setAll(index, [model]);
    notifyListeners();
  }

  deleteItineraryWorksWith(ItineraryNewModel model, int index) {
    _initItineraryList();
    if (index >= _itineraries.length) return;
    _itineraries.removeAt(index);
    notifyListeners();
  }

  setStringArrays(
    List<String> array,
    List<String> values,
  ) {
    if (array == null) array = [];
    array.clear();
    array.addAll(values);
    notifyListeners();
  }

  addToStringArray(List<String> array, String text) {
    if (array == null) array = [];
    array.add(text);
    notifyListeners();
  }

  editStringArrayWith(List<String> array, int index, String value) {
    if (array == null) array = [];
    if (index >= array.length) return;
    array.setAll(index, [value]);
    notifyListeners();
  }

  deleteStringArrayWith(List<String> array, int index) {
    if (array == null) array = [];
    if (index >= array.length) return;
    array.removeAt(index);
    notifyListeners();
  }

  setCities(List<CityPlanModel> cities) {
    if (_cities == null) _cities = [];
    _cities.clear();
    _cities.addAll(cities);
    notifyListeners();
  }

  editCityWith(
      {int index,
      String city,
      String cityId,
      List<int> selectedIndexes,
      List<String> selectedNames}) {
    _initCities();
    if (index >= _cities.length) return;
    CityPlanModel model = _cities[index];
    model.city = city;
    model.cityId = cityId;
    model.selectedIndexes = selectedIndexes;
    model.selectedNames = selectedNames;
    notifyListeners();
  }

  deleteCityWith(int index) {
    _initCities();
    if (index >= _cities.length) return;
    CityPlanModel model = _cities[index];
    model.city = '';
    model.cityId = '';
    model.selectedIndexes = [];
    model.selectedNames = [];
    notifyListeners();
  }

  void _initCities() {
    if (_cities == null)
      _cities = [
        CityPlanModel(title: '周一'),
        CityPlanModel(title: '周二'),
        CityPlanModel(title: '周三'),
        CityPlanModel(title: '周四'),
        CityPlanModel(title: '周五'),
        CityPlanModel(title: '周六'),
      ];
  }
}

///行程
class ItineraryNewModel {
  String title;
  CityPlanModel lastCity;
  CityPlanModel actualCity;
  String work;
  ItineraryNewModel({this.title = '', this.work = ''}) {
    lastCity = CityPlanModel();
    actualCity = CityPlanModel();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title ?? '';
    // data['lastCityId'] = this.lastCity.cityId;
    data['lastCityId'] = this.lastCity.city;
    data['lastCityName'] = this.lastCity.city;
    data['actualCityId'] = this.actualCity.cityId;
    // data['actualCityId'] = this.actualCity.city;
    data['actualCityName'] = this.actualCity.city;
    data['work'] = this.work ?? '';
    return data;
  }
}

class SalesTrackingModel {
  ///区域 省份id
  CityPlanModel area;

  ///本月目标
  double target;

  ///本月实际
  double actual;

  ///本月累计
  double cumulative;

  ///月度差额
  double difference;

  ///月度达成率
  double completionRate;

  ///下月规划进货金额
  double nextTarget;

  SalesTrackingModel(
      {this.target = 0,
      this.actual = 0,
      this.cumulative = 0,
      this.difference = 0,
      this.completionRate = 0,
      this.nextTarget = 0}) {
    this.area = CityPlanModel();
  }
  SalesTrackingModel.fromJson(Map<String, dynamic> json) {
    String cityId = json['area'].toString() ?? '';
    String areaName = json['areaName'] ?? '';
    area = CityPlanModel(cityId: cityId,city: areaName);
    target = json['targe'] ?? 0;
    actual = json['actual'] ?? 0;
    cumulative = json['cumulative'] ?? 0;
    difference = json['difference'] ?? 0;
    completionRate = json['completionRate'] ?? 0;
    nextTarget = json['nextTarget'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['area'] = this.area.cityId ?? '';
    data['areaName'] = this.area.city ?? '';
    data['target'] = this.target ?? 0;
    data['actual'] = this.actual ?? 0;
    data['cumulative'] = this.cumulative ?? 0;
    data['difference'] = this.difference ?? 0;
    data['completionRate'] = this.completionRate ?? 0;
    data['nextTarget'] = this.nextTarget ?? 0;
    return data;
  }
}

///城市
class CityPlanModel {
  ///WEEK
  String title;
  String city;
  String cityId;
  List<int> selectedIndexes;
  List<String> selectedNames;
  CityPlanModel({this.title = '', this.city = '', this.cityId = ''}) {
    selectedIndexes = [];
    selectedNames = [];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title ?? '';
    // data['id'] = this.cityId ?? '';
    data['id'] = this.city ?? '';
    data['name'] = this.city ?? '';
    return data;
  }
}
