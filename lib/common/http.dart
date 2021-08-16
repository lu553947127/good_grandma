import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:good_grandma/common/api.dart';

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
Future requestPost(url, {formData})async{
  try{
    // SharedPreferences sharedPreferences = await  SharedPreferences.getInstance();
    var headers = Map<String, String>();
    headers['Content-Type'] = 'application/json';
    headers['Authorization'] = 'Basic c2FiZXI6c2FiZXJfc2VjcmV0';
    // headers['SQ-Auth'] = 'bearer ${sharedPreferences.getString(Api.accessTokenKey)}';
    Response response;
    BaseOptions options = new BaseOptions(
      connectTimeout: 1000 * 10,
      receiveTimeout: 1000 * 5,
      responseType: ResponseType.plain,
    );
    Dio dio = new Dio(options);
    dio.options.headers.addAll(headers);
    if(formData==null){
      response = await dio.post(Api.baseUrl() + url);
    }else{
      response = await dio.post(Api.baseUrl() + url, data:formData);
    }
    if(response.statusCode==200){
      return response.data;
    }else{
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  }catch(e){
    return print('ERROR:===$url===>$e');
  }
}

///get接口请求
Future requestGet(url, {param})async{
  try{
    // SharedPreferences sharedPreferences = await  SharedPreferences.getInstance();
    var headers = Map<String, String>();
    headers['Content-Type'] = 'application/json';
    headers['Authorization'] = 'Basic c2FiZXI6c2FiZXJfc2VjcmV0';
    // headers['SQ-Auth'] = 'bearer ${sharedPreferences.getString(Api.accessTokenKey)}';
    Response response;
    BaseOptions options = new BaseOptions(
      connectTimeout: 1000 * 10,
      receiveTimeout: 1000 * 5,
      responseType: ResponseType.plain,
    );
    Dio dio = new Dio(options);
    dio.options.headers.addAll(headers);
    dio.options.contentType = 'application/x-www-form-urlencoded';
    if(param==null){
      response = await dio.get(Api.baseUrl() + url);
    }else{
      response = await dio.get(Api.baseUrl() + url, queryParameters:param);
    }
    if(response.statusCode==200){
      return response.data;
    }else{
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  }catch(e){
    return print('ERROR:===$url===>$e');
  }
}