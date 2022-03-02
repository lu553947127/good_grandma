import 'package:flutter/material.dart';

///审批列表
class ExamineView extends StatelessWidget {
  final dynamic data;
  final String type;
  final VoidCallback onTap;
  ExamineView({Key key, this.data, this.type, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    ///转化当前审核状态 英译汉
    String processIsFinished = '';
    switch(data['processIsFinished']){
      case 'unfinished':
        processIsFinished = '审核中';
        break;
      case 'finished':
        processIsFinished = '已审核';
        break;
      case 'reject':
        processIsFinished = '已终止';
        break;
      case 'withdraw':
        processIsFinished = '已撤回';
        break;
      case 'rollback':
        processIsFinished = '已驳回';
        break;
    }

    _setTextColor(status){
      switch(status){
        case '已审核':
          return Color(0xFF12BD95);
          break;
        case '审核中':
          return Color(0xFFDD0000);
          break;
        case '已终止':
          return Color(0xFFC08A3F);
          break;
        case '已驳回':
          return Color(0xFFC08A3F);
          break;
        case '已撤回':
          return Color(0xFF999999);
          break;
      }
    }

    _setBgColor(status){
      switch(status){
        case '已审核':
          return Color(0xFFE4F2F1);
          break;
        case '审核中':
          return Color(0xFFF1E1E2);
          break;
        case '已终止':
          return Color(0xFFF1EEEA);
          break;
        case '已驳回':
          return Color(0xFFF1EEEA);
          break;
        case '已撤回':
          return Color(0xFFEEEFF2);
          break;
      }
    }

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
                    Container(
                      width: 220,
                      child: Text(data['processDefinitionName'], style: TextStyle(fontSize: 14
                          , color: processIsFinished == '审核中' ? type == '知会我的' ? Color(0XFF2F4058) : Color(0XFFE45C26) : Color(0XFF2F4058)))
                    ),
                    SizedBox(height: 10),
                    Text(data['createTime'],style: TextStyle(fontSize: 12, color: Color(0XFF959EB1)))
                  ]
                ),
                Offstage(
                  offstage: type == '知会我的' ? true : false,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: _setBgColor(processIsFinished), borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(processIsFinished, style: TextStyle(fontSize: 10, color: _setTextColor(processIsFinished)))
                  )
                )
              ]
            ),
            SizedBox(height: 10),
            //分割线
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Color(0xFFEFEFF4)),
              )
            ),
            SizedBox(height: 5),
            Container(
                margin: EdgeInsets.only(top: 2),
                child: Row(
                    children: [
                      Text('流水号: ',style: TextStyle(fontSize: 12,color: Color(0XFF959EB1))),
                      SizedBox(width: 10),
                      Text('${data['variables']['serialNumber']}',style: TextStyle(fontSize: 12,color: Color(0XFF2F4058)))
                    ]
                )
            ),
            Container(
              margin: EdgeInsets.only(top: 2),
              child: Row(
                children: [
                  Text('流程分类: ',style: TextStyle(fontSize: 12,color: Color(0XFF959EB1))),
                  SizedBox(width: 10),
                  Text('${data['categoryName']}',style: TextStyle(fontSize: 12,color: Color(0XFF2F4058)))
                ]
              )
            ),
            Container(
              margin: EdgeInsets.only(top: 2),
              child: Row(
                children: [
                  Text(type == '我的已办' ? '操作节点: ' : '当前节点: ',style: TextStyle(fontSize: 12,color: Color(0XFF959EB1))),
                  SizedBox(width: 10),
                  Text('${data['taskName']}',style: TextStyle(fontSize: 12,color: Color(0XFF2F4058)))
                ]
              )
            ),
            Container(
              margin: EdgeInsets.only(top: 2),
              child: Row(
                children: [
                  Text('申请人: ',style: TextStyle(fontSize: 12,color: Color(0XFF959EB1))),
                  SizedBox(width: 10),
                  Text('${data['startUsername']}',style: TextStyle(fontSize: 12,color: Color(0XFF2F4058)))
                ]
              )
            )
          ]
        ),
        onTap: onTap,
      )
    );
  }
}
