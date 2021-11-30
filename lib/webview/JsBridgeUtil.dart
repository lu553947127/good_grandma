import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/webview/JsBridge.dart';
import 'package:good_grandma/widgets/select_image.dart';
import 'package:webview_flutter/webview_flutter.dart';

class JsBridgeUtil {
  /// 将json字符串转化成对象
  static JsBridge parseJson(String jsonStr) {
    JsBridge jsBridgeModel = JsBridge.fromMap(jsonDecode(jsonStr));
    return jsBridgeModel;
  }

  /// 向H5开发接口调用
  static executeMethod(context, JsBridge jsBridge, WebViewController _webViewController) async{
    LogUtil.d('jsBridge.method------------${jsBridge}');
    if (jsBridge.method == 'wf_start') {
      Navigator.of(context).pop(true);
      jsBridge.success?.call();

      LogUtil.d('jsBridge.method------------${jsBridge.method}');
    }

    if (jsBridge.method == 'wf_upload') {
      LogUtil.d('jsBridge.method------------${jsBridge.method}');
      LogUtil.d('jsBridge.method------------${jsBridge.data}');

      showImageRange(
          context: context,
          callBack: (Map param){
            // 之后可以调用 _webViewController 的 evaluateJavascript 属性来注入JS
            _webViewController.evaluateJavascript("javascript:wf_upload_callback(\""+jsBridge.data['prop']+"\",\""+param['name']+"\",\""+param['image']+"\")");
          }
      );
      return;
    }
  }
}