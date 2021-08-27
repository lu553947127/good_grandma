import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';

///单选选择页面
class SelectFormPage extends StatelessWidget {
  SelectFormPage({Key key,
    this.url,
    this.title
  }) : super(key: key);

  final String url;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(title,style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
      ),
      body: FutureBuilder(
        future: requestGet(url),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            var data = jsonDecode(snapshot.data.toString());
            LogUtil.d('请求结果---url----$data');
            List<Map> list = (data['data'] as List).cast();
            LogUtil.d('请求结果---list----$list');
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Center(
                    child: Text(list[index]['dictValue'], style: TextStyle(fontSize: 15, color: Color(0XFF2F4058))),
                  ),
                  onTap: () {
                    String value = list[index]['dictValue'];
                    Navigator.of(context).pop(value);
                  },
                );
              },
            );
          }else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

///选择返回回调
Future<String> showSelect(BuildContext context, url, title) async {
  String result;
  result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SelectFormPage(
        url: url,
        title: title,
      ),
    ),
  );
  return result ?? "";
}
