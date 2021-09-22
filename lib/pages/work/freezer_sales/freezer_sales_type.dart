import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';

///冰柜销量筛选
class FreezerSalesType extends StatelessWidget {
  FreezerSalesType({Key key,
    this.areaName,
    this.customerName,
    this.onPressed,
    this.onPressed2
  }) : super(key: key);

  String areaName = '区域';
  String customerName = '客户';
  final void Function() onPressed;
  final void Function() onPressed2;

  @override
  Widget build(BuildContext context) {

    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //区域
            TextButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(areaName, style: TextStyle(fontSize: 14, color: AppColors.FF2F4058)),
                  Padding(padding: const EdgeInsets.only(left: 4.5), child: Image.asset('assets/images/ic_work_down.png', width: 10, height: 10))
                ],
              ),
              onPressed: onPressed
            ),
            //垂直分割线
            SizedBox(
              width: 1,
              height: 12,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Color(0xFFC1C8D7)),
              ),
            ),
            //客户
            TextButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(customerName, style: TextStyle(fontSize: 14, color: AppColors.FF2F4058)),
                  Padding(padding: const EdgeInsets.only(left: 4.5), child: Image.asset('assets/images/ic_work_down.png', width: 10, height: 10))
                ],
              ),
              onPressed: onPressed2
            )
          ],
        ),
      ),
    );
  }
}
