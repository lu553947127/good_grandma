import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/application.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/login/loginBtn.dart';
import 'package:good_grandma/provider/image_provider.dart';
import 'package:good_grandma/widgets/add_content_input.dart';
import 'package:good_grandma/widgets/add_text_input.dart';
import 'package:good_grandma/widgets/photos_cell.dart';
import 'package:provider/provider.dart';

///客户拜访
class CustomerVisitAdd extends StatefulWidget {
  const CustomerVisitAdd({Key key}) : super(key: key);

  @override
  _CustomerVisitAddState createState() => _CustomerVisitAddState();
}

class _CustomerVisitAddState extends State<CustomerVisitAdd> {

  ImagesProvider imagesProvider = new ImagesProvider();
  String customerName = '';
  String visitContent = '';
  double latitude = 0.0;
  double longitude = 0.0;
  String address = '';

  ///新增
  _customerVisitAdd(){
    Map<String, dynamic> map = {
      'customerName': customerName,
      'visitContent': visitContent,
      'ipicture': listToString(imagesProvider.urlList),
      'latitude': latitude,
      'longitude': longitude,
      'address': address};

    requestPost(Api.customerVisitAdd, json: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---customerVisitAdd----$data');
      if (data['code'] == 200){
        showToast("添加成功");
        Navigator.of(Application.appContext).pop('refresh');
      }else {
        showToast(data['msg']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("客户拜访",style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextInputView(
              rightLength: 120,
              leftTitle: '客户姓名',
              rightPlaceholder: '请输入客户名称',
              onChanged: (tex){
                customerName = tex;
              }
            ),
            ContentInputView(
              sizeHeight: 10,
              color: Colors.white,
              leftTitle: '行动过程',
              rightPlaceholder: '行动过程',
              onChanged: (tex){
                visitContent = tex;
              }
            ),
            ChangeNotifierProvider<ImagesProvider>.value(
                value: imagesProvider,
                child:  CustomPhotoWidget(
                  title: '上传照片',
                  length: 3,
                  sizeHeight: 10,
                  url: Api.putFile
                )
            ),
            Container(
              margin: EdgeInsets.only(left: 10, top: 10),
              child: Row(
                children: [
                  Image.asset('assets/images/icon_address.png', width: 12, height: 12),
                  SizedBox(width: 3),
                  Text('济南市历城区舜华路舜泰广场', style: TextStyle(fontSize: 12, color: Color(0XFF2F4058)))
                ]
              )
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: LoginBtn(
                title: '提交',
                onPressed: _customerVisitAdd
              )
            )
          ]
        )
      )
    );
  }
}
