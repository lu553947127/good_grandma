import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/models/add_dealer_model.dart';
import 'package:good_grandma/pages/open_account/open_business_representative.dart';
import 'package:good_grandma/pages/open_account/open_dealer_page.dart';
import 'package:provider/provider.dart';

///开通账号
class OpenAccountPage extends StatelessWidget {
  const OpenAccountPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('开通账号')),
      body: Container(
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            boxShadow: [
              BoxShadow(
                  offset: Offset(2, 1), //x,y轴
                  color: Colors.black.withOpacity(0.1), //投影颜色
                  blurRadius: 1 //投影距离
              )
            ]),
        child: FutureBuilder(
          future: requestGet(Api.customerType),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              var data = jsonDecode(snapshot.data.toString());
              LogUtil.d('请求结果---customerType----$data');
              List<Map> list = (data['data'] as List).cast();
              LogUtil.d('请求结果---list----$list');
              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.only(top: 5.0, left: 45.0, right: 45.0),
                    child: OutlinedButton(
                        onPressed: () {
                          AddDealerModel _model = AddDealerModel();
                          _model.setPost('${list[index]['id']}-${list[index]['postCode']}');
                          _model.setPostName(list[index]['postName']);

                          if (_model.postName == '业务代表'){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ChangeNotifierProvider.value(
                                        value: _model, child: OpenBusinessRepresentative())));
                          }else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ChangeNotifierProvider.value(
                                        value: _model, child: OpenDealerPage())));
                          }
                        },
                        style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16))),
                        child: Text('${list[index]['postName']}',
                            style: TextStyle(
                                color: AppColors.FF2F4058, fontSize: 14.0))),
                  );
                }
              );
            }else {
              return Center(
                child: CircularProgressIndicator(color: AppColors.FFC68D3E)
              );
            }
          }
        )
      )
    );
  }
}
