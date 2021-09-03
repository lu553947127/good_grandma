import 'dart:async';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/loading_widget.dart';

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
            return Padding(padding: const EdgeInsets.all(15.0),
                child: Card(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(snapshot.data.toString(),style: const TextStyle(color: AppColors.FF2F4058,fontSize: 14.0)),
                  ),
                ),
            ),
            );
          }
          if (snapshot.hasError) {
            return LoadFailWidget(retryAction: _refresh);
          }
          return LoadingWidget();
        },
      ),
    );
  }

  void _refresh() async {
    await Future.delayed(Duration(seconds: 1), () {
      _controller.sink.add(
          '成武县鑫盛源食品有限公司是一家专注于冰淇淋研发及生产的企业。公司建有专业的冷食研发基地，并拥有优质的食品原料上游供应链、先进的冰淇淋生产机械及高标准的食品生产管理团队。好阿婆始终严格把控产品质量，确保每一支雪糕都保留它原有的自然味道。 好阿婆是鑫盛源旗下的第一品牌，也是山东省冷冻食品行业的知名品牌。公司以市场为导向，以创新为动力，不断提升管理水平和产品质量。产品直销遍布全国，多年来得到全国消费者的支持与信赖。');
      // _controller.sink.addError('error');
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.close();
  }
}
