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
    _travelScheduleList = [];
    travelScheduleMapList = [];
    _zhifuduixiangxinxiList = [];
    zhifuduixiangxinxiMapList = [];
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