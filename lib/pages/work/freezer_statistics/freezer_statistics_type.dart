import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';

///冰柜统计筛选
class FreezerStatisticsType extends StatelessWidget {
  FreezerStatisticsType({Key key,
    this.areaName,
    this.customerName,
    this.statusName,
    this.onPressed,
    this.onPressed2,
    this.onPressed3
  }) : super(key: key);

  String areaName = '区域';
  String customerName = '客户';
  String statusName = '状态';
  final void Function() onPressed;
  final void Function() onPressed2;
  final void Function() onPressed3;

  @override
  Widget build(BuildContext context) {
    final double w = (MediaQuery.of(context).size.width - 15 * 2) / 3;
    return Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Row(
            children: [
              //区域
              Container(
                  width: w,
                  child: TextButton(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(areaName,
                                style: TextStyle(
                                    fontSize: 14, color: AppColors.FF2F4058)),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.5),
                              child: Image.asset('assets/images/ic_work_down.png',
                                  width: 10, height: 10),
                            )
                          ]
                      ),
                      onPressed: onPressed
                  )
              ),
              //客户
              Container(
                  width: w,
                  child: TextButton(
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border.symmetric(
                                  vertical:
                                  BorderSide(color: AppColors.FFC1C8D7, width: 1))),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(customerName,
                                    style: TextStyle(
                                        fontSize: 14, color: AppColors.FF2F4058)),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4.5),
                                  child: Image.asset('assets/images/ic_work_down.png',
                                      width: 10, height: 10),
                                )
                              ]
                          )
                      ),
                      onPressed: onPressed2
                  )
              ),
              Container(
                  width: w,
                  child: TextButton(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(statusName,
                                style: TextStyle(
                                    fontSize: 14, color: AppColors.FF2F4058)),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.5),
                              child: Image.asset('assets/images/ic_work_down.png',
                                  width: 10, height: 10),
                            )
                          ]
                      ),
                      onPressed: onPressed3
                  )
              )
            ]
        )
    );
  }
}
