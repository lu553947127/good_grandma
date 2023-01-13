import 'package:flutter/cupertino.dart';

///oa审批模型
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
  String _fylb;
  String _nianduyusuan;
  String _type;
  String _jine;
  String _hexiaojine;
  String _reason;
  bool _isCopyUser;
  String _name;
  String _deptId;
  String _deptName;
  String _customerId;
  String _customerName;
  String _address;
  String _starttime;
  String _endtime;
  String _phone;
  String _sketch;
  String _costtotal;
  String _purchasemoney;
  String _purchaseratio;

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
    _fylb = '';
    _nianduyusuan = '';
    _type = '';
    _jine = '';
    _hexiaojine = '';
    _reason = '';
    _isCopyUser = false;
    _name = '';
    _deptId = '';
    _deptName = '';
    _customerId = '';
    _customerName = '';
    _address = '';
    _starttime = '';
    _endtime = '';
    _phone = '';
    _sketch = '';
    _costtotal = '';
    _purchasemoney = '';
    _purchaseratio = '';
    _travelScheduleList = [];
    travelScheduleMapList = [];
    _zhifuduixiangxinxiList = [];
    zhifuduixiangxinxiMapList = [];
    _chuchaimingxiList = [];
    chuchaimingxiMapList = [];
    _userList = [];
    userMapList = [];
    _costStringList = [];
    _sampleList = [];
    sampleMapList = [];
    _costList = [];
    costMapList = [];
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
  String get fylb => _fylb;
  String get nianduyusuan => _nianduyusuan;
  String get type => _type;
  String get jine => _jine;
  String get hexiaojine => _hexiaojine;
  String get reason => _reason;
  bool get isCopyUser => _isCopyUser;
  String get name => _name;
  String get deptId => _deptId;
  String get deptName => _deptName;
  String get customerId => _customerId;
  String get customerName => _customerName;
  String get address => _address;
  String get starttime => _starttime;
  String get endtime => _endtime;
  String get phone => _phone;
  String get sketch => _sketch;
  String get costtotal => _costtotal;
  String get purchasemoney => _purchasemoney;
  String get purchaseratio => _purchaseratio;

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

  addreason(str){
    _reason  = str;
    notifyListeners();
  }

  addiscopyUser(str){
    _isCopyUser = str;
    notifyListeners();
  }

  addName(str){
    _name = str;
    notifyListeners();
  }

  addDeptId(str){
    _deptId = str;
    notifyListeners();
  }

  addDeptName(str){
    _deptName = str;
    notifyListeners();
  }

  addCustomerId(str){
    _customerId = str;
    notifyListeners();
  }

  addCustomerName(str){
    _customerName = str;
    notifyListeners();
  }

  addAddress(str){
    _address = str;
    notifyListeners();
  }

  addStarttime(str){
    _starttime = str;
    notifyListeners();
  }

  addEndtime(str){
    _endtime = str;
    notifyListeners();
  }

  addPhone(str){
    _phone = str;
    notifyListeners();
  }

  addSketch(str){
    _sketch = str;
    notifyListeners();
  }

  addCosttotal(str){
    _costtotal = str;
    notifyListeners();
  }

  addPurchasemoney(str){
    _purchasemoney = str;
    notifyListeners();
  }

  addPurchaseratio(str){
    _purchaseratio = str;
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
    addData['zigongsi'] = formModel.zigongsi;
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
    addData['zigongsi'] = formModel.zigongsi;
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

  ///抄送用户列表
  List<UserModel> _userList = [];

  ///抄送用户列表
  List<UserModel> get userList => _userList;

  List<Map> userMapList = [];

  ///添加
  addUserModel(String id, String name){
    if(userMapList == null)
      userMapList = [];
    Map addData = new Map();
    addData['id'] = id;
    addData['name'] = name;
    userMapList.add(addData);
    notifyListeners();
  }

  ///编辑当前item
  editUserModelWith(int index, String id, String name){
    if(userMapList == null)
      userMapList = [];
    if(index >= userMapList.length) return;
    Map addData = new Map();
    addData['id'] = id;
    addData['name'] = name;
    userMapList.setAll(index, [addData]);
    notifyListeners();
  }

  ///删除单个item
  deleteUserModelWith(int index){
    if(userMapList == null)
      userMapList = [];
    if(index >= userMapList.length) return;
    userMapList.removeAt(index);
    notifyListeners();
  }

  ///费用申请列表
  List<String> _costStringList = [];

  ///费用申请列表
  List<String> get costStringList => _costStringList;

  ///添加
  addCostStringModel(String id){
    if(_costStringList == null)
      _costStringList = [];
    _costStringList.add(id);
    notifyListeners();
  }

  ///删除单个item
  deleteCostStringModelWith(int index){
    if(_costStringList == null)
      _costStringList = [];
    if(index >= _costStringList.length) return;
    _costStringList.removeAt(index);
    notifyListeners();
  }

  ///多选人员添加数据
  setArrays(
      List<UserModel> array,
      List<UserModel> values,
      ) {
    if (array == null) array = [];
    array.clear();
    array.addAll(values);
    notifyListeners();
  }

  ///多选人员删除数据
  deleteArrayWith(List<UserModel> array, int index) {
    if (array == null) array = [];
    if (index >= array.length) return;
    array.removeAt(index);
    notifyListeners();
  }

  ///试吃品列表
  List<SampleModel> _sampleList;

  ///试吃品列表
  List<SampleModel> get sampleList => _sampleList;

  ///试吃品列表
  List<Map> sampleMapList;

  ///试吃品现金总和
  double get sampleAllPrice {
    double count = 0;
    _sampleList.forEach((model) {
      count += model.costCash;
    });
    return count;
  }

  ///添加试吃品
  addSampleModel(SampleModel model){
    if(_sampleList == null)
      _sampleList = [];
    _sampleList.add(model);
    Map addData = new Map();
    addData['materialId'] = model.materialId;
    addData['materialName'] = model.materialName;
    addData['sample'] = model.sample;
    addData['costCash'] = model.costCash;
    addData['unitPrice'] = model.unitPrice;
    addData['withGoods'] = model.withGoods;
    sampleMapList.add(addData);
    notifyListeners();
  }

  ///编辑当前item
  editSampleModelWith(int index, SampleModel model){
    if(_sampleList == null)
      _sampleList = [];
    if(index >= _sampleList.length) return;
    _sampleList.setAll(index, [model]);
    Map addData = new Map();
    addData['materialId'] = model.materialId;
    addData['materialName'] = model.materialName;
    addData['sample'] = model.sample;
    addData['costCash'] = model.costCash;
    addData['unitPrice'] = model.unitPrice;
    addData['withGoods'] = model.withGoods;
    sampleMapList.setAll(index, [addData]);
    notifyListeners();
  }

  ///删除单个item
  deleteSampleModelWith(int index){
    if(_sampleList == null)
      _sampleList = [];
    if(index >= _sampleList.length) return;
    _sampleList.removeAt(index);
    sampleMapList.removeAt(index);
    notifyListeners();
  }

  ///费用信息列表
  List<CostModel> _costList;

  ///费用信息列表
  List<CostModel> get costList => _costList;

  ///费用信息列表
  List<Map> costMapList;

  ///费用现金总和
  double get costAllPrice {
    double count = 0;
    _costList.forEach((model) {
      count += double.parse(model.costCash);
    });
    return count;
  }

  ///添加item
  addCostModel(CostModel model){
    if(_costList == null)
      _costList = [];
    _costList.add(model);
    Map addData = new Map();
    addData['costType'] = model.costType;
    addData['costTypeName'] = model.costTypeName;
    addData['costCash'] = model.costCash;
    addData['costDescribe'] = model.costDescribe;
    costMapList.add(addData);
    notifyListeners();
  }

  ///编辑当前item
  editCostModelWith(int index, CostModel model){
    if(_costList == null)
      _costList = [];
    if(index >= _costList.length) return;
    _costList.setAll(index, [model]);
    Map addData = new Map();
    addData['costType'] = model.costType;
    addData['costTypeName'] = model.costTypeName;
    addData['costCash'] = model.costCash;
    addData['costDescribe'] = model.costDescribe;
    costMapList.setAll(index, [addData]);
    notifyListeners();
  }

  ///删除单个item
  deleteCostModelWith(int index){
    if(_costList == null)
      _costList = [];
    if(index >= _costList.length) return;
    _costList.removeAt(index);
    costMapList.removeAt(index);
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

  ///子公司
  String zigongsi;

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
    this.zigongsi = '',
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

///用户模型
class UserModel {
  String id;

  String name;
  
  String image;
  
  bool isSelected;

  UserModel(ids, names, {
    this.id = '',
    this.name = '',
    this.image = '',
    this.isSelected = false
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    id = json['id'] ?? '';
    image = json['avatar'] ?? '';
    isSelected = false;
  }
}

///试吃品模型数据
class SampleModel {

  ///物料id
  String materialId;

  ///物料名称
  String materialName;

  ///试吃品数量数量
  double sample;

  ///现金
  double costCash;

  ///单价
  double unitPrice;

  ///是否随货
  int withGoods;

  ///是否随货名称
  String withGoodsName;

  SampleModel({
    this.materialId = '',
    this.materialName = '',
    this.sample = 0,
    this.costCash = 0,
    this.unitPrice = 0,
    this.withGoods = 0,
    this.withGoodsName = ''
  });
}

///费用模型数据
class CostModel {

  ///费用类别
  String costType;

  ///费用类别名称
  String costTypeName;

  ///现金
  String costCash;

  ///费用描述
  String costDescribe;

  CostModel({
    this.costType = '',
    this.costTypeName = '',
    this.costCash = '',
    this.costDescribe = ''
  });
}