import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

///post接口请求
Future requestPost(url)async{
  Response response;
  try{

    var headers = Map<String, String>();
    headers['Content-Type'] = 'application/json';
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

    response = await dio.post(url);

    if(response.statusCode==200){
      return response.data;
    }else{
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  }catch(e){

    print('ERROR:===$url===>$e');
    print('ERROR:===${response.data}');
    return print('ERROR:===$url===>$e');
  }
}