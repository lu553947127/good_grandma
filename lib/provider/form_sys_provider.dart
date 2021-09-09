import 'package:flutter/cupertino.dart';

class FormSysProvider with ChangeNotifier{

  ///动态列表
  List<Map> _formSys;

  ///动态列表
  List<Map> get formSys => _formSys;


  FormSysProvider() {
    _formSys = [];
  }

  ///添加item
  addForm(Map map){
    if(_formSys == null)
      _formSys = [];
    _formSys.add(map);
    notifyListeners();
  }

  ///编辑当前item
  editFormWith(int index, Map map){
    if(_formSys == null)
      _formSys = [];
    if(index >= _formSys.length) return;
    _formSys.setAll(index, [map]);
    notifyListeners();
  }

  ///删除单个item
  deleteFormWith(int index){
    if(_formSys == null)
      _formSys = [];
    if(index >= _formSys.length) return;
    _formSys.removeAt(index);
    notifyListeners();
  }
}