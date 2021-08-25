import 'package:flutter/material.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';

class ExamineDetailTitle extends StatelessWidget {

  String avatar;
  String title;
  String time;
  String wait;
  String status;

  ExamineDetailTitle({Key key
    , @required this.avatar
    , @required this.title
    , @required this.time
    , @required this.wait
    , @required this.status
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    errorWidgetChild:
                    Icon(Icons.supervised_user_circle, size: 30.0),
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontSize: 14, color: Color(0XFF2F4058))),
                    SizedBox(height: 3),
                    Row(
                      children: [
                        Image.asset('assets/images/icon_examine_time.png', width: 12, height: 12),
                        SizedBox(width: 3),
                        Text(time, style: TextStyle(fontSize: 12, color: Color(0XFFC1C8D7)))
                      ],
                    ),
                    SizedBox(height: 3),
                    Visibility(
                        visible: status == '审核中' ? true : false,
                        child: Row(
                          children: [
                            Image.asset('assets/images/icon_examine_wait.png', width: 12, height: 12),
                            SizedBox(width: 3),
                            Text(wait, style: TextStyle(fontSize: 12, color: Color(0XFFE45C26)))
                          ],
                        )
                    )
                  ],
                )
              ],
            ),
            Row(
              children: [
                Visibility(
                  visible: status == '审核中' ? true : false,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Color(0XFFFAEEEA), borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text('审核中', style: TextStyle(fontSize: 10, color: Color(0XFFE45C26))),
                  ),
                ),
                Visibility(
                  visible: status == '审核中' ? false : true,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Image.asset('assets/images/icon_examine_complete.png', width: 50, height: 50),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}