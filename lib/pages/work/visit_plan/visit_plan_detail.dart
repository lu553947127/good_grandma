import 'package:flutter/material.dart';

///拜访计划详细
class VisitPlanDetail extends StatefulWidget {
  var data;
  VisitPlanDetail({Key key, this.data}) : super(key: key);

  @override
  _VisitPlanDetailState createState() => _VisitPlanDetailState();
}

class _VisitPlanDetailState extends State<VisitPlanDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("拜访计划详细", style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset('assets/images/sign_in_bg.png'),
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.data['title'], style: TextStyle(fontSize: 18, color: Colors.white)),
                          // Container(
                          //   padding: EdgeInsets.all(2),
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(2),
                          //     border: Border.all(
                          //         width: 1,
                          //         style: BorderStyle.solid,
                          //         color: Colors.white),
                          //   ),
                          //   child: Text("已结束", style: TextStyle(fontSize: 12, color: Colors.white)),
                          // )
                        ]
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Image.asset('assets/images/icon_plan_time.png', width: 15, height: 15),
                          SizedBox(width: 5),
                          Text(widget.data['visitTime'], style: TextStyle(fontSize: 12, color: Colors.white))
                        ]
                      ),
                      SizedBox(height: 10),
                      Row(
                          children: [
                            Image.asset('assets/images/icon_plan_name.png', width: 15, height: 15),
                            SizedBox(width: 5),
                            Text(widget.data['userName'], style: TextStyle(fontSize: 12, color: Colors.white))
                          ]
                      ),
                      SizedBox(height: 10),
                      Row(
                          children: [
                            Image.asset('assets/images/icon_plan_address.png', width: 15, height: 15),
                            SizedBox(width: 5),
                            Text(widget.data['address'], style: TextStyle(fontSize: 12, color: Colors.white))
                          ]
                      )
                    ]
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("拜访内容", style: TextStyle(fontSize: 14, color: Color(0XFF959EB1))),
                SizedBox(height: 10),
                Text(widget.data['visitContent'],
                    style: TextStyle(fontSize: 14, color: Color(0XFF2F4058)))
              ],
            ),
          )
        ],
      ),
    );
  }
}
