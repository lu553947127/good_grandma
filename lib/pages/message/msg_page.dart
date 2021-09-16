import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/loading_widget.dart';
import 'package:good_grandma/pages/contract/contract_page.dart';
import 'package:good_grandma/pages/message/msg_duizhangdan_list_page.dart';
import 'package:good_grandma/pages/message/msg_post_list_page.dart';

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
      appBar: AppBar(automaticallyImplyLeading: false, title: Text('消息')),
      body: _dataArray.isEmpty
          ?NoDataWidget(emptyRetry: _refresh)
          :RefreshIndicator(
        onRefresh: _refresh,
        child: ListView.separated(
            itemBuilder: (context, index) {
              Map map = _dataArray[index];
              String image = map['image'];
              String unreadCount = map['unreadCount'];
              String title = map['title'];
              String subtitle = map['subtitle'];
              String time = map['time'];
              String noticeCategory = map['noticeCategory'];
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
                                  unreadCount.isEmpty || unreadCount != '0',
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
                  trailing: Text(time,
                      style: const TextStyle(color: AppColors.FFC1C8D7)),
                  onTap: () {
                    _cellOnTap(context, index,noticeCategory);
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
      ),
    );
  }

  void _cellOnTap(BuildContext context, int index,String noticeCategory) async{
    switch (index) {
      case 0:
        {
          //公告
          bool result = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => MsgPostListPage(noticeCategory:noticeCategory,noticeCategoryName: '公告',)));
          if(result != null && result)
            _refresh();
        }
        break;
      case 1:
        {
          //系统通知
          bool result = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => MsgPostListPage(noticeCategory:noticeCategory,noticeCategoryName: '系统通知',)));
          if(result != null && result)
            _refresh();
        }
        break;
      case 2:
        {
          //对账单
          bool result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MsgDuiZhangDanListPage(noticeCategory:noticeCategory)));
          if(result != null && result)
            _refresh();
        }
        break;
      case 3:
        {
          //todo:电子合同通知页面待定
          //电子合同
          Navigator.push(context, MaterialPageRoute(builder:(context)=> ContractPage()));
        }
        break;
    }
  }

  Future<void> _refresh() async{
    requestGet(Api.getCategoryCount).then((value) {
      var data = jsonDecode(value.toString());
      final List<dynamic> list = data['data'];
      _dataArray.clear();
      list.forEach((map) {
        String title = map['noticeCategoryName']??'';
        String read = map['read']??'';
        String time = map['createTime']??'';
        String noticeCategory = map['noticeCategory']??'';
        Map imageHintMap = _getImageHintWithTitle(title);
        String image = imageHintMap['image'];
        String hint = imageHintMap['hint'];
        _dataArray.add({
          "image": image,
          'unreadCount': read,
          'title': title,
          'subtitle': read == '0'?'':hint,
          'time': time,
          'noticeCategory':noticeCategory,
        });
      });
      if (mounted) setState(() {});
    });
  }
  Map _getImageHintWithTitle(String title){
    String image = '';
    String hint = '';
    if(title == '公告') {
      image = 'assets/images/msg_gonggao.png';
      hint = '您有一条新的公告';
    }
    else if(title == '系统通知') {
      image = 'assets/images/msg_tongzhi.png';
      hint = '您有一条新的系统通知';
    }
    else if(title == '对账单') {
      image = 'assets/images/msg_duizhangdan.png';
      hint = '您有一条新的对账单';
    }
    else if(title == '电子合同') {
      image = 'assets/images/msg_hetong.png';
      hint = '您有一条新的需要签署的电子合同';
    }
    return {'image':image,'hint':hint};
  }
}
