import 'package:flutter/material.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/home/examine/examine_add.dart';
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

    List<String> list = ["请假审批", "费用审批", "费用核销审批", "营销费用审批", "对账审批", "费用审批"];

    return Scaffold(
      appBar: AppBar(
        title: Text('审批申请'),
      ),
      body: CustomScrollView(
          slivers: [
            WorkTypeTitle(
              color: null,
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color(0xFFC68D3E),
        onPressed: () async{
          String value = await showPicker(list, context);
          print('showPicker======$value');
          Navigator.push(context, MaterialPageRoute(builder:(context)=> ExamineAdd(
            title: value,
          )));
        },
      ),
    );
  }
}