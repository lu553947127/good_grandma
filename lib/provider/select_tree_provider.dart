import 'package:flutter/cupertino.dart';
import 'package:good_grandma/common/store.dart';

///树状选择
class SelectTreeProvider with ChangeNotifier{

  ///横向集合
  List<Map> horizontalList = [];

  SelectTreeProvider(type){
    if (type == 'oa'){
      addExamine('0', '全部');
    }else{
      addData(
          type == '全国' ? '1123598813738675201' : Store.readDeptId(),
          type == '全国' ? '全国' : Store.readDeptName(),
          0
      );
    }
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

  addExamine(id, name){
    Map addData = new Map();
    addData['id'] = id;
    addData['name'] = name;
    horizontalList.add(addData);
    notifyListeners();
  }

  addExamineChild(id, name) async{
    horizontalList.clear();
    Map addData = new Map();
    addData['id'] = id;
    addData['name'] = name;
    horizontalList.add(addData);
    notifyListeners();
  }
}