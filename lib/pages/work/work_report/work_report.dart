import 'package:flutter/material.dart';

///工作报告
class WorkReport extends StatefulWidget {
  const WorkReport({Key key}) : super(key: key);

  @override
  _WorkReportState createState() => _WorkReportState();
}

class _WorkReportState extends State<WorkReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("工作报告",style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
      ),
      body: Container(
        child: ButtonBar(
          children: <Widget>[
            RaisedButton(),
            RaisedButton(),
            RaisedButton(),
            RaisedButton(),
          ],
        ),
      ),
    );
  }
}
