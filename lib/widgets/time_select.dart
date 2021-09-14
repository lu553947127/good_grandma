import 'package:flutter/material.dart';
import 'package:good_grandma/common/application.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/utils.dart';

class TimeSelectView extends StatefulWidget {
  ///左侧标题
  final String leftTitle;
  ///右侧占位
  String rightPlaceholder;
  ///点击回调
  final Function(Map param) onPressed;
  ///选择回调value
  String value;
  ///分割线间距
  double sizeHeight = 0;
  ///请假天数
  String dayNumber;

  TimeSelectView({Key key,
    this.leftTitle,
    this.rightPlaceholder,
    this.onPressed,
    this.sizeHeight,
    this.dayNumber = '0',
    this.value = '',
  }) : super(key: key);

  @override
  _TimeSelectViewState createState() => _TimeSelectViewState();
}

class _TimeSelectViewState extends State<TimeSelectView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: double.infinity,
              height: widget.sizeHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Color(0xFFF5F5F8)),
              )
          ),
          Container(
            height: 60,
            child: InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.leftTitle, style: TextStyle(color: AppColors.FF070E28, fontSize: 15.0)),
                  Row(
                    children: [
                      Text(widget.value == '' ? widget.rightPlaceholder : widget.value,
                          style: TextStyle(color: widget.value == '' ? AppColors.FFC1C8D7 : AppColors.FF070E28, fontSize: widget.value == '' ? 15.0 : 13.0)),
                      Icon(Icons.keyboard_arrow_right, color: widget.value == '' ? AppColors.FFC1C8D7 : AppColors.FF070E28)
                    ],
                  )
                ],
              ),
              onTap: () {
                showPickerDateRange(
                    context: Application.appContext,
                  callBack: (Map param){
                      if(widget.onPressed != null)
                        widget.onPressed(param);
                  }
                );
              },
            )
          ),
          SizedBox(
              width: double.infinity,
              height: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Color(0xFFF5F5F8)),
              )
          ),
          Container(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('天数', style: TextStyle(color: AppColors.FF070E28, fontSize: 15.0)),
                  Text('${widget.dayNumber}天', style: TextStyle(color: AppColors.FF070E28, fontSize: 15.0)),
                ],
              )
          )
        ],
      ),
    );
  }
}
