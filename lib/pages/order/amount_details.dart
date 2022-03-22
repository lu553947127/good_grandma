import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';

///补货金额明细
class AmountDetails extends StatefulWidget {
  final String userId;
  const AmountDetails({Key key, this.userId}) : super(key: key);

  @override
  _AmountDetailsState createState() => _AmountDetailsState();
}

class _AmountDetailsState extends State<AmountDetails> {

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> map = {'userId': widget.userId};
    return Scaffold(
        appBar: AppBar(title: Text('明细')),
        body: FutureBuilder(
            future: requestPost(Api.amountDetails, formData: map),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                var data = jsonDecode(snapshot.data.toString());
                LogUtil.d('请求结果---amountDetails----$data');
                List<Map> list = (data['data'] as List).cast();
                LogUtil.d('请求结果---list----$list');
                return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                          title: Center(
                            child: Text('${list[index]['typeStr']}：${list[index]['total']}',
                                style: TextStyle(fontSize: 15, color: Color(0XFF2F4058))),
                          ),
                          onTap: null
                      );
                    }
                );
              }else {
                return Center(
                  child: CircularProgressIndicator(color: AppColors.FFC68D3E),
                );
              }
            }
        )
    );
  }
}
