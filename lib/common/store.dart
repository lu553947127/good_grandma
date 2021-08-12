import 'package:get_storage/get_storage.dart';

class Store {
  static init() async {
    await GetStorage.init();
  }

  static final _box = GetStorage();

  static const _kToken = "keyToken";
  static const _userId = "userid";


  static saveToken(String token, String userId) async {
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

  static removeToken() {
    _box.remove(_kToken);
    _box.remove(_userId);
  }
}