import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';

///底部选择按钮
class OrderDetailBottom extends StatelessWidget {
  const OrderDetailBottom(
      {Key key,
        this.onTap1,
        this.onTap2,
        this.onTap3,
        this.onTap4,
        this.onTap5,
        this.onTap6,
        this.isVisibility1 = false,
        this.isVisibility2 = false,
        this.isVisibility3 = false,
        this.isVisibility4 = false,
        this.isVisibility5 = false,
        this.isVisibility6 = false})
      : super(key: key);
  final VoidCallback onTap1;
  final VoidCallback onTap2;
  final VoidCallback onTap3;
  final VoidCallback onTap4;
  final VoidCallback onTap5;
  final VoidCallback onTap6;
  final bool isVisibility1;
  final bool isVisibility2;
  final bool isVisibility3;
  final bool isVisibility4;
  final bool isVisibility5;
  final bool isVisibility6;

  @override
  Widget build(BuildContext context) {
    bool isVisi = false;
    if (isVisibility1 == false &&
        isVisibility2 == false &&
        isVisibility3 == false &&
        isVisibility4 == false &&
        isVisibility5 == false &&
        isVisibility6 == false){
      isVisi = false;
    }else {
      isVisi = true;
    }
    return Visibility(
      visible: isVisi,
      child: Container(
          color: Colors.white,
          width: double.infinity,
          height: 59 + MediaQuery.of(context).padding.bottom,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _OrderBtn(
                    isVisibility: isVisibility1,
                    title: '审批',
                    onTap: onTap1,
                    color: AppColors.FFC08A3F
                ),
                _OrderBtn(
                    isVisibility: isVisibility2,
                    title: '驳回',
                    onTap: onTap2,
                    color: AppColors.FF959DB0
                ),
                _OrderBtn(
                    isVisibility: isVisibility3,
                    title: '编辑',
                    onTap: onTap3,
                    color: AppColors.FF05A8C6
                ),
                _OrderBtn(
                    isVisibility: isVisibility4,
                    title: '发货',
                    onTap: onTap4,
                    color: AppColors.FF12BD95
                ),
                _OrderBtn(
                    isVisibility: isVisibility5,
                    title: '确认收货',
                    onTap: onTap5,
                    color: AppColors.FFE45C26
                ),
                _OrderBtn(
                    isVisibility: isVisibility6,
                    title: '取消订单',
                    onTap: onTap6,
                    color: AppColors.FF999999
                )
              ]
          )
      )
    );
  }
}

class _OrderBtn extends StatelessWidget {
  const _OrderBtn(
      {Key key,
        this.isVisibility,
        this.title,
        this.onTap,
        this.color})
      : super(key: key);
  final bool isVisibility;
  final String title;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisibility,
      child: TextButton(
          onPressed: onTap,
          child: Container(
            width: 100,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(42),
              ),
              child: Center(child: Text(title,
                  style: TextStyle(fontSize: 16, color: Colors.white)))
          ))
    );
  }
}