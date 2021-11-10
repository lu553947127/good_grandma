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
}