import 'package:flutter/material.dart';

class AddDealerModel extends ChangeNotifier {

  ///经销商类型
  String _post;

  ///经销商类型名称
  String _postName;

  ///经销商性质
  String _nature;

  ///经销商性质名称
  String _natureName;

  ///公司名称
  String _corporateName;

  ///公司地址
  String _address;

  ///营业执照号
  String _licenseNo;

  ///公司邮箱
  String _email;

  ///公司手机
  String _phone;

  ///法人姓名
  String _juridical;

  ///法人身份证
  String _juridicalId;

  ///法人电话
  String _juridicalPhone;

  ///姓名
  String _realName;

  ///所属角色
  String _role;

  ///所属角色名称
  String _roleName;

  ///性别
  String _sex;

  ///性别名称
  String _sexName;

  ///开户银行
  String _bank;

  ///银行账号
  String _bankAccount;

  ///开户人
  String _bankUser;

  ///开户人身份证号
  String _bankCard;

  ///开户人出生日期
  String _birthday;

  ///登录账号
  String _account;

  ///登录密码
  String _pwd;

  AddDealerModel() {
    _post = '';
    _postName = '';
    _nature = '';
    _natureName = '';
    _corporateName = '';
    _address = '';
    _licenseNo = '';
    _email = '';
    _phone = '';
    _juridical = '';
    _juridicalId = '';
    _juridicalPhone = '';
    _realName = '';
    _role = '';
    _roleName = '';
    _sex = '';
    _sexName = '';
    _bank = '';
    _bankAccount = '';
    _bankUser = '';
    _bankCard = '';
    _birthday = '';
    _account = '';
    _pwd = '';
  }

  ///经销商类型
  String get post => _post;

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

  ///公司邮箱
  String get email => _email;

  ///联系手机
  String get phone => _phone;

  ///法人姓名
  String get juridical => _juridical;

  ///法人身份证
  String get juridicalId => _juridicalId;

  ///法人电话
  String get juridicalPhone => _juridicalPhone;

  ///姓名
  String get realName => _realName;

  ///所属角色
  String get role => _role;

  ///所属角色名称
  String get roleName => _roleName;

  ///性别
  String get sex => _sex;

  ///性别名称
  String get sexName => _sexName;

  ///开户行
  String get bank => _bank;

  ///银行账号
  String get bankAccount => _bankAccount;

  ///开户人
  String get bankUser => _bankUser;

  ///开户人身份证号
  String get bankCard => _bankCard;

  ///出生日期
  String get birthday => _birthday;

  ///登录账号
  String get account => _account;

  ///登录密码
  String get pwd => _pwd;

  setPost(String post) {
    _post = post;
    notifyListeners();
  }

  setPostName(String postName) {
    _postName = postName;
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

  setEmail(String email) {
    _email = email;
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

  setRealName(String realName) {
    _realName = realName;
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

  setSex(String sex) {
    _sex = sex;
    notifyListeners();
  }

  setSexName(String sexName) {
    _sexName = sexName;
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

  setBirthday(String birthday) {
    _birthday = birthday;
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
