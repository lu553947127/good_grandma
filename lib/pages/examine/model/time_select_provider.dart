import 'package:flutter/cupertino.dart';

class TimeSelectProvider with ChangeNotifier{
  ///开始时间
  String startTime ='';

  ///结束时间
  String endTime = '';

  String dayNumber = '0';

  ///普通选择value
  String select = '';

  String value = '';
  List<String> valueList = [];

  String shenqingren = '';

  String chufadi = '';

  String mudidi = '';

  String chuchaishiyou = '';

  String xingchenganpai = '';

  String yujidachengxiaoguo = '';

  ///添加
  addStartTime(start_time, end_time, day_number) {
    startTime = start_time;
    endTime = end_time;
    dayNumber = day_number;
    notifyListeners();
  }

  addshenqingren(str){
    shenqingren = str;
    notifyListeners();
  }

  addValue(str){
    select = str;
    notifyListeners();
  }

  addValue2(str){
    value = str;
    valueList.add(value);
    notifyListeners();
  }

  addchufadi(str){
    chufadi = str;
    notifyListeners();
  }

  addmudidi(str){
    mudidi = str;
    notifyListeners();
  }

  addchuchaishiyou(str){
    chuchaishiyou = str;
    notifyListeners();
  }

  addxingchenganpai(str){
    xingchenganpai = str;
    notifyListeners();
  }

  addyujidachengxiaoguo(str){
    yujidachengxiaoguo = str;
    notifyListeners();
  }

  ///动态列表
  List<TravelModel> _travelScheduleList;

  ///动态列表
  List<TravelModel> get travelScheduleList => _travelScheduleList;

  ///动态列表
  List<Map> travelScheduleMapList;

  TimeSelectProvider() {
    _travelScheduleList = [];
    travelScheduleMapList = [];
  }

  ///添加item
  addForm(TravelModel model){
    if(_travelScheduleList == null)
      _travelScheduleList = [];
    _travelScheduleList.add(model);
    Map addData = new Map();
    addData['chufadi'] = model.chufadi;
    addData['mudidi'] = model.mudidi;
    addData['yujichuchairiqi'] = model.yujichuchairiqi;
    addData['days'] = model.days;
    travelScheduleMapList.add(addData);
    notifyListeners();
  }

  ///编辑当前item
  editFormWith(int index, TravelModel model){
    if(_travelScheduleList == null)
      _travelScheduleList = [];
    if(index >= _travelScheduleList.length) return;
    _travelScheduleList.setAll(index, [model]);
    Map addData = new Map();
    addData['chufadi'] = model.chufadi;
    addData['mudidi'] = model.mudidi;
    addData['yujichuchairiqi'] = model.yujichuchairiqi;
    addData['days'] = model.days;
    travelScheduleMapList.setAll(index, [addData]);
    notifyListeners();
  }

  ///删除单个item
  deleteFormWith(int index){
    if(_travelScheduleList == null)
      _travelScheduleList = [];
    if(index >= _travelScheduleList.length) return;
    _travelScheduleList.removeAt(index);
    travelScheduleMapList.removeAt(index);
    notifyListeners();
  }
}

///出差日程模型
class TravelModel {

  ///出发地
  String chufadi;

  ///目的地
  String mudidi;

  ///预计出差日期
  String yujichuchairiqi;

  ///出差天数
  String days;

  TravelModel({
    this.chufadi = '',
    this.mudidi = '',
    this.yujichuchairiqi = '',
    this.days = ''
  });
}