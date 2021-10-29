import 'package:flutter/material.dart';

class AddDealerModel extends ChangeNotifier {

  ///经销商(城市经理)id
  String _serviceCode;

  ///经销商(城市经理)id名称
  String _serviceCodeName;

  ///岗位id
  String _deptId;

  ///岗位id名称
  String _deptIdName;

  ///经销商类型
  String _post;

  ///经销商等级
  String _postCode;

  ///经销商类型名称
  String _postName;

  ///经销商性质
  String _nature;

  ///经销商性质名称
  String _natureName;

  ///企业名称
  String _corporateName;

  ///企业地址
  String _address;

  ///营业执照号
  String _licenseNo;

  ///公司手机
  String _phone;

  ///法人姓名
  String _juridical;

  ///法人身份证
  String _juridicalId;

  ///法人电话
  String _juridicalPhone;

  ///所属角色
  String _role;

  ///所属角色名称
  String _roleName;

  ///经销商级别
  String _customerType;

  ///经销商级别名称
  String _customerTypeName;

  ///开户银行
  String _bank;

  ///银行账号
  String _bankAccount;

  ///开户人
  String _bankUser;

  ///开户人身份证号
  String _bankCard;

  ///登录账号
  String _account;

  ///登录密码
  String _pwd;

  ///身份证照片
  String _idCardImage;

  ///营业执照
  String _licenseImage;

  AddDealerModel() {
    _deptId = '';
    _deptIdName = '';
    _serviceCode = '';
    _serviceCodeName = '';
    _post = '';
    _postName = '';
    _postCode = '';
    _nature = '';
    _natureName = '';
    _corporateName = '';
    _address = '';
    _licenseNo = '';
    _phone = '';
    _juridical = '';
    _juridicalId = '';
    _juridicalPhone = '';
    _role = '';
    _roleName = '';
    _customerType = '';
    _customerTypeName = '';
    _bank = '';
    _bankAccount = '';
    _bankUser = '';
    _bankCard = '';
    _account = '';
    _pwd = '';
    _idCardImage = '';
    _licenseImage = '';
  }

  ///经销商(城市经理)id
  String get serviceCode => _serviceCode;

  ///经销商(城市经理)id名称
  String get serviceCodeName => _serviceCodeName;

  ///岗位id
  String get deptId => _deptId;

  ///岗位id名称
  String get deptIdName => _deptIdName;

  ///经销商类型
  String get post => _post;

  ///经销商等级
  String get postCode => _postCode;

  ///经销商类型名称
  String get postName => _postName;

  ///经销商性质
  String get nature => _nature;

  ///经销商性质名称
  String get natureName => _natureName;

  ///公司名称
  String get corporateName => _corporateName;

  ///公司地址
  String get address => _address;

  ///营业执照号
  String get licenseNo => _licenseNo;

  ///联系手机
  String get phone => _phone;

  ///法人姓名
  String get juridical => _juridical;

  ///法人身份证
  String get juridicalId => _juridicalId;

  ///法人电话
  String get juridicalPhone => _juridicalPhone;

  ///所属角色
  String get role => _role;

  ///所属角色名称
  String get roleName => _roleName;

  ///经销商级别
  String get customerType => _customerType;

  ///经销商级别名称
  String get customerTypeName => _customerTypeName;

  ///开户行
  String get bank => _bank;

  ///银行账号
  String get bankAccount => _bankAccount;

  ///开户人
  String get bankUser => _bankUser;

  ///开户人身份证号
  String get bankCard => _bankCard;

  ///登录账号
  String get account => _account;

  ///登录密码
  String get pwd => _pwd;

  ///身份证照片
  String get idCardImage => _idCardImage;

  ///营业执照
  String get licenseImage => _licenseImage;

  setDeptId(String deptId) {
    _deptId = deptId;
    notifyListeners();
  }

  setDeptIdName(String deptIdName) {
    _deptIdName = deptIdName;
    notifyListeners();
  }

  setServiceCode(String serviceCode) {
    _serviceCode = serviceCode;
    notifyListeners();
  }

  setServiceCodeName(String serviceCodeName) {
    _serviceCodeName = serviceCodeName;
    notifyListeners();
  }

  setPost(String post) {
    _post = post;
    notifyListeners();
  }

  setPostName(String postName) {
    _postName = postName;
    notifyListeners();
  }

  setPostCode(String postCode) {
    _postCode = postCode;
    notifyListeners();
  }

  setNature(String nature) {
    _nature = nature;
    notifyListeners();
  }

  setNatureName(String natureName) {
    _natureName = natureName;
    notifyListeners();
  }

  setCorporateName(String corporateName) {
    _corporateName = corporateName;
    notifyListeners();
  }

  setAddress(String address) {
    _address = address;
    notifyListeners();
  }

  setLicenseNo(String licenseNo) {
    _licenseNo = licenseNo;
    notifyListeners();
  }

  setPhone(String phone) {
    _phone = phone;
    notifyListeners();
  }

  setJuridical(String juridical) {
    _juridical = juridical;
    notifyListeners();
  }

  setJuridicalId(String juridicalId) {
    _juridicalId = juridicalId;
    notifyListeners();
  }

  setJuridicalPhone(String juridicalPhone) {
    _juridicalPhone = juridicalPhone;
    notifyListeners();
  }

  setRole(String role) {
    _role = role;
    notifyListeners();
  }

  setRoleName(String roleName) {
    _roleName = roleName;
    notifyListeners();
  }

  setCustomerType(String customerType) {
    _customerType = customerType;
    notifyListeners();
  }

  setCustomerTypeName(String customerTypeName) {
    _customerTypeName = customerTypeName;
    notifyListeners();
  }

  setBank(String bank) {
    _bank = bank;
    notifyListeners();
  }

  setBankAccount(String bankAccount) {
    _bankAccount = bankAccount;
    notifyListeners();
  }

  setBankUser(String bankUser) {
    _bankUser = bankUser;
    notifyListeners();
  }

  setBankCard(String bankCard) {
    _bankCard = bankCard;
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

  setIdCardImage(String idCardImage) {
    _idCardImage = idCardImage;
    notifyListeners();
  }

  setLicenseImage(String licenseImage) {
    _licenseImage = licenseImage;
    notifyListeners();
  }
}
