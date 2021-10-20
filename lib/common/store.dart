import 'package:get_storage/get_storage.dart';

class Store {
  static init() async {
    await GetStorage.init();
  }

  static final _box = GetStorage();

  static const _account = "account";
  static const _password = "password";
  static const _phone= "phone";
  static const _kToken = "keyToken";
  static const _userId = "userid";
  static const _userName = "user_name";
  static const _deptId = "dept_id";
  static const _deptName = "dept_name";
  static const _postName = "post_name";
  static const _nickName = "nick_name";
  static const _userAvatar = "avatar";
  ///用户类别，主要判断是不是职能
  static const _userType = "userType";

  static saveUserType(String userType) {
    _box.write(_userType, userType);
  }

  static String readUserType() {
    return _box.read(_userType);
  }

  static saveAccount(String account) {
    _box.write(_account, account);
  }

  static String readAccount() {
    return _box.read(_account);
  }

  static savePassword(String password) {
    _box.write(_password, password);
  }

  static String readPassword() {
    return _box.read(_password);
  }

  static savePhone(String phone) {
    _box.write(_phone, phone);
  }

  static String readPhone() {
    return _box.read(_phone);
  }

  static saveToken(String token) {
    _box.write(_kToken, token);
  }

  static String readToken() {
    return _box.read(_kToken);
  }

  static saveUserId(String userId) {
    _box.write(_userId, userId);
  }

  static String readUserId() {
    return _box.read(_userId);
  }

  static saveUserName(String userName) {
    _box.write(_userName, userName);
  }

  static String readUserName() {
    return _box.read(_userName);
  }

  static saveDeptId(String deptId) {
    _box.write(_deptId, deptId);
  }

  static String readDeptId() {
    return _box.read(_deptId);
  }

  static saveDeptName(String deptName) {
    _box.write(_deptName, deptName);
  }

  static String readDeptName() {
    return _box.read(_deptName);
  }

  static savePostName(String postName) {
    _box.write(_postName, postName);
  }

  static String readPostName() {
    return _box.read(_postName);
  }

  static saveNickName(String nickName) {
    _box.write(_nickName, nickName);
  }

  static String readNickName() {
    return _box.read(_nickName);
  }

  static saveUserAvatar(String avatar) {
    _box.write(_userAvatar, avatar);
  }

  static String readUserAvatar() {
    return _box.read(_userAvatar);
  }

  static removeToken() {
    _box.remove(_kToken);
    _box.remove(_userId);
    _box.remove(_userName);
    _box.remove(_postName);
    _box.remove(_nickName);
    _box.remove(_userAvatar);
    _box.remove(_userType);
  }

  static removeAccount() {
    _box.remove(_account);
  }

  static removePassword() {
    _box.remove(_password);
  }

  static removePhone() {
    _box.remove(_phone);
  }
}