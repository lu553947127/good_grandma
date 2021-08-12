import 'package:flutter/material.dart';
import 'package:good_grandma/common/application.dart';
import 'package:good_grandma/pages/form/form_dynamic_page.dart';
import 'package:good_grandma/pages/form/form_page.dart';

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
        title: Text("示例"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("基本使用"),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FormPage(),
                ),
              );
            },
          ),
          Divider(
            height: 0.5,
            thickness: 0.5,
          ),
          ListTile(
            title: Text("动态表单"),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FormDynamicPage(),
                ),
              );
            },
          ),
          Divider(
            height: 0.5,
            thickness: 0.5,
          ),
        ],
      ),
    );
  }
}
