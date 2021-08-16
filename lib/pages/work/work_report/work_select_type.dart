import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';

class WorkSelectType extends StatelessWidget {
  const WorkSelectType({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                child: Row(
                  children: [
                    Text('所有人', style: TextStyle(fontSize: 14, color: AppColors.FF2F4058)),
                    Image.asset('assets/images/ic_work_down.png', width: 10, height: 10)
                  ],
                ),
                onPressed: (){

                },
              ),
              //垂直分割线
              SizedBox(
                width: 1,
                height: 12,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Color(0xFFC1C8D7)),
                ),
              ),
              TextButton(
                child: Row(
                  children: [
                    Text('所有类型', style: TextStyle(fontSize: 14, color: AppColors.FF2F4058)),
                    Image.asset('assets/images/ic_work_down.png', width: 10, height: 10)
                  ],
                ),
                onPressed: (){

                },
              ),
              SizedBox(
                width: 1,
                height: 12,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Color(0xFFC1C8D7)),
                ),
              ),
              TextButton(
                child: Row(
                  children: [
                    Text('所有日期', style: TextStyle(fontSize: 14, color: AppColors.FF2F4058)),
                    Image.asset('assets/images/ic_work_down.png', width: 10, height: 10)
                  ],
                ),
                onPressed: (){

                },
              )
            ],
          )
      ),
    );
  }
}
