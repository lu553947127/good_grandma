import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_log/dio_log.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/application.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/store.dart';
import 'package:good_grandma/pages/login/login.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:package_info/package_info.dart';
import 'package:path/path.dart';

///post接口请求
Future requestPostLogin(url, {formData}) async{
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  Response response;
  try{
    var headers = Map<String, String>();
    headers['Content-Type'] = 'application/x-www-form-urlencoded';
    headers['Tenant-Id'] = '000000';
    headers['Authorization'] = 'Basic YXBwOmFwcF9oYW9hcG8=';
    headers['version'] = packageInfo.version;
    BaseOptions options = new BaseOptions(
        connectTimeout: 1000 * 10,
        receiveTimeout: 1000 * 5,
        responseType: ResponseType.plain,
        followRedirects: false,
        validateStatus: (status) { return status < 500; }
    );

    Dio dio = new Dio(options);
    dio.interceptors.add(DioLogInterceptor());
    dio.options.headers.addAll(headers);
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        return true;
      };
    };
    response = await dio.post(Api.baseUrl() + url, data: formData);
    return response.data;
  } on DioError catch(e){
    LogUtil.d('ERROR:===$url===>$e');
    if (e.response.statusCode == 500){
      EasyLoading.showToast('接口报500啦');
      throw e;
    }else if (e.response.statusCode == 404){
      EasyLoading.showToast('接口报404啦');
      throw e;
    }
    throw e;
  }
}

///post接口请求
Future requestPostSwitch(url, {formData}) async{
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  Response response;
  try{
    var headers = Map<String, String>();
    headers['Content-Type'] = 'application/x-www-form-urlencoded';
    headers['Tenant-Id'] = '000000';
    headers['Authorization'] = 'Basic YXBwOmFwcF9oYW9hcG8=';
    headers['Blade-Auth'] = 'bearer ${Store.readToken()}';
    headers['version'] = packageInfo.version;
    BaseOptions options = new BaseOptions(
        connectTimeout: 1000 * 10,
        receiveTimeout: 1000 * 5,
        responseType: ResponseType.plain,
        followRedirects: false,
        validateStatus: (status) { return status < 500; }
    );

    Dio dio = new Dio(options);
    dio.interceptors.add(DioLogInterceptor());
    dio.options.headers.addAll(headers);
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        return true;
      };
    };

    response = await dio.post(Api.baseUrl() + url, data: formData);

    return response.data;
  } on DioError catch(e){
    LogUtil.d('ERROR:===$url===>$e');
    if (e.response.statusCode == 500){
      EasyLoading.showToast('接口报500啦');
      throw e;
    }else if (e.response.statusCode == 404){
      EasyLoading.showToast('接口报404啦');
      throw e;
    }
    throw e;
  }
}

///post接口请求
Future requestPost(url, {formData, json}) async{
  try{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var headers = Map<String, String>();
    headers['Content-Type'] = 'application/json';
    headers['Tenant-Id'] = '000000';
    headers['Authorization'] = 'Basic YXBwOmFwcF9oYW9hcG8=';
    headers['Blade-Auth'] = 'bearer ${Store.readToken()}';
    headers['version'] = packageInfo.version;
    Response response;
    BaseOptions options = new BaseOptions(
        connectTimeout: 1000 * 10,
        receiveTimeout: 1000 * 5,
        responseType: ResponseType.plain,
        followRedirects: false,
        validateStatus: (status) { return status < 500; }
    );

    Dio dio = new Dio(options);
    dio.interceptors.add(DioLogInterceptor());
    dio.options.headers.addAll(headers);
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        return true;
      };
    };

    if(formData != null){
      response = await dio.post(Api.baseUrl() + url, data: formData);
    }else if(json != null){
      response = await dio.post(Api.baseUrl() + url, data: json);
    }else{
      response = await dio.post(Api.baseUrl() + url);
    }
    _dealResponseDataFroError(response);
    return response.data;
  } on DioError catch(e){
    LogUtil.d('ERROR:===$url===>$e');
    if (e.response.statusCode == 401 || e.response.statusCode == 403){
      EasyLoading.showToast('登录token过期，请重新登录');
      Store.removeToken();
      Navigator.pushAndRemoveUntil(Application.appContext, MaterialPageRoute(builder:(context)=> LoginPage()), (route) => false);
      throw e;
    }else if (e.response.statusCode == 500){
      EasyLoading.showToast('接口报500啦');
      throw e;
    }else if (e.response.statusCode == 404){
      EasyLoading.showToast('接口报404啦');
      throw e;
    }
    throw e;
  }
}

