import 'package:flutter/material.dart';

///拜访计划详细
class VisitPlanDetail extends StatefulWidget {
  const VisitPlanDetail({Key key}) : super(key: key);

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
        title: Text("拜访计划详细",style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
      ),
      body: Column(
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
                          Text("拜访鲁信影城营业点经营情况", style: TextStyle(fontSize: 18, color: Colors.white)),
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              border: Border.all(
                                  width: 1,
                                  style: BorderStyle.solid,
                                  color: Colors.white),
                            ),
                            child: Text("已结束", style: TextStyle(fontSize: 12, color: Colors.white)),
                          )
                        ]
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Image.asset('assets/images/icon_plan_time.png', width: 15, height: 15),
                          SizedBox(width: 5),
                          Text("2021年7月20日 周二 11：00 - 12：00", style: TextStyle(fontSize: 12, color: Colors.white))
                        ]
                      ),
                      SizedBox(height: 10),
                      Row(
                          children: [
                            Image.asset('assets/images/icon_plan_name.png', width: 15, height: 15),
                            SizedBox(width: 5),
                            Text("客户名称", style: TextStyle(fontSize: 12, color: Colors.white))
                          ]
                      ),
                      SizedBox(height: 10),
                      Row(
                          children: [
                            Image.asset('assets/images/icon_plan_address.png', width: 15, height: 15),
                            SizedBox(width: 5),
                            Text("山东省济南市历城区", style: TextStyle(fontSize: 12, color: Colors.white))
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
                Text("备注", style: TextStyle(fontSize: 14, color: Color(0XFF959EB1))),
                SizedBox(height: 10),
                Text("拜访内容拜访内容拜访内容拜访内容拜访内容拜访内容拜访内容拜访内容拜访内容拜访内拜访内容拜访内容拜访内容拜访内容拜访内容拜访内容拜访内容拜访内容拜访内容拜访内拜访内容拜访内容拜访内容拜访内容拜访内容拜访内容拜访内容拜访内容拜访内容拜访内拜访内容拜访内容拜访内容拜访内容拜访内容拜访内容拜访内容拜访内容拜访内容拜访内拜访内容拜访内容拜访内容拜访内容拜访内容拜访内容拜访内容拜访内容拜访内容拜访内",
                    style: TextStyle(fontSize: 14, color: Color(0XFF2F4058)))
              ],
            ),
          )
        ],
      ),
    );
  }
}
