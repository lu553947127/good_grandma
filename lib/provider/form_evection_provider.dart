import 'package:flutter/cupertino.dart';

class FormEvectionProvider with ChangeNotifier{

  ///动态列表
  List<FormEvectionModel> _form;

  ///动态列表
  List<FormEvectionModel> get form => _form;

  List<Map> mapList;

  FormEvectionProvider() {
    _form = [];
    mapList = [];
  }

  ///添加item
  addForm(FormEvectionModel formModel){
    if(_form == null)
      _form = [];
    _form.add(formModel);

    Map addData = new Map();

    List<String> timeList = [];
    timeList.add(formModel.start_time);
    timeList.add(formModel.end_time);

    addData['qizhishijian'] = timeList;
    addData['days'] = formModel.hejitianshu;
    addData['qizhididian'] = formModel.qizhididian;
    addData['chuchaimudi'] = formModel.chuchaimudi;
    addData['jiaotongjine'] = formModel.jiaotongjine;
    addData['shineijiaotong'] = formModel.shineijiaotong;
    addData['zhusujine'] = formModel.zhusujine;
    addData['buzhujine'] = formModel.buzhujine;
    addData['beizhu'] = formModel.beizhu;

    mapList.add(addData);

    print('mapList------------$mapList');
    notifyListeners();
  }

  ///编辑当前item
  editFormWith(int index, FormEvectionModel formModel){
    if(_form == null)
      _form = [];
    if(index >= _form.length) return;
    _form.setAll(index, [formModel]);

    Map addData = new Map();

    List<String> timeList = [];
    timeList.add(formModel.start_time);
    timeList.add(formModel.end_time);

    addData['qizhishijian'] = timeList;
    addData['days'] = formModel.hejitianshu;
    addData['qizhididian'] = formModel.qizhididian;
    addData['chuchaimudi'] = formModel.chuchaimudi;
    addData['jiaotongjine'] = formModel.jiaotongjine;
    addData['shineijiaotong'] = formModel.shineijiaotong;
    addData['zhusujine'] = formModel.zhusujine;
    addData['buzhujine'] = formModel.buzhujine;
    addData['beizhu'] = formModel.beizhu;

    mapList.setAll(index, [addData]);

    print('addData------------$addData');
    print('mapList------------$mapList');

    notifyListeners();
  }

  ///删除单个item
  deleteFormWith(int index){
    if(_form == null)
      _form = [];
    if(index >= _form.length) return;
    _form.removeAt(index);
    mapList.removeAt(index);
    print('mapList------------$mapList');
    notifyListeners();
  }
}

///核销模型
class FormEvectionModel {

  ///起止时间
  String start_time;
  String end_time;

  ///合计天数
  String hejitianshu;

  ///起止地点
  String qizhididian;

  ///出差目的
  String chuchaimudi;

  ///交通金额
  String jiaotongjine;

  ///市内交通
  String shineijiaotong;

  ///市内交通
  String zhusujine;

  ///补助金额
  String buzhujine;

  ///备注
  String beizhu;

  FormEvectionModel({
    this.start_time = '',
    this.end_time = '',
    this.hejitianshu = '0',
    this.qizhididian = '',
    this.chuchaimudi = '',
    this.jiaotongjine = '',
    this.shineijiaotong = '',
    this.zhusujine = '',
    this.buzhujine = '',
    this.beizhu = ''
  });
}