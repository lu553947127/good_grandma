import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:app_settings/app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto/crypto.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:good_grandma/common/colors.dart';
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

///多级联动
Future<String> showPickerModal(BuildContext context, String data) async {
  String result;
  await Picker(
      height: 220,
      itemExtent: 38,
      adapter: PickerDataAdapter<String>(pickerdata: JsonDecoder().convert(data)),
      changeToFirst: true,
      hideHeader: false,
      cancelText: '取消',
      confirmText: '确定',
      cancelTextStyle: TextStyle(fontSize: 14,color: Color(0xFF2F4058)),
      confirmTextStyle: TextStyle(fontSize: 14,color: Color(0xFFC68D3E)),
      onConfirm: (picker, value) {
        print(value.toString());
        print(picker.adapter.text);
        result = picker.adapter.text;
      }
  ).showModal(context); //_sca
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

///选择开始日期和结束日期
void showPickerDateRange({@required BuildContext context, @required Function(Map map) callBack}) async {
  Map param;
  String startTime;
  String endTime;
  Picker ps = Picker(
      hideHeader: true,
      adapter: DateTimePickerAdapter(
          type: PickerDateTimeType.kYMDHM,
          isNumberMonth: true,
          // yearSuffix: "年",
          // monthSuffix: "月",
          // daySuffix: "日",
          // hourSuffix: '时',
          // minuteSuffix: '分',
          value: DateTime.now()
      ),
      onConfirm: (Picker picker, List value) {
        print((picker.adapter as DateTimePickerAdapter).value);
      }
  );

  Picker pe = Picker(
      hideHeader: true,
      adapter: DateTimePickerAdapter(
          type: PickerDateTimeType.kYMDHM,
          isNumberMonth: true,
          // yearSuffix: "年",
          // monthSuffix: "月",
          // daySuffix: "日",
          // hourSuffix: '时',
          // minuteSuffix: '分',
          value: DateTime.now()
      ),
      onConfirm: (Picker picker, List value) {
        print((picker.adapter as DateTimePickerAdapter).value);
      }
  );

  List<Widget> actions = [
    TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('取消', style: TextStyle(fontSize: 14,color: Color(0xFF2F4058)))),
    TextButton(
        onPressed: () {

          ps.onConfirm(ps, ps.selecteds);
          pe.onConfirm(pe, pe.selecteds);

          startTime = formatDate((ps.adapter as DateTimePickerAdapter).value,
              [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn]);
          endTime = formatDate((pe.adapter as DateTimePickerAdapter).value,
              [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn]);
          print('startTime--------$startTime');
          print('endTime--------$endTime');

          int inHours = 0;
          String days = '';

          if (startTime == endTime){
            inHours = 0;
          }else {
            inHours = (pe.adapter as DateTimePickerAdapter).value.difference((ps.adapter as DateTimePickerAdapter).value).inHours + 1;
          }

          var hour = inHours / 24;

          print('inHours--------$inHours');
          print('hour--------$hour');

          days = formatNum(hour, 2);

          print('days--------$days');

          param = {'startTime': startTime, 'endTime': endTime, 'days': days};

          Navigator.pop(context, param);
        },
        child: Text('确定', style: TextStyle(fontSize: 14,color: Color(0xFFC68D3E))))
  ];

  param = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("选择日期范围"),
          actions: actions,
          content: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("开始时间:"),
                ps.makePicker(),
                Text("结束时间:"),
                pe.makePicker()
              ],
            ),
          ),
        );
      });

  if (param != null) {
    if (callBack != null) callBack(param);
  }
}

///取小数点后几位
///num 数据
///location 几位
String formatNum(double num, int location) {
  if ((num.toString().length - num.toString().lastIndexOf(".") - 1) <
      location) {
    //小数点后有几位小数
    return num.toStringAsFixed(location)
        .substring(0, num.toString().lastIndexOf(".") + location + 1)
        .toString();
  } else {
    return num.toString()
        .substring(0, num.toString().lastIndexOf(".") + location + 1)
        .toString();
  }
}

///密码md5加密
String passwordMD5(String data) {
  var content = new Utf8Encoder().convert(data);
  var digest = md5.convert(content);
  return digest.toString();
}

class AppUtil {
  ///todo:key都是暂时的
  static const aMapAndroidKey = 'aeb06cd10ca91bc2c77a3a70d89bd6c8';
  static const aMapiOSKey = '275249e60a6b2da6b74615bce89e23e9';

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
  ///新增页面pop前的弹框提示
  static Future<bool> onWillPop(BuildContext context) async {
    bool result = await showDialog(
        context: context,
        builder: (context1) {
          return AlertDialog(
            title: const Text('警告'),
            content: const Text('可能有编辑的内容未保存，确定要离开页面吗？'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('取消')),
              TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('确定')),
            ],
          );
        });
    if (result != null) return result;
    return false;
  }
  ///显示输入弹框
  static void showInputDialog({
    @required BuildContext context,
    @required TextEditingController editingController,
    @required FocusNode focusNode,
    @required String text,
    @required String hintText,
    TextInputType keyboardType = TextInputType.text,
    @required Function(String text) callBack,
  }) async {
    final txBottom = 40.0;
    final txHeight = 30.0;
    editingController.text = text;
    String result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx2, state) {
          return Container(
            height: MediaQuery.of(ctx2).viewInsets.bottom + txHeight + txBottom,
            color: Colors.white,
            padding:
            const EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.5),
            child: Stack(
              children: <Widget>[
                Positioned(
                    left: 0,
                    bottom: (MediaQuery.of(ctx2).viewInsets.bottom < 0)
                        ? 0
                        : MediaQuery.of(ctx2).viewInsets.bottom,
                    right: 0,
                    top: 0,
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: Container(
                                height: txHeight,
                                padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                                decoration: BoxDecoration(
                                    color: AppColors.FFEFEFF4,
                                    borderRadius: BorderRadius.circular(30 / 2)),
                                child: TextField(
                                  controller: editingController,
                                  focusNode: focusNode,
                                  maxLines: 1,
                                  keyboardType: keyboardType,
                                  selectionHeightStyle: BoxHeightStyle.max,
                                  textInputAction: TextInputAction.send,
                                  onSubmitted: (text) => Navigator.pop(ctx2, text),
                                  autofocus: true,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(),
                                    hintText: hintText,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30 / 2),
                                      borderSide: BorderSide.none,
                                    ),
                                    hintStyle: const TextStyle(
                                        color: AppColors.FF959EB1, fontSize: 12),
                                  ),
                                ),
                              )),
                          IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () =>
                                Navigator.pop(ctx2, editingController.text),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          );
        });
      },
    );
    if (result != null) {
      if (callBack != null) callBack(result);
    }
  }

  ///不足两位数前面补零
  static String dateForZero(int num) {
    return num < 10 ? '0$num' : num.toString();
  }
}
