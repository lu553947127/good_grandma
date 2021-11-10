import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/week_post_add_new_model.dart';

class MonthPostAddNewModel extends ChangeNotifier {
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

    //本周区域重点工作总结
    _summaries = [];
    String summaries1 = map['summaries'] ?? '';
    _summaries = AppUtil.getListFromString(summaries1);

    //本周行程及工作内容
    _initItineraryList();
    List<dynamic> itinerariesS = map['itineraries'] ?? '';
    if (itinerariesS.isNotEmpty) {
      _itineraries.clear();
      itinerariesS.forEach((element) {
        String title = element['title'] ?? '';
        List<String> works = [];
        String summaries1 = map['works'] ?? '';
        works = AppUtil.getListFromString(summaries1);
        ItineraryModel model = ItineraryModel(title: title);
        model.works = works;
        _itineraries.add(model);
      });
    }

    //重点工作内容
    _plans = [];
    String worksS = map['plans'] ?? '';
    _plans = AppUtil.getListFromString(worksS);

    //问题反馈以及解决方案
    _reports = [];
    String reportsS = map['reports'] ?? '';
    _reports = AppUtil.getListFromString(reportsS);
    notifyListeners();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id ?? '';
    //时间
    data['time'] = _time ?? '';
    //销量进度追踪
    data['salesTrackingList'] = jsonEncode(_salesTrackingList.map((e) => e.toJson()).toList());
    //本周行程及工作内容
    data['itineraries'] = jsonEncode(_itineraries.map((e) => e.toJson()).toList());
    //区域重点工作总结
    data['summaries'] = jsonEncode(_summaries.map((e) => e.toString()).toList());
    //重点工作内容
    data['plans'] = jsonEncode(_plans.map((e) => e.toString()).toList());
    //问题反馈以及解决方案
    data['reports'] = jsonEncode(_reports.map((e) => e.toString()).toList());
    return data;
  }
  MonthPostAddNewModel() {
    position = '';
    area = '';
    id = '';
    _time = '';
    _salesTrackingList = [];
    _initItineraryList();

    _summaries = [];
    _plans = [];
    _reports = [];

    addToSalesTrackingList(SalesTrackingModel());
  }
  String position;
  String area;
  String id;
  ///时间-
  String _time;
  ///销量进度追踪
  List<SalesTrackingModel> _salesTrackingList;
  ///本周区域重点工作总结
  List<String> _summaries;
  ///下月行程及工作内容
  List<ItineraryModel> _itineraries;
  ///重点工作内容
  List<String> _plans;
  ///问题反馈以及解决方案
  List<String> _reports;

  ///时间
  String get time => _time;
  ///销量进度追踪
  List<SalesTrackingModel> get salesTrackingList => _salesTrackingList;
  ///本月目标
  double get target {
    if(_salesTrackingList.isEmpty) return 0;
    double ta = 0;
    _salesTrackingList.forEach((salesTracking) {
      ta += salesTracking.target;
    });
    return ta;
  }
  ///本月实际
  double get actual {
    if(_salesTrackingList.isEmpty) return 0;
    double ta = 0;
    _salesTrackingList.forEach((salesTracking) {
      ta += salesTracking.actual;
    });
    return ta;
  }
  ///本月累计
  double get cumulative {
    if(_salesTrackingList.isEmpty) return 0;
    double ta = 0;
    _salesTrackingList.forEach((salesTracking) {
      ta += salesTracking.cumulative;
    });
    return ta;
  }
  ///月度差额
  double get difference {
    if(_salesTrackingList.isEmpty) return 0;
    double ta = 0;
    _salesTrackingList.forEach((salesTracking) {
      ta += salesTracking.difference;
    });
    return ta;
  }
  ///月度达成率
  double get completionRate {
    if(_salesTrackingList.isEmpty) return 0;
    double ta = 0;
    _salesTrackingList.forEach((salesTracking) {
      ta += salesTracking.completionRate;
    });
    return ta;
  }
  ///下月规划进货金额
  double get nextTarget{
    if(_salesTrackingList.isEmpty) return 0;
    double ta = 0;
    _salesTrackingList.forEach((salesTracking) {
      ta += salesTracking.nextTarget;
    });
    return ta;
  }
  ///下月行程及工作内容
  List<ItineraryModel> get itineraries => _itineraries;
  ///本周区域重点工作总结
  List<String> get summaries => _summaries;

  ///重点工作内容
  List<String> get plans => _plans;
  ///问题反馈以及解决方案
  List<String> get reports => _reports;

  setTime(String time) {
    _time = time;
    notifyListeners();
  }
  setSalesTrackingList(List<SalesTrackingModel> salesTrackingList){
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
  _initItineraryList(){
    if (_itineraries == null)
      _itineraries = [
        ItineraryModel(title: '第一周'),
        ItineraryModel(title: '第二周'),
        ItineraryModel(title: '第三周'),
        ItineraryModel(title: '第四周'),
        ItineraryModel(title: '第五周'),
      ];
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
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['works'] = this.works.map((e) => e.toString()).toList();
    return data;
  }
}