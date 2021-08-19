import 'package:flutter/material.dart';

///审批列表
class ExamineView extends StatelessWidget {

  var date;
  ExamineView({Key key, this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<Map> list = (date['list'] as List).cast();

    return Container(
      margin: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              offset: Offset(2, 1),
              blurRadius: 1.5,
            )
          ]
      ),
      child: ListTile(
        title: Column(
          mainAxisSize:MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //标题头部
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(date['title'],style: TextStyle(fontSize: 14, color: date['status'] == '审核中' ? Color(0XFFE45C26) : Color(0XFF2F4058))),
                    SizedBox(height: 10),
                    Text(date['time'],style: TextStyle(fontSize: 12, color: Color(0XFF959EB1)))
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: date['status'] == '审核中' ? Color(0XFFFAEEEA) : Color(0XFFEFEFF4), borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(date['status'], style: TextStyle(fontSize: 10, color: date['status'] == '审核中' ? Color(0XFFE45C26) : Color(0XFF959EB1))),
                )
              ],
            ),
            SizedBox(height: 10),
            //分割线
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Color(0xFFEFEFF4)),
              ),
            ),
            SizedBox(height: 5),
            ListView.builder(
              shrinkWrap:true,//范围内进行包裹（内容多高ListView就多高）
              physics:NeverScrollableScrollPhysics(),//禁止滚动
              itemCount: list.length,
              itemBuilder: (content, index){
                return Container(
                  margin: EdgeInsets.only(top: 2),
                  child: Row(
                    children: [
                      Text('${list[index]['title']}: ',style: TextStyle(fontSize: 12,color: Color(0XFF959EB1))),
                      SizedBox(width: 10),
                      Text('${list[index]['content']}',style: TextStyle(fontSize: 12,color: Color(0XFF2F4058)))
                    ],
                  ),
                );
              },
            )
          ],
        ),
        onTap: (){

        },
      ),
    );
  }
}
