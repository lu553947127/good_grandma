import 'package:flutter/material.dart';

class LoginBtn extends StatelessWidget {
  final void Function() onPressed;
  final String title;

  LoginBtn({Key key, this.onPressed, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFC68D3E),Color(0xFFC68D3E)]), borderRadius: BorderRadius.circular(40)),
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
        color: Colors.transparent,
        elevation: 0,
        highlightElevation: 0,
        onPressed: onPressed,
        child: Container(
          alignment: Alignment.center,
          height: 40,
          child: Text(title, style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ),
    );
  }
}
