import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:app_settings/app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto/crypto.dart';
import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
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
void showPickerDateRange({
  @required BuildContext context,
  int type,
  @required Function(Map map) callBack}) async {
  Map param;
  String startTime;
  String endTime;
  int _type = PickerDateTimeType.kYMDHM;
  if(type != null)
    _type = type;
  Picker ps = Picker(
      hideHeader: true,
      adapter: DateTimePickerAdapter(
          type: _type,
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
          type: _type,
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

///list集合转化成,相隔的字符串
String listToString(List<String> list) {
  if (list == null) {
    return null;
  }
  String result;
  list.forEach((string) =>
  {if (result == null) result = string else result = '$result,$string'});
  return result.toString();
}

class AppUtil {
  static const aMapAndroidKey = '9826f8c8e4d7b4b3eaafd13c6213bfcc';
  static const aMapiOSKey = '330ac281e8e9fdcee0cb9e2011a0323c';

  /// 保存图片到相册
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
                                        color: AppColors.FF959EB1, fontSize: 14),
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

  ///用浏览器打开链接
  static void launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  ///显示位于中间的toast
  static void showToastCenter(String msg) {
    if (msg == null || msg.length == 0) {
      return;
    }
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
    );
  }
  ///请求权限,返回暂时储存路径
  static Future<String> _requestStoragePermission({String url,String fileName}) async {
    if (url != null && url.isNotEmpty) {
      PermissionStatus status = await Permission.storage.request();
      if (status != PermissionStatus.granted) {
        AppUtil.showToastCenter("请打开文件读写权限");
        throw Exception("请打开文件读写权限");
      }
      // getApplicationDocumentsDirectory()
      // 获取文档目录的路径
      Directory appTempDir = await getApplicationDocumentsDirectory();
      String path = appTempDir.path + "/附件/" + fileName;
      if(Platform.isAndroid){
        path = '/sdcard/download/好阿婆附件/' +fileName;
      }
      return path;
    }
    return '';
  }
  ///下载到暂存目录
  static Future downloadFile({String url,String fileName,ProgressCallback onReceiveProgress,VoidCallback completedHandle}) async {
    String path = await _requestStoragePermission(url:url,fileName: fileName);
    if (path.isEmpty) return;
    // LogUtil.d('tamp path = $path');

    Dio dio = new Dio();
    dio.options.baseUrl = url;
    //设置连接超时时间
    dio.options.connectTimeout = 10000;
    //设置数据接收超时时间
    dio.options.receiveTimeout = 10000;
    Response response;
    try {
      response = await dio.download(
        '',
        path,
        onReceiveProgress: onReceiveProgress,
      );
      if (response.statusCode == 200) {
        AppUtil.showToastCenter('下载完成');
        if(completedHandle != null)
          completedHandle();
      } else {
        throw Exception('接口出错');
      }
    } catch (e) {
      AppUtil.showToastCenter('服务器出错或网络连接失败！');
      // showTotast('服务器出错或网络连接失败！');
      return print('ERROR:======>$e');
    }
  }
  ///字符串转list，主要是在工作报告的接口中使用
  static List<String> getListFromString(String str){
    if(str == null || str.isEmpty) return [];
    List list = jsonDecode(str);
    if(list == null || list.isEmpty) return [];
    List<String> targetList = [];
    list.forEach((element) {
      targetList.add(element);
    });
    return targetList;
  }
  ///月份转数字
  static double monthToNumber(String month){
    switch(month){
      case '一月':
        return 1;
      case '二月':
        return 2;
      case '三月':
        return 3;
      case '四月':
        return 4;
      case '五月':
        return 5;
      case '六月':
        return 6;
      case '七月':
        return 7;
      case '八月':
        return 8;
      case '九月':
        return 9;
      case '十月':
        return 10;
      case '十一月':
        return 11;
      case '十二月':
        return 12;
    }
    return 1;
  }
  ///季度转数字
  static double sessionToNumber(String month){
    switch(month){
      case '一季度':
        return 1;
      case '二季度':
        return 2;
      case '三季度':
        return 3;
      case '四季度':
        return 4;
    }
    return 1;
  }
  ///String转double
  static double stringToDouble(String str){
    return  double.parse((str != null && str.isNotEmpty) ? str : '0');
  }
}
