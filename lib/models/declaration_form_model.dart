import 'package:flutter/material.dart';
import 'package:good_grandma/models/StoreModel.dart';
import 'package:good_grandma/models/goods_model.dart';

class DeclarationFormModel extends ChangeNotifier {
  StoreModel _storeModel;
  List<GoodsModel> _goodsList;
  String _phone;
  String _address;
  String time;
  String _createUserId;
  String _updateUser;
  int _selfMention;
  String _selfMentionName;
  int _invoiceType;
  String _invoiceTypeName;
  int _orderTypeIs;
  String _orderTypeIsName;
  String _settlementCus;
  String _settlementCusName;
  String _warehouseCode;
  String _warehouseName;
  int _totalCount;
  int _giftCount;
  double _netAmount;
  String _carpooling;
  String _carpoolCode;
  String _carpoolCustomers;
  String _carId;
  String _carName;
  String _carCount;
  String _carRate;
  String _isInvoice;
  String _invoiceId;
  String _invoiceName;
  List<DictionaryModel> _dictionaryModelList;

  ///标记订单状态 1待确认(待经销商确认)2待发货(待工厂确认)3待收货4完成5驳回
  int _status;
  ///订单id
  String id;
  ///标记订单是一级订单1还是二级订单2
  int orderType;
  ///驳回原因
  String reject;
  ///订单净额
  String totalPrice;
  ///订单折扣
  String giftTotal;

  DeclarationFormModel({this.time = '', this.id = '',this.reject = '',this.orderType = 1}) {
    _storeModel = StoreModel();
    _goodsList = [];
    _phone = '';
    _address = '';
    _status = 1;
    _createUserId = '';
    _updateUser = '';
    _selfMention = 0;
    _selfMentionName = '';
    _invoiceType = 0;
    _invoiceTypeName = '';
    _orderTypeIs = 0;
    _orderTypeIsName = '';
    _settlementCus = '';
    _settlementCusName = '';
    _warehouseCode = '';
    _warehouseName = '';
    _totalCount = 0;
    _giftCount = 0;
    _netAmount = 0;
    _carpooling = '否';
    _carpoolCode = '';
    _carpoolCustomers = '';
    _carId = '';
    _carName = '';
    _carCount = '';
    _carRate = '';
    _isInvoice = '否';
    _invoiceId = '';
    _invoiceName = '';
    _dictionaryModelList = [];
  }

  ///解析订单列表数据并赋值
  DeclarationFormModel.fromJsonList(Map<String, dynamic> json) {
    String name = json['cusName'] ?? '';
    String customerId = json['customerId'].toString() ?? '';
    String phone = json['cusPhone'] ?? '';
    String address = json['address'] ?? '';
    reject = json['reject'] ?? '';
    totalPrice = json['totalPrice'].toString() ?? '';
    giftTotal = json['giftTotal'].toString() ?? '';
    orderType = json['middleman'] ?? 1;
    _createUserId = json['createUser'].toString() ?? '';
    _updateUser = json['updateUser'].toString() ?? '';
    id = json['id'] ?? '';
    time = json['time'] ?? '';
    _status = json['status'] ?? 1;
    _storeModel = StoreModel(name: name,id: customerId,phone: phone,address: address);
    _goodsList = [];

    if (json['goodsList'] != null) {
      json['goodsList'].forEach((map) {
        GoodsModel model = GoodsModel(
            name: map['name'] ?? '',
            count: map['count'] ?? 0,
            weight: double.parse(map['weight']) ?? 0,
            invoice: double.parse(map['invoice']) ?? 0.0,
            id: map['id'] ?? '',
            image: map['pic'] ?? ''
        );
        String spec = map['spec'] ?? '';
        if (spec.isNotEmpty) {
          SpecModel specModel = SpecModel(spec: spec);
          model.specs.add(specModel);
        }
        _goodsList.add(model);
      });
    }
  }

  ///店铺
  StoreModel get storeModel => _storeModel;

  ///商品列表
  List<GoodsModel> get goodsList => _goodsList;

  ///电话
  String get phone => _phone;

  ///地址
  String get address => _address;

  ///配送方式
  int get selfMention => _selfMention;

  ///配送方式
  String get selfMentionName => _selfMentionName;

  ///发票类型
  int get invoiceType => _invoiceType;

  ///发票类型
  String get invoiceTypeName => _invoiceTypeName;

  ///订单类型
  int get orderTypeIs => _orderTypeIs;

