
import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';

///group标题
class HomeGroupTitle extends StatelessWidget {
  final String title;
  final bool showMore;
  final VoidCallback showMoreBtnOnTap;
  HomeGroupTitle(
      {Key key,
        @required this.title,
        this.showMore = true,
        this.showMoreBtnOnTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 11, top: 20, bottom: 10),
      child: Row(
        children: [
          Stack(
            children: [
              Positioned(
                  left: 0,
                  bottom: 0,
                  child: ClipOval(
                    child: Container(
                        width: 7.5, height: 7.5, color: AppColors.FFC68D3E),
                  )),
              Text(
                title,
                style: const TextStyle(fontSize: 16.0,color: AppColors.FF142339),
              ),
            ],
          ),
          Spacer(),
          Visibility(
              visible: showMore,
              child: TextButton(
                  onPressed: showMoreBtnOnTap,
                  child: const Text(
                    '查看更多',
                    style: const TextStyle(
                        fontSize: 12.0, color: AppColors.FF959EB1),
                  )))
        ],
      ),
    );
  }
}