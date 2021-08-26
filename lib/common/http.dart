import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/application.dart';
import 'package:good_grandma/common/store.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/login/login.dart';

///post接口请求
Future requestPostLogin(url, {formData}) async{
  Response response;
  try{
    var headers = Map<String, String>();
    headers['Content-Type'] = 'application/x-www-form-urlencoded';
    headers['Tenant-Id'] = '000000';
    headers['Authorization'] = 'Basic c2FiZXI6c2FiZXJfc2VjcmV0';
    BaseOptions options = new BaseOptions(
        connectTimeout: 1000 * 10,
        receiveTimeout: 1000 * 5,
        responseType: ResponseType.plain,
        followRedirects: false,
        validateStatus: (status) { return status < 500; }
    );

    Dio dio = new Dio(options);
    dio.options.headers.addAll(headers);
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        return true;
      };
    };

    response = await dio.post(Api.baseUrl() + url, data: formData);

    return response.data;
  }catch(e){
    print('ERROR:===$url===>$e');
    print('ERROR:===${response.data}');
    return print('ERROR:===$url===>$e');
  }
}


///post接口请求
Future requestPost(url, {formData, json}) async{
  try{
    var headers = Map<String, String>();
    headers['Content-Type'] = 'application/json';
    headers['Tenant-Id'] = '000000';
    headers['Authorization'] = 'Basic c2FiZXI6c2FiZXJfc2VjcmV0';
    headers['Blade-Auth'] = 'bearer ${Store.readToken()}';
    Response response;
    BaseOptions options = new BaseOptions(
        connectTimeout: 1000 * 10,
        receiveTimeout: 1000 * 5,
        responseType: ResponseType.plain,
        followRedirects: false,
        validateStatus: (status) { return status < 500; }
    );

    Dio dio = new Dio(options);
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

    return response.data;
  } on DioError catch(e){
    if (e.response.statusCode == 401){
      showToast('登录token过期，请重新登录');
      Store.removeToken();
      Navigator.pushReplacement(Application.appContext, MaterialPageRoute(builder: (_) => LoginPage()));
      return;
    }
    return print('ERROR:===$url===>$e');
  }
}

///get接口请求
Future requestGet(url, {param})async{
  Response response;
  try{
    var headers = Map<String, String>();
    headers['Content-Type'] = 'application/json';
    headers['Tenant-Id'] = '000000';
    headers['Authorization'] = 'Basic c2FiZXI6c2FiZXJfc2VjcmV0';
    headers['Blade-Auth'] = 'bearer ${Store.readToken()}';
    BaseOptions options = new BaseOptions(
      connectTimeout: 1000 * 10,
      receiveTimeout: 1000 * 5,
      responseType: ResponseType.plain,
    );
    Dio dio = new Dio(options);
    dio.options.headers.addAll(headers);
    dio.options.contentType = 'application/x-www-form-urlencoded';

    if(param == null){
      response = await dio.get(Api.baseUrl() + url);
    }else{
      response = await dio.get(Api.baseUrl() + url, queryParameters: param);
    }

    return response.data;
  } on DioError catch(e){
    if (e.response.statusCode == 401 || e.response.statusCode == 404){
      showToast('登录token过期，请重新登录');
      Store.removeToken();
      Navigator.pushReplacement(Application.appContext, MaterialPageRoute(builder: (_) => LoginPage()));
      return print('ERROR:===$url===>$e');
    }
    return print('ERROR:===$url===>$e');
  }
}

///上传附件
Future getPutFile(file) async{
  try{
    print('开始上传图片...............'+file);
    var headers = Map<String, String>();
    headers['Tenant-Id'] = '000000';
    headers['Authorization'] = 'Basic c2FiZXI6c2FiZXJfc2VjcmV0';
    headers['Blade-Auth'] = 'bearer ${Store.readToken()}';
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
    response = await dio.post(Api.baseUrl() + Api.putFile, data: formData);
    return response.data;
  } on DioError catch(e){
    // if (e.response.statusCode == 401 || e.response.statusCode == 404){
    //   showToast('登录token过期，请重新登录');
    //   Store.removeToken();
    //   Navigator.pushReplacement(Application.appContext, MaterialPageRoute(builder: (_) => LoginPage()));
    //   return print('ERROR:==putFile===>$e');
    // }
    return print('ERROR:==putFile===>$e');
  }
}