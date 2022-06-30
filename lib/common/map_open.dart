import 'dart:io';
import 'package:good_grandma/common/utils.dart';
import 'package:url_launcher/url_launcher.dart';

///跳转第三方地图并导航
class URLOpenUtils {

  /// 腾讯地图调用
  static Future<bool> openTencentMap(double longitude, double latitude, {String address, bool showErr: true}) async {
    String url = 'qqmap://map/routeplan?type=drive&fromcoord=CurrentLocation&tocoord=$latitude,$longitude&referer=FN4BZ-6E33P-LFTDB-VRZ4C-NTP3Z-RVFFK&debug=true&to=${address ?? ''}';
    if (Platform.isIOS)
      url = Uri.encodeFull(url);
    try {
      if (await canLaunch(url) != null) {
        await launch(url);
      }
    } on Exception catch(e) {
      if (showErr)
        showToast('无法调起腾讯地图，请先安装后再使用');
      return false;
    }
    return true;
  }

  /// 高德地图调用
  static Future<bool> openAmap(double longitude, double latitude, {String address, bool showErr: true}) async {
    String url = '${Platform.isAndroid ? 'android' : 'ios'}amap://navi?sourceApplication=amap&lat=$latitude&lon=$longitude&dev=0&style=2&poiname=${address ?? ''}';
    if (Platform.isIOS)
      url = Uri.encodeFull(url);
    try {
      if (await canLaunch(url) != null) {
        await launch(url);
      }
    } on Exception catch(e) {
      if (showErr)
        showToast('无法调起高德地图，请先安装后再使用');
      return false;
    }
    return true;
  }

  /// 百度地图
  static Future<bool> openBaiduMap(double longitude, double latitude, {String address, bool showErr: true}) async {
    String url = 'baidumap://map/direction?destination=name:${address ?? ''}|latlng:$latitude,$longitude&coord_type=bd09ll&mode=driving';
    if (Platform.isIOS)
      url = Uri.encodeFull(url);
    try {
      if (await canLaunch(url) != null) {
        await launch(url);
      }
    } on Exception catch(e) {
      if (showErr)
        showToast('无法调起百度地图，请先安装后再使用');
      return false;
    }
    return true;
  }

  /// 苹果地图
  static Future<bool> openAppleMap(longitude, latitude, {String address, bool showErr: true}) async {
    String url = 'http://maps.apple.com/?daddr=$latitude,$longitude&address=$address';
    if (Platform.isIOS)
      url = Uri.encodeFull(url);
    try {
      if (await canLaunch(url) != null) {
        await launch(url);
      }
    } on Exception catch(e) {
      if (showErr)
        showToast('无法调起苹果地图，请先安装');
      return false;
    }
    return true;
  }

  ///打开全部地图,哪个手机上安装打开哪个
  static Future<bool> openMap(longitude, latitude, {String address, bool showErr: false}) async {
    bool flag = true;
    if (!await openAmap(longitude, latitude, address: address, showErr: showErr)) {
      if (!await openBaiduMap(longitude, latitude, address: address, showErr: showErr)) {
        if (!await openTencentMap(longitude, latitude, address: address, showErr: showErr)) {
          // if (!await openAppleMap(longitude, latitude, address: address, showErr: showErr)) {
          flag = false;
          showToast('无法调用地图应用，请安装高德，百度，腾讯任意一种地图应用');
          // }
        }
      }
    }
    return flag;
  }
}