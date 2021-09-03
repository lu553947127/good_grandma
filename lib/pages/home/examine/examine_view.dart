import 'package:flutter/material.dart';

///审批列表
class ExamineView extends StatelessWidget {

  var data;
  String type;
  final VoidCallback onTap;
  ExamineView({Key key, this.data, this.type, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    ///转化当前审核状态 英译汉
    String processIsFinished = data['processIsFinished'] == 'unfinished' ? '审核中' : '已审核';

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
                    Text(data['processDefinitionName'], style: TextStyle(fontSize: 14
                        , color: processIsFinished == '审核中' ? type == '知会我的' ? Color(0XFF2F4058) : Color(0XFFE45C26) : Color(0XFF2F4058))),
                    SizedBox(height: 10),
                    Text(data['createTime'],style: TextStyle(fontSize: 12, color: Color(0XFF959EB1)))
                  ],
                ),
                Offstage(
                  offstage: type == '知会我的' ? true : false,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: processIsFinished == '审核中' ? Color(0XFFFAEEEA) : Color(0XFFEFEFF4), borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(processIsFinished == '审核中' ? '审核中' : '已审核'
                        , style: TextStyle(fontSize: 10, color: processIsFinished == '审核中' ? Color(0XFFE45C26) : Color(0XFF959EB1))),
                  )
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
            Container(
              margin: EdgeInsets.only(top: 2),
              child: Row(
                children: [
                  Text('流程分类: ',style: TextStyle(fontSize: 12,color: Color(0XFF959EB1))),
                  SizedBox(width: 10),
                  Text('${data['categoryName']}',style: TextStyle(fontSize: 12,color: Color(0XFF2F4058)))
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 2),
              child: Row(
                children: [
                  Text('当前节点: ',style: TextStyle(fontSize: 12,color: Color(0XFF959EB1))),
                  SizedBox(width: 10),
                  Text('${data['taskName']}',style: TextStyle(fontSize: 12,color: Color(0XFF2F4058)))
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 2),
              child: Row(
                children: [
                  Text('申请人: ',style: TextStyle(fontSize: 12,color: Color(0XFF959EB1))),
                  SizedBox(width: 10),
                  Text('${data['startUsername']}',style: TextStyle(fontSize: 12,color: Color(0XFF2F4058)))
                ],
              ),
            )
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
