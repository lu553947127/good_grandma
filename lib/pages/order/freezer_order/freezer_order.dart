import 'package:flutter/material.dart';

///冰柜订单页面
class FreezerOrderPage extends StatefulWidget {
  const FreezerOrderPage({Key key}) : super(key: key);

  @override
  _FreezerOrderPageState createState() => _FreezerOrderPageState();
}

class _FreezerOrderPageState extends State<FreezerOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text("冰柜订单", style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700))
      ),
    );
  }
}
