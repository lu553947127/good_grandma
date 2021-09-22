import 'package:flutter/cupertino.dart';

///树状选择
class SelectTreeProvider with ChangeNotifier{

  ///横向集合
  List<Map> horizontalList = [];

  SelectTreeProvider(){
    addData('1123598813738675201', '全国', 0);
  }

  //生成接口添加的数据
  addData(id, name, deptCategory) async{
    Map addData = new Map();
    addData['id'] = id;
    addData['name'] = name;
    addData['deptCategory'] = deptCategory;
    horizontalList.add(addData);
    notifyListeners();
  }

  //刷新全国数据
  addDataChild(id, name, deptCategory) async{
    horizontalList.clear();
    Map addData = new Map();
    addData['id'] = id;
    addData['name'] = name;
    addData['deptCategory'] = deptCategory;
    horizontalList.add(addData);
    notifyListeners();
  }

  //选择集合删除
  horizontalListDelete(int index) async{
    if(horizontalList.length > 0){
      horizontalList.removeAt(index);
      notifyListeners();
    }
  }
}