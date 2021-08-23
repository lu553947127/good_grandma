import 'package:flutter/material.dart';
import 'package:good_grandma/pages/home/examine/examine_detail_title.dart';
import 'package:good_grandma/pages/login/loginBtn.dart';
import 'package:good_grandma/widgets/introduce_input.dart';

///审核意见页面
class ExamineAdopt extends StatelessWidget {
  const ExamineAdopt({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('审核意见',style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
      ),
      body: CustomScrollView(
        slivers: [
          ExamineDetailTitle(
              avatar: 'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
              title: '张三的请假申请',
              time: '提交时间: 2021-07-15',
              wait: '等待王武审批',
              status: '审核中'
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 15),
          ),
          SliverToBoxAdapter(
            child: InputWidget(
              placeholder: '请填写审核意见',
              onChanged: (String txt){
                // inputText = txt;
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: LoginBtn(
                title: '确定',
                onPressed: (){

                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
