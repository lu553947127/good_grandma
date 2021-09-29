import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';

///周报和月报详情中本周区域重点工作总结视图
class PostDetailKeyWorkView extends StatelessWidget {
  const PostDetailKeyWorkView({Key key, @required this.title, @required  this.works}) : super(key: key);
  final String title;
  final List<String> works;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        padding: const EdgeInsets.only(left: 10.0,right: 10.0,bottom: 10.0),
        decoration:
        BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(bottom: Radius.circular(4))),
        child: WorkListWithTitle(works: works,title: title,),
      ),
    );
  }
}
///绘制工作列表
class WorkListWithTitle extends StatelessWidget {
  const WorkListWithTitle({
    Key key,
    @required this.title,
    @required List<String> works,
  }) : _works = works, super(key: key);

  final List<String> _works;
  final String title;

  @override
  Widget build(BuildContext context) {
    List<Widget> _views = [];
    if(title != null && title.isNotEmpty)
      _views.add(Padding(
        padding: const EdgeInsets.only(bottom: 15.0,top: 10.0),
        child: Text(title,style: const TextStyle(color: AppColors.FF959EB1,fontSize: 15.0),),
      ));
    int i = 1;
    for (String title1 in _works) {
      _views.add(Text.rich(TextSpan(
        text: '$i.',
        style: const TextStyle(color: AppColors.FF959EB1, fontSize: 14.0),
        children: [
          TextSpan(
              text: title1 ?? '',
              style: const TextStyle(color: AppColors.FF2F4058))
        ],
      )));
      if (i < _works.length)
        _views.add(const Divider(color: AppColors.FFEFEFF4, thickness: 1));
      i++;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _views,
    );
  }
}