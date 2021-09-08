import 'package:flutter/material.dart';

///销量统计顶部Header
class SalesStatisticsDetailHeader extends StatelessWidget {
  const SalesStatisticsDetailHeader(
      {Key key,
      @required this.child,
      @required this.bgImageName,
      @required this.title})
      : super(key: key);
  final Widget child;
  final String bgImageName;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Stack(
        children: [
          Positioned(
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width - 15 * 2,
                  height: 50,
                ),
              )
          ),
          Image.asset(bgImageName,
              fit: BoxFit.fill, width: double.infinity),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //标题
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BackButton(color: Colors.white),
                      Text(title,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18)),
                      BackButton(color: Colors.transparent, onPressed: () {}),
                    ],
                  ),
                  //内容
                  child
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
