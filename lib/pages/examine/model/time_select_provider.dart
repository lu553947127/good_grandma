import 'package:flutter/cupertino.dart';

class TimeSelectProvider with ChangeNotifier{

  String _startTime = '';
  String _endTime;
  String _dayNumber;
  String _select;
  String _value;
  List<String> _valueList;
  String _chufadi;
  String _mudidi;
  String _chuchaishiyou;
  String _xingchenganpai;
  String _yujidachengxiaoguo;
  String _bumen;
  String _bumenName;
  String _gongsi;
  String _zhuzhi;
  String _shuoming;
  String _purpose;
  String _desc;
  String _money;
  String _feiyongshenqing;
  String _fylb;
  String _nianduyusuan;
  String _type;
  String _jine;
  String _hexiaojine;

  TimeSelectProvider() {
    _startTime = '';
    _endTime = '';
    _dayNumber = '0';
    _select = '';
    _value = '';
    _valueList = [];
    _chufadi = '';
    _mudidi = '';
    _chuchaishiyou = '';
    _xingchenganpai = '';
    _yujidachengxiaoguo = '';
    _bumen = '';
    _bumenName = '';
    _gongsi = '';
    _zhuzhi = '';
    _shuoming = '';
    _purpose = '';
    _desc = '';
    _money = '';
    _feiyongshenqing = '';
    _fylb = '';
    _nianduyusuan = '';
    _type = '';
    _jine = '';
    _hexiaojine = '';
    _travelScheduleList = [];
    travelScheduleMapList = [];
    _zhifuduixiangxinxiList = [];
    zhifuduixiangxinxiMapList = [];
    _chuchaimingxiList = [];
    chuchaimingxiMapList = [];
  }

  String get startTime => _startTime;
  String get endTime => _endTime;
  String get dayNumber => _dayNumber;
  String get select => _select;
  String get value => _value;
  List<String> get valueList => _valueList;
  String get chufadi => _chufadi;
  String get mudidi => _mudidi;
  String get chuchaishiyou => _chuchaishiyou;
  String get xingchenganpai => _xingchenganpai;
  String get yujidachengxiaoguo => _yujidachengxiaoguo;
  String get bumen => _bumen;
  String get bumenName => _bumenName;
  String get gongsi => _gongsi;
  String get zhuzhi => _zhuzhi;
  String get shuoming => _shuoming;
  String get purpose => _purpose;
  String get desc => _desc;
  String get money => _money;
  String get feiyongshenqing => _feiyongshenqing;
  String get fylb => _fylb;
  String get nianduyusuan => _nianduyusuan;
  String get type => _type;
  String get jine => _jine;
  String get hexiaojine => _hexiaojine;

  ///添加
  addStartTime(start_time, end_time, day_number) {
    _startTime = start_time;
    _endTime = end_time;
    _dayNumber = day_number;
    notifyListeners();
  }

  addValue(str){
    _select = str;
    notifyListeners();
  }

  addValue2(str){
    _value = str;
    _valueList.add(value);
    notifyListeners();
  }

  addchufadi(str){
    _chufadi = str;
    notifyListeners();
  }

  addmudidi(str){
    _mudidi = str;
    notifyListeners();
  }

  addchuchaishiyou(str){
    _chuchaishiyou = str;
    notifyListeners();
  }

  addxingchenganpai(str){
    _xingchenganpai = str;
    notifyListeners();
  }

  addyujidachengxiaoguo(str){
    _yujidachengxiaoguo = str;
    notifyListeners();
  }

  addbumen(str, str2){
    _bumen = str;
    _bumenName = str2;
    notifyListeners();
  }

  addgongsi(str){
    _gongsi = str;
    notifyListeners();
  }

  addzhuzhi(str){
    _zhuzhi = str;
    notifyListeners();
  }

  addshuoming(str){
    _shuoming = str;
    notifyListeners();
  }

