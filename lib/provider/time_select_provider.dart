import 'package:flutter/cupertino.dart';

class TimeSelectProvider with ChangeNotifier{
  ///开始时间
  String startTime ='';

  ///结束时间
  String endTime = '';

  String dayNumber = '0';

  ///普通选择value
  String select = '';

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
}