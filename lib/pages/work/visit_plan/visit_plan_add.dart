import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/pages/login/loginBtn.dart';
import 'package:good_grandma/widgets/add_text_input.dart';
import 'package:good_grandma/widgets/add_text_select.dart';
import 'package:good_grandma/widgets/introduce_input.dart';

///新增拜访计划
class VisitPlanAdd extends StatefulWidget {
  const VisitPlanAdd({Key key}) : super(key: key);

  @override
  _VisitPlanAddState createState() => _VisitPlanAddState();
}

class _VisitPlanAddState extends State<VisitPlanAdd> {

  TextEditingController controllerTitle = TextEditingController();

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
              leftTitle: '客户地址',
              rightPlaceholder: '关联地址',
              textEditingController: controllerTitle,
              type: TextInputType.text,
            ),
            SizedBox(
                width: double.infinity,
                height: 10,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Color(0xFFF5F5F8)),
                )
            ),
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 20),
                    child: Text('备注', style: const TextStyle(color: AppColors.FF070E28, fontSize: 15.0))
                  ),
                  SizedBox(height: 0),
                  Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: InputWidget(
                        placeholder: '备注信息',
                        onChanged: (String txt){
                          // inputText = txt;
                        },
                      )
                  )
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
