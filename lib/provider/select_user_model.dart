import 'package:flutter/cupertino.dart';

///多选选择模型
class SelectUserModel with ChangeNotifier{

  List<UserModel> _userList = [];

  List<UserModel> get userList => _userList;

  SelectUserModel(type){
    _userList = [];
  }


}

///用户模型
class UserModel {

  String name;

  String id;
  bool isSelected;

  UserModel({
    this.name = '',
    this.id = '',
    this.isSelected = false
  });
}