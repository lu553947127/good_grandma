import 'package:flutter/material.dart';
import 'package:good_grandma/models/employee_model.dart';

class AddDealerModel extends ChangeNotifier {
  ///类型 1:企业 2:个体 3:自然人
  int _type;

  ///公司名称
  String _corporateName;

  ///营业执照号
  String _licenseNo;

  ///法人姓名
  String _legalPerson;

  ///法人身份证
  String _corporateIDCard;

  ///开户银行
  String _bankName;

  ///银行账号
  String _bankNo;

  ///联系手机
  String _phone;

  ///辖区级别 1:市级 2:区级
  int _areaLevel;

  ///所在区域
  String _area;

  ///城市经理
  EmployeeModel _cityManager;

  ///公司地址
  String _address;

  ///仓库地址
  String _warehouseAddress;

  ///收货人
  String _consignee;

  ///收货人手机
  String _consigneePhone;

  ///登录账号
  String _account;

  ///登录密码
  String _pwd;

  AddDealerModel() {
    _type = 1;
    _corporateName = '';
    _licenseNo = '';
    _legalPerson = '';
    _corporateIDCard = '';
    _bankName = '';
    _bankNo = '';
    _phone = '';
    _areaLevel = 1;
    _area = '';
    _cityManager = EmployeeModel();
    _address = '';
    _warehouseAddress = '';
    _consignee = '';
    _consigneePhone = '';
    _account = '';
    _pwd = '';
  }

  ///类型 1:企业 2:个体 3:自然人
  int get type => _type;

  ///公司名称
  String get corporateName => _corporateName;

  ///营业执照号
  String get licenseNo => _licenseNo;

  ///法人姓名
  String get legalPerson => _legalPerson;

  ///法人身份证
  String get corporateIDCard => _corporateIDCard;

  ///开户银行
  String get bankName => _bankName;

  ///银行账号
  String get bankNo => _bankNo;

  ///联系手机
  String get phone => _phone;

  ///辖区级别 1:市级 2:区级
  int get areaLevel => _areaLevel;

  ///所在区域
  String get area => _area;

  ///城市经理
  EmployeeModel get cityManager => _cityManager;

  ///公司地址
  String get address => _address;

  ///仓库地址
  String get warehouseAddress => _warehouseAddress;

  ///收货人
  String get consignee => _consignee;

  ///收货人手机
  String get consigneePhone => _consigneePhone;

  ///登录账号
  String get account => _account;

  ///登录密码
  String get pwd => _pwd;

  setType(int type) {
    _type = type;
    notifyListeners();
  }

  setCorporateName(String corporateName) {
    _corporateName = corporateName;
    notifyListeners();
  }

  setLicenseNo(String licenseNo) {
    _licenseNo = licenseNo;
    notifyListeners();
  }

  setLegalPerson(String legalPerson) {
    _legalPerson = legalPerson;
    notifyListeners();
  }

  setCorporateIDCard(String corporateIDCard) {
    _corporateIDCard = corporateIDCard;
    notifyListeners();
  }

  setBankName(String bankName) {
    _bankName = bankName;
    notifyListeners();
  }

  setBankNo(String bankNo) {
    _bankNo = bankNo;
    notifyListeners();
  }

  setPhone(String phone) {
    _phone = phone;
    notifyListeners();
  }

  setAreaLevel(int areaLevel) {
    _areaLevel = areaLevel;
    notifyListeners();
  }

  setArea(String area) {
    _area = area;
    notifyListeners();
  }

  setCityManager(EmployeeModel cityManager) {
    _cityManager = cityManager;
    notifyListeners();
  }

  setAddress(String address) {
    _address = address;
    notifyListeners();
  }

  setWarehouseAddress(String warehouseAddress) {
    _warehouseAddress = warehouseAddress;
    notifyListeners();
  }

  setConsignee(String consignee) {
    _consignee = consignee;
    notifyListeners();
  }

  setConsigneePhone(String consigneePhone) {
    _consigneePhone = consigneePhone;
    notifyListeners();
  }

  setAccount(String account) {
    _account = account;
    notifyListeners();
  }

  setPWD(String pwd) {
    _pwd = pwd;
    notifyListeners();
  }
}
