import 'package:flutter/material.dart';

class LoginBackground extends StatelessWidget {
  final Widget child;
  const LoginBackground({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Stack(
              alignment:Alignment.center,
              children: <Widget>[
                Image.asset('assets/images/ic_login_top.png'),
                Center(
                  child: Image.asset('assets/images/ic_login_logo.png', width: size.width/2, height: 140),
                )
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.asset('assets/images/ic_login_bottom.png'),
          ),
          child
        ],
      ),
    );
  }
}
