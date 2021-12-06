import 'package:flutter/material.dart';

///拜访统计列表
class VisitStatisticsList extends StatelessWidget {
  final dynamic data;
  final Function() onTap;
  VisitStatisticsList({Key key, this.data, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    _setStatusText(status){
      switch(status){
        case 1:
          return '拜访中';
          break;
        case 2:
          return '已完成';
          break;
      }
    }

    _setTextColor(status){
      switch(status){
        case 1:
          return Color(0xFFE45C26);
          break;
        case 2:
          return Color(0xFF05A8C6);
          break;
      }
    }

    _setBgColor(status){
      switch(status){
        case 1:
          return Color(0xFFFAEEEA);
          break;
        case 2:
          return Color(0xFFE9F5F8);
          break;
      }
    }

    return Container(
      margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
      padding: EdgeInsets.all(10.0),
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
      child: InkWell(
        child: Column(
          mainAxisSize:MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset('assets/images/icon_visit_statistics.png', width: 25, height: 25),
                    SizedBox(width: 10),
                    Container(
                      width: 200,
                      child: Text(data['visitContent'], style: TextStyle(fontSize: 15, color: Color(0XFF2F4058))
                        , overflow: TextOverflow.ellipsis, maxLines: 1)
                    )
                  ]
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: _setBgColor(data['status']), borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(_setStatusText(data['status']), style: TextStyle(fontSize: 10, color: _setTextColor(data['status'])))
                )
              ]
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 0.5,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Color(0xFFEFEFF4)),
              )
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('拜访人: ${data['userName']}', style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                SizedBox(height: 3),
                Text('开始时间: ${data['createTime']}', style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                SizedBox(height: 3),
                Text('结束时间: ${data['updateTime']}', style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                SizedBox(height: 3),
                Text('拜访客户: ${data['customerName']}', style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                SizedBox(height: 3),
                Text('客户类型: ${data['customerTypeName']}', style: TextStyle(fontSize: 12, color: Color(0XFF959EB1)))
              ]
            )
          ]
        ),
        onTap: onTap
      )
    );
  }
}
