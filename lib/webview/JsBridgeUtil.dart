import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/store.dart';
import 'package:good_grandma/webview/JsBridge.dart';
import 'package:good_grandma/widgets/select_image.dart';
import 'package:webview_flutter/webview_flutter.dart';

///flutter与h5 js混合交互
class JsBridgeUtil {
  /// 将json字符串转化成对象
  static JsBridge parseJson(String jsonStr) {
    JsBridge jsBridgeModel = JsBridge.fromMap(jsonDecode(jsonStr));
    return jsBridgeModel;
  }

  /// 向H5开发接口调用
  static executeMethod(context, JsBridge jsBridge, WebViewController _webViewController) async{
    if (jsBridge.method == 'wf_start') {
      Navigator.of(context).pop(true);
      jsBridge.success?.call();
    }

    if (jsBridge.method == 'wf_upload') {
      aliSignature(context, jsBridge, _webViewController);
      return;
    }
  }

  ///获取阿里oss配置信息
  static aliSignature(context, JsBridge jsBridge,  WebViewController _webViewController){
    Map<String, dynamic> map = {'dir': 'js_web'};
    requestPost(Api.aliSignature, json: jsonEncode(map)).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---aliSignature----$data');
      Store.saveOssAccessKeyId(data['data']['accessId']);
      Store.saveOssEndpoint(data['data']['host']);
      Store.saveOssPolicy(data['data']['policy']);
      Store.saveOssSignature(data['data']['signature']);
      Store.saveOssDir(data['data']['dir']);

      showImageRange (
          context: context,
          callBack: (Map param){
            // 之后可以调用 _webViewController 的 evaluateJavascript 属性来注入JS
            _webViewController.evaluateJavascript("javascript:wf_upload_callback(\""+jsBridge.data['prop']+"\",\""+param['name']+"\",\""+param['image']+"\")");
          }
      );
    });
  }
}