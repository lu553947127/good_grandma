import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/pages/mine/feedback_page.dart';
import 'package:good_grandma/pages/mine/mine_performance_page.dart';
import 'package:good_grandma/pages/mine/set_up_page.dart';
import 'package:good_grandma/pages/open_account/open_account_page.dart';
import 'package:good_grandma/widgets/mine_header_view.dart';

///我的
class MinePage extends StatelessWidget {
  final List<Map> _list = [
    {'image': 'assets/images/mine_form_add.png', 'name': '我要报单'},
    {'image': 'assets/images/mine_form.png', 'name': '我的报单'},
    {'image': 'assets/images/mine_order.png', 'name': '我的订单'},
    {'image': 'assets/images/mine_contract.png', 'name': '我的合同'},
    {'image': 'assets/images/mine_feedback.png', 'name': '意见反馈'},
  ];
  @override
  Widget build(BuildContext context) {
    final avatar =
        'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg';
    final userName = '黑夜骑士';
    final local = '鲁西省';
    final type = '经销商';
    final phone = '18888888888';
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          //用户信息
          MineHeaderView(
            avatar: avatar,
            userName: userName,
            local: local,
            type: type,
            phone: phone,
            setBtnOnTap: () => _cellOnTap(context, -3),
            functionBtnOnTap: () => _cellOnTap(context, -2),
          ),
          //我的业绩
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                child: TextButton(
                  onPressed: () {
                    _cellOnTap(context, -1);
                  },
                  child: Row(
                    children: [
                      Image.asset('assets/images/mine_achievement.png',
                          width: 30, height: 30.0),
                      Expanded(
                          child: const Text(
                        '  我的业绩',
                        style: TextStyle(
                            fontSize: 16.0, color: AppColors.FF070E28),
                      )),
                      Icon(Icons.chevron_right,
                          size: 24, color: AppColors.FFC1C8D7),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            Map map = _list[index];
            String image = map['image'];
            String name = map['name'];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: TextButton(
                      onPressed: () {
                        _cellOnTap(context, index);
                      },
                      child: Row(
                        children: [
                          Image.asset(image, width: 30, height: 30.0),
                          Expanded(
                              child: Text(
                            '  ' + name,
                            style: const TextStyle(
                                fontSize: 16.0, color: AppColors.FF070E28),
                          )),
                          Icon(Icons.chevron_right,
                              size: 24, color: AppColors.FFC1C8D7),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                      color: AppColors.FFE7E7E7,
                      height: 1,
                      thickness: 1,
                      indent: 10,
                      endIndent: 10)
                ],
              ),
            );
          }, childCount: _list.length)),
          //logo
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(38.0),
              child: Image.asset('assets/images/mine_logo.png',
                  width: 35.5, height: 55.5),
            ),
          ),
        ],
      ),
    );
  }

  void _cellOnTap(BuildContext context, int index) {
    switch (index) {
      case -3:
        {
          //设置按钮
          Navigator.push(context, MaterialPageRoute(builder: (_) => SetUpPage()));
        }
        break;
      case -2:
        {
          //开通账号功能
          Navigator.push(context, MaterialPageRoute(builder: (_) => OpenAccountPage()));
        }
        break;
      case -1:
        {
          //我的业绩
          Navigator.push(context, MaterialPageRoute(builder: (_) => MinePerformancePage()));
        }
        break;
      case 0:
        {
          //我要报单
          print('我要报单');
        }
        break;
      case 1:
        {
          //我的报单

        }
        break;
      case 2:
        {
          //我的订单

        }
        break;
      case 3:
        {
          //我的合同

        }
        break;
      case 4:
        {
          //意见反馈
          Navigator.push(context, MaterialPageRoute(builder: (_) => FeedbackPage()));
        }
        break;
    }
  }
}