  ///订单类型
  String get orderTypeIsName => _orderTypeIsName;

  ///结算客户
  String get settlementCus => _settlementCus;

  ///结算客户
  String get settlementCusName => _settlementCusName;

  ///仓库
  String get warehouseCode => _warehouseCode;

  ///仓库
  String get warehouseName => _warehouseName;

  ///实际数量
  int get totalCount => _totalCount;

  ///搭赠数量
  int get giftCount => _giftCount;

  ///订单净额
  double get netAmount => _netAmount;

  ///是否拼车
  String get carpooling => _carpooling;

  ///拼车码
  String get carpoolCode => _carpoolCode;

  ///拼车客户
  String get carpoolCustomers => _carpoolCustomers;

  ///货车车型
  String get carId => _carId;

  ///货车车型
  String get carName => _carName;

  ///货车车型数量
  String get carCount => _carCount;

  ///装车率
  String get carRate => _carRate;

  ///是否需要发票
  String get isInvoice => _isInvoice;

  ///开票信息
  String get invoiceId => _invoiceId;

  ///开票信息
  String get invoiceName => _invoiceName;

  ///折扣详情列表
  List<DictionaryModel> get dictionaryModelList => _dictionaryModelList;

  ///标记订单状态 1待确认(待经销商确认)2待发货(待工厂确认)3待收货4完成5驳回
  int get status => _status;

  ///创建者id
  String get createUserId => _createUserId;

  ///更新者id
  String get updateUser => _updateUser;

  ///订单状态名字
  String get statusName {
    switch(_status){
      case 1:
        return '待确认';
      case 2:
        return '账余审核';
      case 3:
        return '装车率审核';
      case 4:
        return '营业室审核';
      case 5:
        return '待发货';
      case 6:
        return '已发货';
      case 7:
        return '已收货';
      case 8:
        return '驳回';
      case 9:
        return '取消';
      default:
        return '未知状态';
    }
  }

  ///状态文字颜色是否显示灰色
  bool showGray() => (status == 4 || status == 6);

  ///状态颜色
  Color get statusColor {
    switch(_status){
      case 1:
        return Color(0xFFDD0000);
      case 2:
        return Color(0xFF05A8C6);
      case 3:
        return Color(0xFFC08A3F);
      case 4:
        return Color(0xFF12BD95);
      case 5:
        return Color(0xFF999999);
      case 6:
        return Color(0xFFE45C26);
      case 7:
        return Color(0xFFE5A800);
      case 8:
        return Color(0xFF142339);
      case 9:
        return Color(0xFF959EB1);
      default:
        return Color(0xFFEFEFF4);
    }
  }

  ///商品总数
  int get goodsCount {
    int count = 0;
    _goodsList.forEach((goodsModel) {
      count += goodsModel.count;
    });
    return count;
  }

  ///商品总重
  double get goodsWeight {
    double count = 0;
    _goodsList.forEach((goodsModel) {
      count += goodsModel.countWeight;
    });
    return count;
  }

  ///商品总额
  double get goodsPrice {
    double count = 0;
    _goodsList.forEach((goodsModel) {
      count += goodsModel.countPrice;
    });
    return count;
  }

  ///商品总标准件数
  double get goodsStandardCount {
    double count = 0;
    _goodsList.forEach((goodsModel) {
      count += goodsModel.standardCount;
    });
    return count;
  }

  ///折扣合计
  double get discount {
    double count = 0;
    _dictionaryModelList.forEach((model) {
      if (model.money.isEmpty) return;
      count += double.parse(model.money);
    });
    return count;
  }

  ///订单添加 订单列表map数据
  List<Map> get goodsListToString{
    List<Map> mapList = [];
    _goodsList.forEach((goodsModel) {
      Map map = new Map();
      map['goodsId'] = goodsModel.id;
      map['count'] = goodsModel.count;
      mapList.add(map);
    });
    return mapList;
  }

  ///订单添加 折扣详情列表map数据
  List<String> get dictionaryToList{
    List<String> stringList = [];
    _dictionaryModelList.forEach((element) {
      if (element.id.isEmpty){
        stringList.add('${element.remark}-${element.money}');
      }else{
        stringList.add('${element.remark}-${element.id}-${element.money}');
      }
    });
    return stringList;
  }

  setCreateUserId(String createUserId){
    _createUserId = createUserId;
    notifyListeners();
  }

  setUpdateUser(String updateUser){
    _updateUser = updateUser;
    notifyListeners();
  }

