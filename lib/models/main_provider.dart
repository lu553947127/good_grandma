import 'package:flutter/cupertino.dart';

///全局的provider
class MainProvider extends ChangeNotifier {

  ///审批神器待办角标
  int _badge;

  MainProvider() {
    _badge = 0;
  }

  ///审批神器待办角标
  int get badge => _badge;

  setBadge(int badge) {
    _badge = badge;
    notifyListeners();
  }
}