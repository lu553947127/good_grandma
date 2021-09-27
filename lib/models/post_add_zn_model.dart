import 'dart:convert';

import 'package:flutter/material.dart';

class PostAddZNModel extends ChangeNotifier {
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    //工作内容
    data['currentWorks'] = jsonEncode(_currentWorks.map((e) => e.toString()).toList());
    //工作中存在的问题及需改进的方面
    data['problems'] = jsonEncode(_problems.map((e) => e.toString()).toList());
    //工作计划
    data['plans'] = jsonEncode(_plans.map((e) => e.toString()).toList());
    //建议
    data['suggests'] = jsonEncode(_suggests.map((e) => e.toString()).toList());
    return data;
  }

  PostAddZNModel() {
    _currentWorks = [];
    _problems = [];
    _plans = [];
    _suggests = [];
  }

  ///工作内容
  List<String> _currentWorks;

  ///工作中存在的问题及需改进的方面
  List<String> _problems;

  ///工作计划
  List<String> _plans;

  ///建议
  List<String> _suggests;

  ///工作内容
  List<String> get currentWorks => _currentWorks;

  ///工作中存在的问题及需改进的方面
  List<String> get problems => _problems;

  ///工作计划
  List<String> get plans => _plans;

  ///建议
  List<String> get suggests => _suggests;

  setArrays(
    List<String> array,
    List<String> values,
  ) {
    if (array == null) array = [];
    array.clear();
    array.addAll(values);
    notifyListeners();
  }

  addToArray(List<String> array, String text) {
    if (array == null) array = [];
    array.add(text);
    notifyListeners();
  }

  editArrayWith(List<String> array, int index, String value) {
    if (array == null) array = [];
    if (index >= array.length) return;
    array.setAll(index, [value]);
    notifyListeners();
  }

  deleteArrayWith(List<String> array, int index) {
    if (array == null) array = [];
    if (index >= array.length) return;
    array.removeAt(index);
    notifyListeners();
  }
}
