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

  String bumen = '';

  String bumenName = '';

  String gongsi = '';

  String zhuzhi = '';

  String shuoming = '';

  String purpose = '';

  String desc = '';

  String money = '';

  String feiyongshenqing = '';

  String fylb = '';

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

  addbumen(str, str2){
    bumen = str;
    bumenName = str2;
    notifyListeners();
  }

  addgongsi(str){
    gongsi = str;
    notifyListeners();
  }

  addzhuzhi(str){
    zhuzhi = str;
    notifyListeners();
  }

  addshuoming(str){
    shuoming = str;
    notifyListeners();
  }

  addpurpose(str){
    purpose = str;
    notifyListeners();
  }

  adddesc(str){
    desc = str;
    notifyListeners();
  }

  addmoney(str){
    money = str;
    notifyListeners();
  }

  addfeiyongshenqing(str){
    feiyongshenqing = str;
    notifyListeners();
  }

  addfylb(str){
    fylb = str;
    notifyListeners();
  }

  /**
   * 上传附件
   */
  ///图片地址
  var imgPath;
  ///文件地址结合
  List<Map> filePath = [];
  ///map图片集合
  List<Map> imagePath = [];
  ///图片url集合
  List<String> urlList = [];

  //选择附件图片集合
  fileList(String image, String type, String iconName) async{
    Map addData = new Map();
    addData['image'] = image;
    addData['type'] = type;
    addData['iconName'] = iconName;
    filePath.add(addData);
    notifyListeners();
  }

  //生成接口添加的数据
  addImageData(images, name) async{
    Map addData = new Map();
    addData['label'] = name;
    addData['value'] = images;
    imagePath.add(addData);
    urlList.add(images);
    notifyListeners();
  }

  //选择图片集合删除
  imagesListDelete(int index) async{
    if(filePath.length > 0){
      filePath.removeAt(index);
      imagePath.removeAt(index);
      urlList.removeAt(index);
      notifyListeners();
    }
  }

  TimeSelectProvider() {
    _travelScheduleList = [];
    travelScheduleMapList = [];
    _zhifuduixiangxinxiList = [];
    zhifuduixiangxinxiMapList = [];
  }

  /**
   * 出差日程动态表单
   */
  ///动态列表
  List<TravelModel> _travelScheduleList;

  ///动态列表
  List<TravelModel> get travelScheduleList => _travelScheduleList;

  ///动态列表
  List<Map> travelScheduleMapList;

  ///添加item
  addForm(TravelModel model){
    if(_travelScheduleList == null)
      _travelScheduleList = [];
    _travelScheduleList.add(model);

    List<String> timeList = [];
    timeList.add(model.startTime + ':00');
    timeList.add(model.endTime + ':00');

    Map addData = new Map();
    addData['chufadi'] = model.chufadi;
    addData['mudidi'] = model.mudidi;
    addData['yujichuchairiqi'] = timeList;
    addData['days'] = model.days;
    travelScheduleMapList.add(addData);
    notifyListeners();
  }

  ///编辑当前item
  editFormWith(int index, TravelModel model){
    if(_travelScheduleList == null)
      _travelScheduleList = [];
    if(index >= _travelScheduleList.length) return;
    _travelScheduleList.setAll(index, [model]);

    List<String> timeList = [];
    timeList.add(model.startTime + ':00');
    timeList.add(model.endTime + ':00');

    Map addData = new Map();
    addData['chufadi'] = model.chufadi;
    addData['mudidi'] = model.mudidi;
    addData['yujichuchairiqi'] = timeList;
    addData['days'] = model.days;
    travelScheduleMapList.setAll(index, [addData]);
    notifyListeners();
  }

  ///删除单个item
  deleteFormWith(int index){
    if(_travelScheduleList == null)
      _travelScheduleList = [];
    if(index >= _travelScheduleList.length) return;
    _travelScheduleList.removeAt(index);
    travelScheduleMapList.removeAt(index);
    notifyListeners();
  }


/**
 * 支付对象信息动态表单
 */

  ///动态列表
  List<FormModel> _zhifuduixiangxinxiList;

  ///动态列表
  List<FormModel> get zhifuduixiangxinxiList => _zhifuduixiangxinxiList;

  List<Map> zhifuduixiangxinxiMapList;

  ///添加item
  addzhifuduixiangForm(FormModel formModel){
    if(_zhifuduixiangxinxiList == null)
      _zhifuduixiangxinxiList = [];
    _zhifuduixiangxinxiList.add(formModel);
    Map addData = new Map();
    addData['danweimingcheng'] = formModel.danweimingcheng;
    addData['zhanghao'] = formModel.zhanghao;
    addData['kaihuhangmingcheng'] = formModel.kaihuhangmingcheng;
    addData['jine'] = formModel.jine;
    addData['zhifufangshi'] = formModel.zhifufangshi;
    addData['beizhu'] = formModel.beizhu;
    zhifuduixiangxinxiMapList.add(addData);
    notifyListeners();
  }

  ///编辑当前item
  editzhifuduixiangFormWith(int index, FormModel formModel){
    if(_zhifuduixiangxinxiList == null)
      _zhifuduixiangxinxiList = [];
    if(index >= _zhifuduixiangxinxiList.length) return;
    _zhifuduixiangxinxiList.setAll(index, [formModel]);
    Map addData = new Map();
    addData['danweimingcheng'] = formModel.danweimingcheng;
    addData['zhanghao'] = formModel.zhanghao;
    addData['kaihuhangmingcheng'] = formModel.kaihuhangmingcheng;
    addData['jine'] = formModel.jine;
    addData['zhifufangshi'] = formModel.zhifufangshi;
    addData['beizhu'] = formModel.beizhu;
    zhifuduixiangxinxiMapList.setAll(index, [addData]);
    notifyListeners();
  }

  ///删除单个item
  deletezhifuduixiangFormWith(int index){
    if(_zhifuduixiangxinxiList == null)
      _zhifuduixiangxinxiList = [];
    if(index >= _zhifuduixiangxinxiList.length) return;
    _zhifuduixiangxinxiList.removeAt(index);
    zhifuduixiangxinxiMapList.removeAt(index);
    notifyListeners();
  }
}

///出差日程模型
class TravelModel {

  ///出发地
  String chufadi;

  ///目的地
  String mudidi;


  ///预计出差日期开始时间
  String startTime;

  ///预计出差日期结束时间
  String endTime;

  ///出差天数
  String days;

  TravelModel({
    this.chufadi = '',
    this.mudidi = '',
    this.startTime = '',
    this.endTime = '',
    this.days = ''
  });
}

///支付对象信息模型
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

  ///备注
  String beizhu;

  FormModel({
    this.danweimingcheng = '',
    this.zhanghao = '',
    this.kaihuhangmingcheng = '',
    this.jine = '',
    this.zhifufangshi = '',
    this.beizhu = ''
  });
}