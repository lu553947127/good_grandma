import 'package:flutter/material.dart';
import 'package:good_grandma/pages/home/examine/examine_detail_content.dart';
import 'package:good_grandma/pages/home/examine/examine_detail_title.dart';
import 'package:good_grandma/pages/home/examine/examine_reject.dart';
import 'examine_adopt.dart';
import 'examine_detail_list.dart';

///审批详情
class ExamineDetail extends StatefulWidget {
  String status;
  ExamineDetail({Key key, this.status}) : super(key: key);

  @override
  _ExamineDetailState createState() => _ExamineDetailState();
}

class _ExamineDetailState extends State<ExamineDetail> {
  @override
  Widget build(BuildContext context) {

    final List<Map> _list = [
      {'name': '王武', 'status': '未审核', 'position' : '大区经理'
        ,'avatar' : 'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg','time' : '2012-05-29 16:31:50'
        ,'status_content': '审核意见审核意见审核意见审核意见审核意见审核意见审核意见审核意见审核意见'},
      {'name': '李四', 'status': '已审核', 'position' : '城市经理','avatar' : 'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg','time' : '2012-05-29 16:31:50'
        ,'status_content': '审核意见审核意见审核意见审核意见审核意见审核意见审核意见审核意见审核意见' },
      {'name': '李四', 'status': '发起申请', 'position' : '城市经理','avatar' : 'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg','time' : '2012-05-29 16:31:50'
        ,'status_content': '审核意见审核意见审核意见审核意见审核意见审核意见审核意见审核意见审核意见'},
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('审批详情',style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              ExamineDetailTitle(
                  avatar: 'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
                  title: '我的请假申请',
                  time: '提交时间: 2021-07-15',
                  wait: '等待王武审批',
                  status: widget.status
              ),
              ExamineDetailContent(),
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.only(top: 15.0, left: 15.0),
                  child: Text('审核流程', style: TextStyle(fontSize: 14, color: Color(0XFF2F4058))),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: 15),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return ExamineDetailList(date: _list[index]);
                  }, childCount: _list.length)
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: 55),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(2, 1), //x,y轴
                        color: Colors.black.withOpacity(0.1), //投影颜色
                        blurRadius: 1 //投影距离
                    )
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    child: Column(
                      children: [
                        Image.asset('assets/images/icon_examine_reject.png', width: 15, height: 15),
                        SizedBox(height: 3),
                        Text('驳回', style: TextStyle(fontSize: 13, color: Color(0XFFDD0000)))
                      ],
                    ),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder:(context)=> ExamineReject()));
                    },
                  ),
                  SizedBox(
                    width: 0.5,
                    height: 40,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Color(0xFFC1C8D7)),
                    ),
                  ),
                  TextButton(
                      child: Column(
                        children: [
                          Image.asset('assets/images/icon_examine_adopt.png', width: 15, height: 15),
                          SizedBox(height: 3),
                          Text('通过', style: TextStyle(fontSize: 13, color: Color(0XFF12BD95)))
                        ],
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder:(context)=> ExamineAdopt()));
                      }
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