  addpurpose(str){
    _purpose = str;
    notifyListeners();
  }

  adddesc(str){
    _desc = str;
    notifyListeners();
  }

  addmoney(str){
    _money = str;
    notifyListeners();
  }

  addfeiyongshenqing(str){
    _feiyongshenqing = str;
    notifyListeners();
  }

  addfylb(str){
    _fylb = str;
    notifyListeners();
  }

  addnianduyusuan(str){
    _nianduyusuan = str;
    notifyListeners();
  }

  addtype(str){
    _type = str;
    notifyListeners();
  }

  addjine(str){
    _jine = str;
    notifyListeners();
  }

  addhexiaojine(str){
    _hexiaojine  = str;
    notifyListeners();
  }

  /**
   * 上传附件
   */

  ///文件map结合
  List<Map> filePath = [];
  ///图片map集合
  List<Map> imagePath = [];

  fileAdd(String image, String type, String iconName){
    Map addData = new Map();
    addData['value'] = image;
    addData['label'] = type;
    addData['iconName'] = iconName;
    filePath.add(addData);
    notifyListeners();
  }

  fileDelete(int index) async{
    if(filePath.length > 0){
      filePath.removeAt(index);
      notifyListeners();
    }
  }

  imageAdd(String image, String type, String iconName) {
    Map addData = new Map();
    addData['value'] = image;
    addData['label'] = type;
    addData['iconName'] = iconName;
    imagePath.add(addData);
    notifyListeners();
  }

  imageDelete(int index) async{
    if(imagePath.length > 0){
      imagePath.removeAt(index);
      notifyListeners();
    }
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

/**
 * 出差明细动态表单
 */

  ///动态列表
  List<FormEvectionModel> _chuchaimingxiList;

  ///动态列表
  List<FormEvectionModel> get chuchaimingxiList => _chuchaimingxiList;

  List<Map> chuchaimingxiMapList;

  ///添加item
  addchuchaimingxiForm(FormEvectionModel formModel){
    if(_chuchaimingxiList == null)
      _chuchaimingxiList = [];
    _chuchaimingxiList.add(formModel);
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
    addData['qitajine'] = formModel.qitajine;
    addData['beizhu'] = formModel.beizhu;
    chuchaimingxiMapList.add(addData);
    notifyListeners();
  }

  ///编辑当前item
  editchuchaimingxiFormWith(int index, FormEvectionModel formModel){
    if(_chuchaimingxiList == null)
      _chuchaimingxiList = [];
    if(index >= _chuchaimingxiList.length) return;
    _chuchaimingxiList.setAll(index, [formModel]);
    Map addData = new Map();
    List<String> timeList = [];
    timeList.add(formModel.start_time + ':00');
    timeList.add(formModel.end_time + ':00');
    addData['qizhishijian'] = timeList;
    addData['days'] = formModel.hejitianshu;
    addData['qizhididian'] = formModel.qizhididian;
    addData['chuchaimudi'] = formModel.chuchaimudi;
    addData['jiaotongjine'] = formModel.jiaotongjine;
    addData['shineijiaotong'] = formModel.shineijiaotong;
    addData['zhusujine'] = formModel.zhusujine;
    addData['buzhujine'] = formModel.buzhujine;
    addData['qitajine'] = formModel.qitajine;
    addData['beizhu'] = formModel.beizhu;
    chuchaimingxiMapList.setAll(index, [addData]);
    notifyListeners();
  }

  ///删除单个item
  deletechuchaimingxiFormWith(int index){
    if(_chuchaimingxiList == null)
      _chuchaimingxiList = [];
    if(index >= _chuchaimingxiList.length) return;
    _chuchaimingxiList.removeAt(index);
    chuchaimingxiMapList.removeAt(index);
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

///出差明细模型
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

  ///其他金额
  String qitajine;

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
    this.qitajine = '',
    this.beizhu = ''
  });
}