  setStatus(int status) {
    _status = status;
    notifyListeners();
  }

  setStoreModel(StoreModel storeModel) {
    _storeModel = storeModel;
    notifyListeners();
  }

  setPhone(String phone) {
    _phone = phone;
    notifyListeners();
  }

  setAddress(String address) {
    _address = address;
    notifyListeners();
  }

  setSelfMention(int selfMention){
    _selfMention = selfMention;
    notifyListeners();
  }

  setSelfMentionName(String selfMentionName){
    _selfMentionName = selfMentionName;
    notifyListeners();
  }

  setInvoiceType(int invoiceType){
    _invoiceType = invoiceType;
    notifyListeners();
  }

  setInvoiceTypeName(String invoiceTypeName){
    _invoiceTypeName = invoiceTypeName;
    notifyListeners();
  }

  setOrderTypeIs(int orderTypeIs){
    _orderTypeIs = orderTypeIs;
    notifyListeners();
  }

  setOrderTypeIsName(String orderTypeIsName){
    _orderTypeIsName = orderTypeIsName;
    notifyListeners();
  }

  setSettlementCus(String settlementCus){
    _settlementCus = settlementCus;
    notifyListeners();
  }

  setSettlementCusName(String settlementCusName){
    _settlementCusName = settlementCusName;
    notifyListeners();
  }

  setWarehouseCode(String warehouseCode){
    _warehouseCode = warehouseCode;
    notifyListeners();
  }

  setWarehouseName(String warehouseName){
    _warehouseName = warehouseName;
    notifyListeners();
  }

  setNetAmount(double netAmount){
    _netAmount = netAmount;
    notifyListeners();
  }

  setCarpooling(String carpooling){
    _carpooling = carpooling;
    notifyListeners();
  }

  setCarpoolCode(String carpoolCode){
    _carpoolCode = carpoolCode;
    notifyListeners();
  }

  setCarpoolCustomers(String carpoolCustomers){
    _carpoolCustomers = carpoolCustomers;
    notifyListeners();
  }

  setCarId(String carId){
    _carId = carId;
    notifyListeners();
  }

  setCarName(String carName){
    _carName = carName;
    notifyListeners();
  }

  setCarCount(String carCount){
    _carCount = carCount;
    notifyListeners();
  }

  setCarRate(String carRate){
    _carRate = carRate;
    notifyListeners();
  }

  setIsInvoice(String isInvoice){
    _isInvoice = isInvoice;
    notifyListeners();
  }

  setInvoiceId(String invoiceId){
    _invoiceId = invoiceId;
    notifyListeners();
  }

  setInvoiceName(String invoiceName){
    _invoiceName = invoiceName;
    notifyListeners();
  }

  setArrays(
    List<GoodsModel> array,
    List<GoodsModel> values,
  ) {
    if (array == null) array = [];
    array.clear();
    array.addAll(values);
    notifyListeners();
  }

  setDictArrays(
      List<DictionaryModel> array,
      List<DictionaryModel> values,
      ) {
    if (array == null) array = [];
    array.clear();
    array.addAll(values);
    notifyListeners();
  }

  addToArray(GoodsModel goodsModel) {
    if(_goodsList == null)
      _goodsList = [];
    _goodsList.add(goodsModel);
    notifyListeners();
  }

  editArrayWith(List<GoodsModel> array, int index, GoodsModel goodsModel) {
    if (array == null) array = [];
    if (index >= array.length) return;
    array.setAll(index, [goodsModel]);
    notifyListeners();
  }

  deleteArrayWith(List<GoodsModel> array, int index) {
    if (array == null) array = [];
    if (index >= array.length) return;
    array.removeAt(index);
    notifyListeners();
  }

  addToDictionaryArray(DictionaryModel dictionaryModel) {
    if(_dictionaryModelList == null)
      _dictionaryModelList = [];
    _dictionaryModelList.add(dictionaryModel);
    notifyListeners();
  }

  editDictionaryArrayWith(List<DictionaryModel> array, int index, DictionaryModel dictionaryModel) {
    if (array == null) array = [];
    if (index >= array.length) return;
    array.setAll(index, [dictionaryModel]);
    notifyListeners();
  }
}

///折扣详情列表
class DictionaryModel {
  String id;
  String remark;
  String dictKey;
  String money;
  DictionaryModel({
    this.id = '',
    this.remark = '',
    this.dictKey = '',
    this.money = ''
  });
}
