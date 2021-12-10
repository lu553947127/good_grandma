import 'package:flutter/material.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';

///审批申请详情头部标题
class ExamineDetailTitle extends StatelessWidget {

  final String avatar;
  final String title;
  final String time;
  final String wait;
  final String status;
  final String type;

  ExamineDetailTitle({Key key
    , @required this.avatar
    , @required this.title
    , @required this.time
    , @required this.wait
    , @required this.status
    , @required this.type
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

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

    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  offset: Offset(2, 1), //x,y轴
                  color: Colors.black.withOpacity(0.1), //投影颜色
                  blurRadius: 1 //投影距离
              )
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ClipOval(
                  child: MyCacheImageView(
                    imageURL: avatar,
                    width: 50.0,
                    height: 50.0,
                    errorWidgetChild: Image.asset('assets/images/icon_empty_user.png', width: 50.0, height: 50.0)
                  )
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 190,
                      child: Text(title, style: TextStyle(fontSize: 14, color: Color(0XFF2F4058))),
                    ),
                    SizedBox(height: 3),
                    Row(
                      children: [
                        Image.asset('assets/images/icon_examine_time.png', width: 12, height: 12),
                        SizedBox(width: 3),
                        Text(time, style: TextStyle(fontSize: 12, color: Color(0XFFC1C8D7)))
                      ]
                    ),
                    SizedBox(height: 3),
                    Visibility(
                        visible: type != '知会我的' && status == '审核中' ? true : false,
                        child: Row(
                          children: [
                            Image.asset('assets/images/icon_examine_wait.png', width: 12, height: 12),
                            SizedBox(width: 3),
                            Text(wait, style: TextStyle(fontSize: 12, color: Color(0XFFE45C26)))
                          ]
                        )
                    )
                  ]
                )
              ]
            ),
            Offstage(
              offstage: type == '知会我的' ? true : false,
              child:
              status == '已审核' ?
              Container(
                padding: EdgeInsets.all(5),
                child: Image.asset('assets/images/icon_examine_complete.png', width: 50, height: 50),
              ) :
              Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: _setBgColor(status), borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(status, style: TextStyle(fontSize: 10, color: _setTextColor(status)))
              )
            )
          ]
        )
      )
    );
  }
}
