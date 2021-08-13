import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';

///消息cell
class HomeMsgTitle extends StatelessWidget {
  final String msgCount;
  final String msgTime;
  HomeMsgTitle({
    Key key,
    @required this.msgTime,
    @required this.msgCount,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: msgCount != '0',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                    offset: Offset(2, 1), //x,y轴
                    color: Colors.black.withOpacity(0.1), //投影颜色
                    blurRadius: 1 //投影距离
                )
              ]),
          child: ListTile(
            title: Row(
              children: [
                Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Image.asset('assets/images/home_msg.png',
                        width: 40.0, height: 40.0)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(bottom: 7),
                        child: const Text('您有新的消息',
                            style: TextStyle(fontSize: 14,color: AppColors.FF2F4058))),
                    Text(
                      msgTime,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.FF959EB1),
                    ),
                  ],
                ),
                Spacer(),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    height: 20,
                    decoration: BoxDecoration(
                        color: AppColors.FFDD0000,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(2, 1), //x,y轴
                              color: AppColors.FFDD0000.withOpacity(0.1), //投影颜色
                              blurRadius: 1 //投影距离
                          )
                        ]),
                    child: Center(
                        child: Text(
                          msgCount,
                          style:
                          const TextStyle(color: Colors.white, fontSize: 12.0),
                        )))
              ],
            ),
            onTap: () {},
          ),
        ),
      ),
    );
  }
}