import 'package:flutter/material.dart';
import 'package:good_grandma/common/application.dart';
import 'package:good_grandma/pages/form/form_dynamic_page.dart';
import 'package:good_grandma/pages/form/form_page.dart';

///首页
class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Application.appContext = context;
    return Scaffold(
      appBar: AppBar(
        title: Text("首页"),
      ),
      body: Container(),
    );
  }
}
