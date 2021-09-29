import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/widgets/post_detail_key_work_view.dart';

///下周行程及重点工作内容
class PostDetailNextWeekWorkView extends StatefulWidget {
  const PostDetailNextWeekWorkView({Key key, @required this.nextWeek})
      : super(key: key);
  final Map nextWeek;

  @override
  _PostDetailNextWeekWorkViewState createState() =>
      _PostDetailNextWeekWorkViewState();
}

class _PostDetailNextWeekWorkViewState
    extends State<PostDetailNextWeekWorkView> {
  @override
  Widget build(BuildContext context) {
    if (widget.nextWeek.isEmpty) return SliverToBoxAdapter();
    double size = 34.0;
    List<Widget> weekViews = [];
    List<Map> cities = widget.nextWeek['cities'];
    List<String> works = widget.nextWeek['works'];
    int i = 0;
    cities.forEach((element) {
      String title = element['title'];
      String city = element['id'];
      weekViews.add(Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: Text(title,
                style:
                    const TextStyle(color: AppColors.FFC1C8D7, fontSize: 11.0)),
          ),
          CircleAvatar(
              child: Container(
                width: size,
                height: size,
                child: Center(
                  child: Text(city,
                      style: const TextStyle(fontSize: 12.0),
                      textAlign: TextAlign.center),
                ),
              ),
              backgroundColor: AppColors.FFC08A3F,
              foregroundColor: Colors.white,
              radius: size / 2),
        ],
      ));
      if (i < cities.length - 1)
        weekViews.add(Padding(
          padding: EdgeInsets.only(bottom: size / 2),
          child: Container(width: 13, height: 1, color: AppColors.FFF2E8D7),
        ));
      i++;
    });
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      sliver: SliverToBoxAdapter(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(4)),
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('工作城市',
                  style: TextStyle(color: AppColors.FF959EB1, fontSize: 12.0)),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: weekViews),
              const Divider(color: AppColors.FFEFEFF4, thickness: 1),
              WorkListWithTitle(title: '工作内容', works: works),
            ],
          ),
        ),
      ),
    );
  }
}
