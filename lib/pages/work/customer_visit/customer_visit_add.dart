import 'package:flutter/material.dart';
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

  TextEditingController controllerName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ImagesProvider imagesProvider = new ImagesProvider();
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
              textEditingController: controllerName,
              type: TextInputType.text,
            ),
            SizedBox(
                width: double.infinity,
                height: 10,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Color(0xFFF5F5F8)),
                )
            ),
            ContentInputView(
              color: Colors.white,
              leftTitle: '行动过程',
              rightPlaceholder: '行动过程',
              onChanged: (tex){

              },
            ),
            SizedBox(
                width: double.infinity,
                height: 10,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Color(0xFFF5F5F8)),
                )
            ),
            ChangeNotifierProvider<ImagesProvider>.value(
                value: imagesProvider,
                child:  CustomPhotoWidget(
                  title: '上传照片',
                  length: 3,
                )
            ),
            Container(
              margin: EdgeInsets.only(left: 10, top: 10),
              child: Row(
                children: [
                  Image.asset('assets/images/icon_address.png', width: 12, height: 12),
                  SizedBox(width: 3),
                  Text('济南市历城区舜华路舜泰广场', style: TextStyle(fontSize: 12, color: Color(0XFF2F4058)))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: LoginBtn(
                title: '提交',
                onPressed: (){

                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
