import 'package:flutter/material.dart';
import 'package:good_grandma/pages/form/form_dynamic_page.dart';
import 'package:good_grandma/pages/home/examine/examine_view.dart';
import 'package:good_grandma/pages/work/work_report/work_type_title.dart';
///审批
class ShenPiPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    final List<Map> _list = [
      {'title': '事假申请', 'status': '审核中', 'time' : '2012-05-29 16:31:50',
        'list' : [
          {
            "title":"请假类型",
            "content":"事假",
          },
          {
            "title":"请假日期",
            "content":"2021-7-20 — 2021-7-22",
          },
          {
            "title":"请假天数",
            "content":"2天",
          }
        ]
      },
      {'title': '费用申请', 'status': '已审核', 'time' : '2012-05-29 16:31:50',
        'list' : [
          {
            "title":"费用类别",
            "content":"固定费用 - 差旅费用",
          },
          {
            "title":"费用金额",
            "content":"¥1万元",
          }
        ]
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('审批申请'),
      ),
      body: CustomScrollView(
          slivers: [
            WorkTypeTitle(
              color: Color(0xFFF8F9FC),
              type: '我申请的',
              list: [
                {'name': '我申请的'},
                {'name': '我审批的'},
                {'name': '知会我的'},
              ],
              onPressed: (){},
              onPressed2: (){},
              onPressed3: (){},
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return ExamineView(date: _list[index]);
                }, childCount: _list.length)
            )
          ]
      ),
      floatingActionButton: PopupMenuButton<String>(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)
        ),
        child: Image.asset('assets/images/ic_work_add.png', width: 70, height: 70),
        itemBuilder: (context) {
          return <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: '请假审批',
              child: TextButton(
                child: Text('请假审批', style: TextStyle(fontSize: 15,color: Color(0XFF2F4058))),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder:(context)=> FormDynamicPage(
                    title: '请假申请',
                  )));
                },
              ),
            ),
            PopupMenuItem<String>(
              value: '费用审批',
              child: TextButton(
                child: Text('费用审批', style: TextStyle(fontSize: 15,color: Color(0XFF2F4058))),
                onPressed: (){

                },
              ),
            )
          ];
        },
      ),
    );
  }
}