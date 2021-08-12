import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:table_calendar/table_calendar.dart';

///首页
class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Body();
}

class _Body extends State<HomePage> {
  String _msgTime = '2021-07-09';
  String _msgCount = '66';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("好阿婆"),
        actions: [
          TextButton(
              onPressed: () {},
              child: Image.asset('assets/images/home_scan.png',
                  width: 20.0, height: 20.0)),
        ],
      ),
      body: Scrollbar(
        child: CustomScrollView(
          slivers: [
            //顶部按钮
            SliverToBoxAdapter(child: _TableHeader()),
            //消息通知
            SliverToBoxAdapter(
              child: Visibility(
                  visible: _msgCount != '0',
                  child: _GroupTitle(title: '消息通知', showMore: false)),
            ),
            //消息cell
            SliverToBoxAdapter(
                child: _MsgTitle(msgTime: _msgTime, msgCount: _msgCount)),
            //拜访计划
            SliverToBoxAdapter(
              child: _GroupTitle(title: '拜访计划', showMoreBtnOnTap: () {}),
            ),
            SliverToBoxAdapter(child: _PlanCell()),
            //工作报告
            SliverToBoxAdapter(
              child: _GroupTitle(title: '工作报告', showMoreBtnOnTap: () {}),
            ),
          ],
        ),
      ),
    );
  }
}

///顶部按钮列表
class _TableHeader extends StatelessWidget {
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
      height: 200.0,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(
                offset: Offset(2, 1), //x,y轴
                color: Colors.black.withOpacity(0.1), //投影颜色
                blurRadius: 1 //投影距离
                )
          ]),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, childAspectRatio: 1.0),
        itemBuilder: (context, index) {
          Map map = _list[index];
          String image = map['image'];
          String name = map['name'];
          return TextButton(
              onPressed: () {
                _btnOnTap(context, index);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(image, width: 50.0, height: 50.0),
                  Text(
                    name,
                    style: const TextStyle(color: Colors.black),
                  )
                ],
              ));
        },
        itemCount: _list.length,
      ),
    );
  }

  ///按钮点击事件
  void _btnOnTap(BuildContext context, int index) {}
}

///group标题
class _GroupTitle extends StatelessWidget {
  final String title;
  final bool showMore;
  final VoidCallback showMoreBtnOnTap;
  _GroupTitle(
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
                style: const TextStyle(fontSize: 16.0),
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

///消息cell
class _MsgTitle extends StatelessWidget {
  final String msgCount;
  final String msgTime;
  _MsgTitle({
    Key key,
    @required this.msgTime,
    @required this.msgCount,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: msgCount != '0',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                    offset: Offset(2, 1), //x,y轴
                    color: Colors.black.withOpacity(0.1), //投影颜色
                    blurRadius: 1 //投影距离
                    )
              ]),
          child: ListTile(
            title: Row(
              children: [
                Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Image.asset('assets/images/home_msg.png',
                        width: 40.0, height: 40.0)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(bottom: 7),
                        child: const Text('您有新的消息',
                            style: TextStyle(fontSize: 14))),
                    Text(
                      msgTime,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.FF959EB1),
                    ),
                  ],
                ),
                Spacer(),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    height: 20,
                    decoration: BoxDecoration(
                        color: AppColors.FFDD0000,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(2, 1), //x,y轴
                              color: AppColors.FFDD0000.withOpacity(0.1), //投影颜色
                              blurRadius: 1 //投影距离
                              )
                        ]),
                    child: Center(
                        child: Text(
                      msgCount,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 12.0),
                    )))
              ],
            ),
            onTap: () {},
          ),
        ),
      ),
    );
  }
}

///拜访计划
class _PlanCell extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PlanCellState();
}

class _PlanCellState extends State<_PlanCell> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: [
              BoxShadow(
                  offset: Offset(2, 1), //x,y轴
                  color: Colors.black.withOpacity(0.1), //投影颜色
                  blurRadius: 1 //投影距离
                  )
            ]),
        child: Column(
          children: [
            TableCalendar(
                focusedDay: DateTime.now(),
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                currentDay: DateTime.now(),
                // locale: 'zh_CH',
            ),
          ],
        ),
      ),
    );
  }
}
