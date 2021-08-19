import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/pages/message/msg_duizhangdan_list_page.dart';
import 'package:good_grandma/pages/message/msg_post_list_page.dart';
import 'package:good_grandma/pages/message/msg_tongzhi_list_page.dart';

///消息
class MsgPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MsgPageState();
}

class _MsgPageState extends State<MsgPage> {
  List<Map> _dataArray = [];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('消息'),
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            Map map = _dataArray[index];
            String image = map['image'];
            String unreadCount = map['unreadCount'];
            String title = map['title'];
            String subtitle = map['subtitle'];
            String time = map['time'];
            return Container(
              color: Colors.white,
              child: ListTile(
                leading: Container(
                  width: 50.0,
                  height: 40.0,
                  child: Stack(
                    children: [
                      Image.asset(image, width: 40.0, height: 40.0),
                      Positioned(
                          top: 0,
                          right: 0,
                          child: Visibility(
                            visible:
                                unreadCount.isNotEmpty || unreadCount != '0',
                            child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                height: 15,
                                decoration: BoxDecoration(
                                    color: AppColors.FFDD0000,
                                    borderRadius: BorderRadius.circular(7.5),
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(2, 1), //x,y轴
                                          color: AppColors.FFDD0000
                                              .withOpacity(0.1),
                                          blurRadius: 1)
                                    ]),
                                child: Center(
                                    child: Text(unreadCount,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 11.0)))),
                          ))
                    ],
                  ),
                ),
                title: Text(title),
                subtitle: Text(subtitle),
                trailing: Text(time,style: const TextStyle(color: AppColors.FFC1C8D7)),
                onTap: (){
                  _cellOnTap(context, index);
                },
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(
                color: AppColors.FFE7E7E7,
                height: 0.5,
                thickness: 0.5,
                indent: 15,
                endIndent: 15);
          },
          itemCount: _dataArray.length),
    );
  }
  void _cellOnTap(BuildContext context,int index){
    switch(index){
      case 0:{
        //公告
        Navigator.push(context, MaterialPageRoute(builder: (context) => MsgPostListPage()));
      }
      break;
      case 1:{
        //系统通知
        Navigator.push(context, MaterialPageRoute(builder: (context) => MsgTongZhiListPage()));
      }
      break;
      case 2:{
        //对账单
        Navigator.push(context, MaterialPageRoute(builder: (context) => MsgDuiZhangDanListPage()));
      }
      break;
      case 3:{
        //电子合同
      }
      break;
    }
  }

  void _refresh() {
    _dataArray.clear();
    _dataArray.addAll([
      {
        "image": 'assets/images/msg_gonggao.png',
        'unreadCount': '2',
        'title': '公告',
        'subtitle': '您有一条新的公告',
        'time': '12:00'
      },
      {
        "image": 'assets/images/msg_tongzhi.png',
        'unreadCount': '1',
        'title': '系统通知',
        'subtitle': '您有一条新的系统通知',
        'time': '12:00'
      },
      {
        "image": 'assets/images/msg_duizhangdan.png',
        'unreadCount': '33',
        'title': '对账单',
        'subtitle': '您有一条新的对账单',
        'time': '12:00'
      },
      {
        "image": 'assets/images/msg_hetong.png',
        'unreadCount': '44',
        'title': '电子合同',
        'subtitle': '您有一条新的需要签署的电子合同',
        'time': '12:00'
      },
    ]);
    if (mounted) setState(() {});
  }
}
