import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';

///顶部按钮列表
class HomeTableHeader extends StatelessWidget {
  HomeTableHeader({Key key,@required this.onTap, this.homepageList}) : super(key: key);
  final Function(Map menu) onTap;
  final List<Map> homepageList;

  @override
  Widget build(BuildContext context) {

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
                  ))
            );
          }, childCount: homepageList.length),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, childAspectRatio: 1.0)),
    );
  }
}
