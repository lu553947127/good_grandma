import 'package:flutter/material.dart';
import 'package:good_grandma/pages/login/loginBtn.dart';
import 'package:good_grandma/widgets/add_content_input.dart';
import 'package:good_grandma/widgets/add_text_input.dart';
import 'package:good_grandma/widgets/add_text_select.dart';

///新增拜访计划
class VisitPlanAdd extends StatefulWidget {
  const VisitPlanAdd({Key key}) : super(key: key);

  @override
  _VisitPlanAddState createState() => _VisitPlanAddState();
}

class _VisitPlanAddState extends State<VisitPlanAdd> {

  TextEditingController controllerTitle = TextEditingController();
  TextEditingController controllerAddress = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("新增拜访计划",style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextInputView(
              rightLength: 80,
              leftTitle: '标题',
              rightPlaceholder: '请输入标题',
              textEditingController: controllerTitle,
              type: TextInputType.text,
            ),
            SizedBox(
              width: double.infinity,
              height: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Color(0xFFF5F5F8)),
              )
            ),
            TextSelectView(
              leftTitle: '拜访时间',
              rightPlaceholder: '请选择拜访时间',
              onPressed: (){},
            ),
            SizedBox(
                width: double.infinity,
                height: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Color(0xFFF5F5F8)),
                )
            ),
            TextSelectView(
              leftTitle: '客户名称',
              rightPlaceholder: '请选择客户',
              onPressed: (){},
            ),
            SizedBox(
                width: double.infinity,
                height: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Color(0xFFF5F5F8)),
                )
            ),
            TextInputView(
              rightLength: 80,
              leftTitle: '客户地址',
              rightPlaceholder: '关联地址',
              textEditingController: controllerAddress,
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
              leftTitle: '备注',
              rightPlaceholder: '备注信息',
              onChanged: (tex){

              },
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
