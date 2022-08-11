import 'package:flutter/cupertino.dart';

///全局的provider
class MainProvider extends ChangeNotifier {

  ///审批神器待办角标
  int _badge;
  ///一级订单待审核数量
  int _countOne;
  ///直营订单待审核数量
  int _countZy;
  ///装车率审核待审核数量
  int _countZc;
  ///物料订单待审核数量
  int _countWl;
  ///冰柜订单待审核数量
  int _countBg;

  MainProvider() {
    _badge = 0;
    _countOne = 0;
    _countZy = 0;
    _countZc = 0;
    _countWl = 0;
    _countBg = 0;
  }

  ///审批神器待办角标
  int get badge => _badge;
  ///一级订单待审核数量
  int get countOne => _countOne;
  ///直营订单待审核数量
  int get countZy => _countZy;
  ///装车率审核待审核数量
  int get countZc => _countZc;
  ///物料订单待审核数量
  int get countWl => _countWl;
  ///冰柜订单待审核数量
  int get countBg => _countBg;

  setBadge(int badge) {
    _badge = badge;
    notifyListeners();
  }

  setCountOne(int countOne) {
    _countOne = countOne;
    notifyListeners();
  }

  setCountZy(int countZy) {
    _countZy = countZy;
    notifyListeners();
  }

  setCountZc(int countZc) {
    _countZc = countZc;
    notifyListeners();
  }

  setCountWl(int countWl) {
    _countWl = countWl;
    notifyListeners();
  }

  setCountBg(int countBg) {
    _countBg = countBg;
    notifyListeners();
  }
}