import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';

///报告详情页标题
class PostDetailGroupTitle extends StatelessWidget {
  const PostDetailGroupTitle({
    Key key,
    @required this.color,
    @required this.name,
  }) : super(key: key);

  final Color color;
  final String name;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Row(
          children: [
            color != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: ClipOval(
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(color: color, boxShadow: [
                          BoxShadow(
                              color: color,
                              offset: Offset(1, 1),
                              blurRadius: 1.5)
                        ]),
                      ),
                    ),
                  )
                : SizedBox(),
            Expanded(
                child: Text(
              name,
              style: const TextStyle(color: AppColors.FF959EB1, fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ))
          ],
        ),
      ),
    );
  }
}
