import 'package:flutter/material.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/login/loginBtn.dart';
import 'package:good_grandma/pages/work/work_text.dart';
import 'package:good_grandma/widgets/add_text_input.dart';
import 'package:good_grandma/widgets/add_text_select.dart';

///新增市场物料
class MarketMaterialAdd extends StatefulWidget {
  const MarketMaterialAdd({Key key}) : super(key: key);

  @override
  _MarketMaterialAddState createState() => _MarketMaterialAddState();
}

class _MarketMaterialAddState extends State<MarketMaterialAdd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("新增市场物料",style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextSelectView(
                leftTitle: '区域',
                rightPlaceholder: '请选择区域',
                onPressed: (){
                  return showPickerModal(context, PickerData);
                }
              ),
              TextInputView(
                  rightLength: 120,
                  leftTitle: '物料',
                  rightPlaceholder: '请输入物料名称',
                  onChanged: (tex){

                  }
              ),
              TextInputView(
                  rightLength: 120,
                  leftTitle: '物料总量',
                  rightPlaceholder: '请输入物料总量',
                  type: TextInputType.number,
                  onChanged: (tex){

                  }
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: LoginBtn(
                  title: '提交',
                  onPressed: (){

                  }
                ),
              )
            ]
          )
        )
      )
    );
  }
}
