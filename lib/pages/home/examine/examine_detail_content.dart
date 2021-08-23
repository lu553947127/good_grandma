import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';

class ExamineDetailContent extends StatelessWidget {
  const ExamineDetailContent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<Map> list = [
      {'title' : '审批编号', 'content' : '14561231321312'},
      {'title' : '审批类型', 'content' : '请假'},
      {'title' : '请假类型', 'content' : '事假'},
      {'title' : '开始时间', 'content' : '2021-07-20'},
      {'title' : '结束时间', 'content' : '2021-07-22'},
      {'title' : '请假天数', 'content' : '2天'},
      {'title' : '请假事由', 'content' : '请假事由请假事由请假事由请假事由请假事由请假事由请假事由请假事由'}
    ];

    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(left: 15.0, right: 15.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0)),
            boxShadow: [
              BoxShadow(
                  offset: Offset(2, 1), //x,y轴
                  color: Colors.black.withOpacity(0.1), //投影颜色
                  blurRadius: 1 //投影距离
              )
            ]),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap:true,//范围内进行包裹（内容多高ListView就多高）
                physics:NeverScrollableScrollPhysics(),//禁止滚动
                itemCount: list.length,
                itemBuilder: (content, index){
                  return Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text.rich(TextSpan(
                      text: '${list[index]['title']}   ',
                      style: const TextStyle(color: AppColors.FF959EB1, fontSize: 15.0),
                      children: [
                        TextSpan(
                            text: list[index]['content'] ?? '',
                            style: const TextStyle(fontSize: 15, color: AppColors.FF2F4058))
                      ],
                    )),
                  );
                },
              )
            ],
          )
        )
      ),
    );
  }
}
