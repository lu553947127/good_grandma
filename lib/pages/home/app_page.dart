import 'package:flutter/material.dart';
import 'package:good_grandma/pages/home/regular_doc_page.dart';
import 'package:good_grandma/pages/home/sign_in_page.dart';
import 'package:good_grandma/pages/work/customer_visit/customer_visit_add.dart';
import 'package:good_grandma/pages/work/visit_plan/visit_plan.dart';
import 'package:good_grandma/pages/work/work_report/work_report.dart';
import 'package:good_grandma/pages/work/work_text.dart';
///应用
class AppPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    ///功能模块点击
    void _btnOnPressed(BuildContext context, List<Map> list, int index) {
      switch(list[index]['name']){
        case '拜访计划':
          Navigator.push(context, MaterialPageRoute(builder:(context)=> VisitPlan()));
          break;
        case '客户拜访':
          Navigator.push(context, MaterialPageRoute(builder:(context)=> CustomerVisitAdd()));
          break;
        case '工作报告':
          Navigator.push(context, MaterialPageRoute(builder:(context)=> WorkReport()));
          break;
        case '签到':
          Navigator.push(context, MaterialPageRoute(builder:(context)=> SignInPage()));
          break;
        case '规章文件':
          Navigator.push(context, MaterialPageRoute(builder:(context)=> RegularDocPage()));
          break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        brightness: Brightness.light,
        title: Text('应用'),
      ),
      body: Container(
        color: Colors.white,
        child: ListView.builder(
            itemCount: WorkText.listWork.length,
            itemBuilder: (context, index){
              List<Map> list = (WorkText.listWork[index]['list'] as List).cast();
              return Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(WorkText.listWork[index]['title'], style: TextStyle(fontSize: 18, color: Color(0XFF333333))),
                      GridView.builder(
                        shrinkWrap: true,//为true可以解决子控件必须设置高度的问题
                        physics:NeverScrollableScrollPhysics(),//禁用滑动事件
                        padding: EdgeInsets.zero,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 0.9),
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return TextButton(
                              onPressed: () {
                                _btnOnPressed(context, list, index);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset(list[index]['image'], width: 55.0, height: 55.0),
                                  Text(list[index]['name'], style: TextStyle(fontSize: 14, color: Color(0XFF333333)), overflow: TextOverflow.ellipsis)
                                ],
                              ));
                        }
                      )
                    ],
                  ),
                  decoration: BoxDecoration(//分割线
                    border: Border(bottom: BorderSide(width: 12, color: Color(0xFFF8F9FC))),
                  )
              );
            }
        ),
      )
    );
  }
}