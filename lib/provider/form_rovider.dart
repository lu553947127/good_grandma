import 'package:flutter/cupertino.dart';
import 'package:good_grandma/common/log.dart';

class FormProvider with ChangeNotifier{

  ///动态列表
  List<FormModel> _form;

  ///动态列表
  List<FormModel> get form => _form;

  List<Map> mapList;

  double heji = 0.0;

  FormProvider() {
    _form = [];
    mapList = [];
  }

  ///添加item
  addForm(FormModel formModel){
    if(_form == null)
      _form = [];
    _form.add(formModel);

    Map addData = new Map();
    addData['danweimingcheng'] = formModel.danweimingcheng;
    addData['zhanghao'] = formModel.zhanghao;
    addData['kaihuhangmingcheng'] = formModel.kaihuhangmingcheng;
    addData['jine'] = formModel.jine;
    addData['zhifufangshi'] = formModel.zhifufangshi;
    addData['yujizhifushijian'] = formModel.yujizhifushijian;

    mapList.add(addData);

    print('mapList------------$mapList');
    notifyListeners();
  }

  ///编辑当前item
  editFormWith(int index, FormModel formModel){
    if(_form == null)
      _form = [];
    if(index >= _form.length) return;
    _form.setAll(index, [formModel]);

    Map addData = new Map();
    addData['danweimingcheng'] = formModel.danweimingcheng;
    addData['zhanghao'] = formModel.zhanghao;
    addData['kaihuhangmingcheng'] = formModel.kaihuhangmingcheng;
    addData['jine'] = formModel.jine;
    addData['zhifufangshi'] = formModel.zhifufangshi;
    addData['yujizhifushijian'] = formModel.yujizhifushijian;

    mapList.setAll(index, [addData]);

    print('addData------------$addData');
    print('mapList------------$mapList');
    // for (Map map in mapList) {
    //   heji += double.parse(map['jine']);
    // }
    //
    // LogUtil.d('heji----$heji');

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
class FormModel {

  ///单位名称
  String danweimingcheng;

  ///账号
  String zhanghao;

  ///开户行名称
  String kaihuhangmingcheng;

  ///金额
  String jine;

  ///支付方式
  String zhifufangshi;

  ///预计支付时间
  String yujizhifushijian;

  FormModel({
    this.danweimingcheng = '',
    this.zhanghao = '',
    this.kaihuhangmingcheng = '',
    this.jine = '',
    this.zhifufangshi = '',
    this.yujizhifushijian = ''
  });

}