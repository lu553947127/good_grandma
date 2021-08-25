import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';

///顶部按钮列表
class HomeTableHeader extends StatelessWidget {
  final List<Map> _list = [
    {'image': 'assets/images/home_baogao.png', 'name': '工作报告'},
    {'image': 'assets/images/home_huodong.png', 'name': '市场活动'},
    {'image': 'assets/images/home_shenpi.png', 'name': '审批申请'},
    {'image': 'assets/images/home_feiyong.png', 'name': '费用申请'},
    {'image': 'assets/images/home_tongji.png', 'name': '业绩统计'},
    {'image': 'assets/images/home_xiaoliang.png', 'name': '冰柜销量'},
    {'image': 'assets/images/home_binggui.png', 'name': '冰柜统计'},
    {'image': 'assets/images/home_more.png', 'name': '更多'}
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SliverGrid(
          delegate: SliverChildBuilderDelegate((context, index) {
            Map map = _list[index];
            String image = map['image'];
            String name = map['name'];
            List<BoxShadow> shadows = [];
            BorderRadius radius;
            if (index == 4) {
              // shadows.add(BoxShadow(
              //     offset: Offset(-2, 1), //x,y轴
              //     color: Colors.black.withOpacity(0.1), //投影颜色
              //     blurRadius: 1 //投影距离
              //     ));
              radius = BorderRadius.only(bottomLeft: Radius.circular(10.0));
            }
            else if (index == _list.length - 1) {
              // shadows.add(BoxShadow(
              //     offset: Offset(2, 1), //x,y轴
              //     color: Colors.black.withOpacity(0.1), //投影颜色
              //     blurRadius: 1 //投影距离
              //     ));
              radius = BorderRadius.only(bottomRight: Radius.circular(10.0));
            }
            // else {
              // shadows.add(BoxShadow(
              //     offset: Offset(0, 1), //x,y轴
              //     color: Colors.black.withOpacity(0.1), //投影颜色
              //     blurRadius: 1 //投影距离
              // ));
            // }
            return Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: radius,
                  boxShadow: shadows),
              child: TextButton(
                  onPressed: () {
                    _btnOnTap(context, index);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(image, width: 50.0, height: 50.0),
                      Text(name, style: const TextStyle(color: AppColors.FF142339,fontSize: 14.0))
                    ],
                  )),
            );
          }, childCount: _list.length),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, childAspectRatio: 1.0)),
    );
  }

  ///按钮点击事件
  void _btnOnTap(BuildContext context, int index) {}
}