///get接口请求
Future requestGet(url, {param})async{
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  Response response;
  try{
    var headers = Map<String, String>();
    headers['Content-Type'] = 'application/json';
    headers['Tenant-Id'] = '000000';
    headers['Authorization'] = 'Basic YXBwOmFwcF9oYW9hcG8=';
    headers['Blade-Auth'] = 'bearer ${Store.readToken()}';
    headers['version'] = packageInfo.version;
    BaseOptions options = new BaseOptions(
      connectTimeout: 1000 * 10,
      receiveTimeout: 1000 * 5,
      responseType: ResponseType.plain,
    );
    Dio dio = new Dio(options);
    dio.interceptors.add(DioLogInterceptor());
    dio.options.headers.addAll(headers);
    dio.options.contentType = 'application/x-www-form-urlencoded';

    if(param == null){
      response = await dio.get(Api.baseUrl() + url);
    }else{
      response = await dio.get(Api.baseUrl() + url, queryParameters: param);
    }
    _dealResponseDataFroError(response);
    return response.data;
  } on DioError catch(e){
    LogUtil.d('ERROR:===$url===>$e');
    if (e.response.statusCode == 401 || e.response.statusCode == 403){
      EasyLoading.showToast('登录token过期，请重新登录');
      Store.removeToken();
      Navigator.pushAndRemoveUntil(Application.appContext, MaterialPageRoute(builder:(context)=> LoginPage()), (route) => false);
      throw e;
    }else if (e.response.statusCode == 500){
      EasyLoading.showToast('接口报500啦');
      throw e;
    }else if (e.response.statusCode == 404){
      EasyLoading.showToast('接口报404啦');
      throw e;
    }
    throw e;
  }
}
///对接口返回的非200的错误信息进行显示
void _dealResponseDataFroError(Response response){
  var data = jsonDecode(response.data.toString());
  if(data['code'] == 200) return;
  if (data['code'] == 401 || data['code'] == 403){
    EasyLoading.showToast('登录token过期，请重新登录');
    Store.removeToken();
    Navigator.pushAndRemoveUntil(Application.appContext, MaterialPageRoute(builder:(context)=> LoginPage()), (route) => false);
    return;
  }
  String msg = data['msg'];
  if(msg != null && msg.isNotEmpty)
  EasyLoading.showToast(msg);
  throw DioError(requestOptions: response.requestOptions,error: response.data);
}

///上传附件
Future getPutFile(url, file) async{
  try{
    print('开始上传图片...............'+file);
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var headers = Map<String, String>();
    headers['Tenant-Id'] = '000000';
    headers['Authorization'] = 'Basic YXBwOmFwcF9oYW9hcG8=';
    headers['Blade-Auth'] = 'bearer ${Store.readToken()}';
    headers['version'] = packageInfo.version;
    Response response;
    BaseOptions options = new BaseOptions(
      connectTimeout: 1000 * 10,
      receiveTimeout: 1000 * 5,
      responseType: ResponseType.plain,
    );
    Dio dio = new Dio(options);
    dio.options.headers.addAll(headers);
    var name = file.substring(file.lastIndexOf("/") + 1, file.length);
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file, filename:name)
    });
    response = await dio.post(
        Api.baseUrl() + url,
        data: formData,
        onSendProgress: (progress, total){
          Future.delayed(Duration(milliseconds: 50)).then((value) {
            final currentProgress = (progress / total);
            EasyLoading.showProgress(
                currentProgress,
                status: '${(currentProgress * 100).toStringAsFixed(0)}%'
            );
            if (currentProgress >= 1) {
              EasyLoading.dismiss();
            }
            print("总进度==$total===当前的进度===$progress====百分比===${(currentProgress * 100).toStringAsFixed(0)}%====$currentProgress");
          });
        }
    );
    _dealResponseDataFroError(response);
    return response.data;
  } on DioError catch(e){
    LogUtil.d('ERROR:===$url===>$e');
    if (e.response.statusCode == 401 || e.response.statusCode == 403){
      EasyLoading.showToast('登录token过期，请重新登录');
      Store.removeToken();
      Navigator.pushAndRemoveUntil(Application.appContext, MaterialPageRoute(builder:(context)=> LoginPage()), (route) => false);
      throw e;
    }else if (e.response.statusCode == 500){
      EasyLoading.showToast('接口报500啦');
      throw e;
    }else if (e.response.statusCode == 404){
      EasyLoading.showToast('接口报404啦');
      throw e;
    }
    throw e;
  }
}

