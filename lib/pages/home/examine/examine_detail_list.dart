import 'package:flutter/material.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';

class ExamineDetailList extends StatelessWidget {
  var date;

  ExamineDetailList({Key key, this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    _setTextColor(status){
      switch(status){
        case '未审核':
          return Color(0xFF2F4058);
          break;
        case '已审核':
          return Color(0xFF12BD95);
          break;
        case '发起申请':
          return Color(0xFFC08A3F);
          break;
      }
    }

    _setLeftIcon(status){
      switch(status){
        case '未审核':
          return 'assets/images/icon_examine_status3.png';
          break;
        case '已审核':
          return 'assets/images/icon_examine_status1.png';
          break;
        case '发起申请':
          return 'assets/images/icon_examine_status2.png';
          break;
      }
    }

    return Container(
        padding: EdgeInsets.only(top: 20, left: 20.0, right: 20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                ClipOval(
                  child: MyCacheImageView(
                    imageURL: date['avatar'],
                    width: 40.0,
                    height: 40.0,
                    errorWidgetChild:
                    Icon(Icons.supervised_user_circle, size: 30.0),
                  )
                ),
                // SizedBox(
                //   width: 1,
                //   height: 25,
                //   child: DecoratedBox(
                //     decoration: BoxDecoration(color: Color(0xFFC1C8D7)),
                //   ),
                // ),
              ],
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(date['name'], style: TextStyle(fontSize: 16, color: Color(0xFF2F4058))),
                    SizedBox(width: 10),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Color(0XFFFAEEEA), borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(date['position'], style: TextStyle(fontSize: 12, color: Color(0XFFE45C26))),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  width: 260,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(_setLeftIcon(date['status']), width: 12, height: 12),
                                SizedBox(width: 3),
                                Text(date['status'], style: TextStyle(fontSize: 13, color: _setTextColor(date['status'])))
                              ],
                            ),
                            Visibility(
                              visible: date['status'] == '已审核' || date['status'] == '发起申请' ? true : false,
                              child: Text(date['time'], style: TextStyle(fontSize: 12, color: Color(0XFFC1C8D7))),
                            )
                          ]
                      ),
                      Visibility(
                        visible: date['status'] == '已审核' ? true : false,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10, left: 15),
                          child: Text(date['status_content'], style: TextStyle(fontSize: 12, color: Color(0XFFC1C8D7))),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
    );
  }
}
