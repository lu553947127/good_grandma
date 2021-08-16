import 'package:flutter/material.dart';

class LoginEditText extends StatelessWidget {

  TextEditingController textEditingController = TextEditingController();
  var text;
  var images;
  TextInputType type;

  LoginEditText({Key key
    , @required this.textEditingController
    , @required this.text
    , @required this.images
    , @required this.type
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      height: 40,
      decoration: new BoxDecoration(
        color: Color(0xFFF7F7F7),
        borderRadius: new BorderRadius.all(new Radius.circular(35.0)),
      ),
      child: TextField(
        controller: textEditingController,
        keyboardType: type,//输入类型
        style: TextStyle(fontSize: 15,color: Color(0xFF333333)),
        cursorColor: Color(0xFFC68D3E),//修改光标颜色
        decoration: InputDecoration(
            hintText: text,
            hintStyle: TextStyle(fontSize: 15,color: Color(0XFFC1C8D7)),
            border: InputBorder.none,//去掉下划线
            icon: Padding(
              padding: EdgeInsets.all(8),
              child: Image.asset(images, width: 16, height: 16),
            ),
        ),
      ),
    );
  }
}
