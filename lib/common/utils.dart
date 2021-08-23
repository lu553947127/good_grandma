import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:app_settings/app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto/crypto.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'application.dart';

/// 使用 DefaultCacheManager 类（可能无法自动引入，需要手动引入）
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

void showToast(String text) {
  FToast fToast = FToast()..init(Application.appContext);
  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.black87,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
          ),
        )
      ],
    ),
  );
  fToast.showToast(
    child: toast,
    gravity: ToastGravity.CENTER,
    toastDuration: Duration(seconds: 2),
  );
}

Future<String> showPicker(List options, BuildContext context) async {
  String result;
  await Picker(
      height: 220,
      itemExtent: 38,
      cancelText: '取消',
      confirmText: '确定',
      cancelTextStyle: TextStyle(fontSize: 14,color: Color(0xFF2F4058)),
      confirmTextStyle: TextStyle(fontSize: 14,color: Color(0xFFC68D3E)),
      adapter: PickerDataAdapter<String>(pickerdata: options),
      onConfirm: (Picker picker, List value) {
        result = options[value.first];
      }).showModal(context);
  return result ?? "";
}

Future<String> showPickerDate(BuildContext context) async {
  String result;
  await Picker(
      height: 220,
      itemExtent: 38,
      cancelText: '取消',
      confirmText: '确定',
      cancelTextStyle: TextStyle(fontSize: 14,color: Color(0xFF2F4058)),
      confirmTextStyle: TextStyle(fontSize: 14,color: Color(0xFFC68D3E)),
      adapter: DateTimePickerAdapter(
          type: PickerDateTimeType.kYMD,
          isNumberMonth: true,
          yearSuffix: "年",
          monthSuffix: "月",
          daySuffix: "日",
          value: DateTime.now()
      ),
      onConfirm: (Picker picker, List value) {
        result = formatDate((picker.adapter as DateTimePickerAdapter).value,
            [yyyy, '-', mm, '-', dd]);
        print((picker.adapter as DateTimePickerAdapter).value.toString());
      }).showModal(context);
  return result ?? "";
}

///密码md5加密
String passwordMD5(String data) {
  var content = new Utf8Encoder().convert(data);
  var digest = md5.convert(content);
  return digest.toString();
}

class AppUtil {
  /// 保存图片到相册
  ///
  /// 默认为下载网络图片，如需下载资源图片，需要指定 [isAsset] 为 `true`。
  static Future<void> saveImage({BuildContext context, String imageUrl, bool isAsset: false}) async {
    try {
      if (imageUrl == null || imageUrl.isEmpty) throw '保存失败，图片不存在！';

      /// 权限检测
      PermissionStatus storageStatus = await Permission.storage.status;
      if (storageStatus != PermissionStatus.granted) {
        if (Platform.isIOS) {
          storageStatus = await Permission.photos.request();
        } else {
          storageStatus = await Permission.storage.request();
        }
        if (storageStatus != PermissionStatus.granted) {
          throw '无法存储图片，请先授权！';
        }
      }

      /// 保存的图片数据
      Uint8List imageBytes;

      if (isAsset == true) {
        /// 保存资源图片
        ByteData bytes = await rootBundle.load(imageUrl);
        imageBytes = bytes.buffer.asUint8List();
      } else {
        /// 保存网络图片
        CachedNetworkImage image = CachedNetworkImage(imageUrl: imageUrl);
        DefaultCacheManager manager =
            image.cacheManager ?? DefaultCacheManager();
        Map<String, String> headers = image.httpHeaders;
        File file = await manager.getSingleFile(
          image.imageUrl,
          headers: headers,
        );
        imageBytes = await file.readAsBytes();
      }

      /// 保存图片
      final result = await ImageGallerySaver.saveImage(imageBytes);

      if (result == null || result == '') throw '图片保存失败';
      Fluttertoast.showToast(msg: '保存成功');
    } catch (e) {
      if (e == '无法存储图片，请先授权！'){
        bool result = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('无法存储图片'),
                content: Text('是否打开存储权限设置？'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('取消')),
                  TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('确定')),
                ],
              );
            });
        if(result != null && result){
          AppSettings.openAppSettings();
        }
      }
      if (e != null) Fluttertoast.showToast(msg: e.toString());
    }
  }
}
