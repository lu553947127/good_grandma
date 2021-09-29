import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/loading_widget.dart';
import 'package:good_grandma/common/log.dart';

///关于我们页面
class AboutUsPage extends StatefulWidget {
  const AboutUsPage({Key key}) : super(key: key);

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {

  final _controller = StreamController();

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('关于我们')),
      body: StreamBuilder(
        stream: _controller.stream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15.0),
              child: Card(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(snapshot.data.toString(),style: const TextStyle(color: AppColors.FF2F4058,fontSize: 14.0)),
                  )
                )
              )
            );
          }
          if (snapshot.hasError) {
            return LoadFailWidget(retryAction: _refresh);
          }
          return LoadingWidget();
        }
      )
    );
  }

  void _refresh() async {
    requestGet(Api.getAbout).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---getAbout----$data');
      await Future.delayed(Duration(seconds: 1));
      await Future.delayed(Duration(seconds: 1), () {
        _controller.sink.add('${data['data']['content']}');
        // _controller.sink.addError('error');
      });
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.close();
  }
}
