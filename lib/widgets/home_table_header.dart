import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';
import 'package:good_grandma/models/main_provider.dart';

///顶部按钮列表
class HomeTableHeader extends StatelessWidget {
  HomeTableHeader({Key key,@required this.onTap, this.homepageList, this.mainProvider}) : super(key: key);
  final Function(Map menu) onTap;
  final List<Map> homepageList;
  final MainProvider mainProvider;

  @override
  Widget build(BuildContext context) {

    ///待审核状态角标
    _setCount(code){
      switch(code){
        case 'firstOrder'://一级订单
          return '${mainProvider.countOne}';
          break;
        case 'directlyOrder'://直营订单
          return '${mainProvider.countZy}';
          break;
        case 'orderFinanceCar'://装车率审核
          return '${mainProvider.countZc}';
          break;
        case 'materialOrder'://物料订单
          return '${mainProvider.countWl}';
          break;
        case 'freezerOrder'://冰柜订单
          return '${mainProvider.countBg}';
          break;
        default:
          return '';
          break;
      }
    }

    return Container(
      child: SliverGrid(
          delegate: SliverChildBuilderDelegate((context, index) {
            Map map = homepageList[index];
            String image = map['source'];
            String name = map['name'];
            List<BoxShadow> shadows = [];
            BorderRadius radius;
            if (index == 4) {
              radius = BorderRadius.only(bottomLeft: Radius.circular(10.0));
            }
            else if (index == homepageList.length - 1) {
              radius = BorderRadius.only(bottomRight: Radius.circular(10.0));
            }
            return Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: radius,
                  boxShadow: shadows),
              child: TextButton(
                  onPressed: () {
                    if(onTap != null)
                      onTap(homepageList[index]);
                  },
                  child: Badge(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          name == '更多' ? Image.asset(image, width: 50.0, height: 50.0) :
                          MyCacheImageView(
                            imageURL: image,
                            width: 50.0,
                            height: 50.0,
                            errorWidgetChild: Image.asset(
                                'assets/images/icon_empty_user.png',
                                width: 50.0,
                                height: 50.0),
                          ),
                          Text(name, style: const TextStyle(color: AppColors.FF142339,fontSize: 14.0), overflow: TextOverflow.ellipsis)
                        ]
                    ),
                      badgeContent: Text(_setCount(map['code']), style: TextStyle(color: Colors.white)),
                      showBadge: map['code'] == 'firstOrder' && mainProvider.countOne != 0 ||
                          map['code'] == 'directlyOrder'  && mainProvider.countZy != 0 ||
                          map['code'] == 'orderFinanceCar'  && mainProvider.countZc != 0 ||
                          map['code'] == 'materialOrder'  && mainProvider.countWl != 0 ||
                          map['code'] == 'freezerOrder'  && mainProvider.countBg != 0
                          ? true : false
                  )
              )
            );
          }, childCount: homepageList.length),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, childAspectRatio: 1.0)),
    );
  }
}