///上传附件到阿里oss
Future getPutAliOssFile(url, File file) async{
  try{
    LogUtil.d('开始上传图片:===${file.path}');

    ///将Policy进行Base64编码
    String encodePolicy = base64Encode(utf8.encode(Store.readOssPolicy()));
    /// 生成签名
    String signature = getSignature(encodePolicy);
    /// 用 package:path/path.dart 库获取图片名称
    String fileName = basename(file.path);
    ///根据dir返回的设置开头并存入文件目录下
    fileName = '${Store.readOssDir()}$fileName';

    var formData = FormData.fromMap({
      'key': fileName,
      'success_action_status': 200,///如果该域的值设置为200或者204，OSS返回一个空文档和相应的状态码。
      'OSSAccessKeyId': Store.readOssAccessKeyId(),
      'policy': encodePolicy,
      'Signature': signature,
      'Content-Type': 'image/jpeg',
      'file': await MultipartFile.fromFile(file.path),
    });

    LogUtil.d('key:===$fileName');
    LogUtil.d('OSSAccessKeyId:===${Store.readOssAccessKeyId()}');
    LogUtil.d('sk:===y4yRa5tm1rYDOSwNQtoUh9Q9RJ0tfC');
    LogUtil.d('encodePolicy:===${Store.readOssPolicy()}');
    LogUtil.d('policy:===$encodePolicy');
    LogUtil.d('Signature:===$signature');

    Dio dio = Dio();
    var response = await dio.post(Store.readOssEndpoint(), data: formData, onSendProgress: (int progress, int total){
      Future.delayed(Duration(milliseconds: 50)).then((value) {
        final currentProgress = (progress / total);
        EasyLoading.showProgress(
            currentProgress,
            status: '${(currentProgress * 100).toStringAsFixed(0)}%'
        );
        if (currentProgress >= 1) {
          EasyLoading.dismiss();
        }
        // print("总进度==$total===当前的进度===$progress====百分比===${(currentProgress * 100).toStringAsFixed(0)}%====$currentProgress");
      });
    });

    LogUtil.d('response.headers:===${response.headers}');


    Map param = {
      'link': '${Store.readOssEndpoint()}/$fileName',
      'originalName': fileName
    };

    LogUtil.d('image:===$param');

    return param;
  } on DioError catch(e){
    LogUtil.d('ERROR:===${Store.readOssEndpoint()}===>$e');
    LogUtil.d('ERROR:===${Store.readOssEndpoint()}===>${DioErrorType.response.toString()}');
    if (e.response.statusCode == 401 || e.response.statusCode == 403){
      EasyLoading.showToast('上传失败：${e.response.statusCode}');
      throw e;
    }else if (e.response.statusCode == 500){
      EasyLoading.showToast('接口报500啦');
      throw e;
    }else if (e.response.statusCode == 404){
      EasyLoading.showToast('接口报404啦');
      throw e;
    }
    throw e;
  }
}

///获取阿里云oss的加密参数Signature
String getSignature(String encodePolicy){
  var key = utf8.encode("y4yRa5tm1rYDOSwNQtoUh9Q9RJ0tfC");
  var bytes = utf8.encode(encodePolicy);

  var hmacSha1 = new Hmac(sha1, key);
  Digest sha1Result = hmacSha1.convert(bytes);
  print("sha1Result:$sha1Result");

  String signature = base64Encode(sha1Result.bytes);
  print("signature:$signature");
  return signature;
}