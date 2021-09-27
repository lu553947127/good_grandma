import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
import 'package:good_grandma/common/store.dart';
import 'package:good_grandma/models/declaration_form_model.dart';
import 'package:good_grandma/pages/contract/contract_page.dart';
import 'package:good_grandma/pages/declaration_form/add_declaration_form_page.dart';
import 'package:good_grandma/pages/declaration_form/my_declaration_form_page.dart';
import 'package:good_grandma/pages/mine/feedback_page.dart';
import 'package:good_grandma/pages/mine/mine_performance_page.dart';
import 'package:good_grandma/pages/mine/set_up_page.dart';
import 'package:good_grandma/pages/open_account/open_account_page.dart';
import 'package:good_grandma/pages/order/order_page.dart';
import 'package:good_grandma/widgets/mine_header_view.dart';
import 'package:provider/provider.dart';

///我的
class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();
  final List<Map> _list = [
    {'image': 'assets/images/mine_form_add.png', 'name': '我要报单'},
    {'image': 'assets/images/mine_form.png', 'name': '我的报单'},
    {'image': 'assets/images/mine_order.png', 'name': '我的订单'},
    {'image': 'assets/images/mine_contract.png', 'name': '我的合同'},
    {'image': 'assets/images/mine_feedback.png', 'name': '意见反馈'},
  ];
  String _local = '';
  String _type = '';
  String _phone = '';
  String _avatar = '';
  String _userName = '';
  @override
  void initState() {
    super.initState();
    _local = '';
    _type = Store.readPostName() ?? '';
    _phone = '';
    _avatar = Store.readUserAvatar() ?? '';
    _userName = Store.readNickName() ?? '';
    _controller.callRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyEasyRefreshSliverWidget(
          controller: _controller,
          scrollController: _scrollController,
          dataCount: _list.length,
          onRefresh: _refresh,
          onLoad: null,
          slivers: [
            //用户信息
            MineHeaderView(
              avatar: _avatar,
              userName: _userName,
              local: _local,
              type: _type,
              phone: _phone,
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
          ]),
    );
  }

  Future<void> _refresh() async{
    String userId = Store.readUserId();
    if(userId == null || userId.isEmpty) return;
    try {
      Map<String, dynamic> map = {'userId': userId};
      final val = await requestGet(Api.getUserInfoById,param: map);
      // LogUtil.d('getUserInfoById value = $val');
      Map result = jsonDecode(val.toString());
      Map data = result['data'];
      _local = data['deptName'] ?? '';
      _type = data['postName'] ?? '';
      if(Store.readPostName() != _type)
      Store.savePostName(_type);
      _phone = data['phone'] ?? '';
      _avatar = data['avatar'] ?? '';
      if(Store.readUserAvatar() != _avatar)
        Store.saveUserAvatar(_avatar);
      _userName = data['name'] ?? '';
      if(Store.readNickName() != _userName)
        Store.saveNickName(_userName);
      _controller.finishRefresh(success: true);
      if (mounted) setState(() {});
    } catch (error) {
      _controller.finishRefresh(success: false);
    }
  }

  void _cellOnTap(BuildContext context, int index) {
    switch (index) {
      case -3:
        {
          //设置按钮
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => SetUpPage()));
        }
        break;
      case -2:
        {
          //开通账号功能
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => OpenAccountPage()));
        }
        break;
      case -1:
        {
          //我的业绩
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => MinePerformancePage()));
        }
        break;
      case 0:
        {
          //我要报单
          DeclarationFormModel model = DeclarationFormModel();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      ChangeNotifierProvider<DeclarationFormModel>.value(
                          value: model, child: AddDeclarationFormPage())));
        }
        break;
      case 1:
        {
          //我的报单
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => MyDeclarationFormPage()));
        }
        break;
      case 2:
        {
          //我的订单
          Navigator.push(context, MaterialPageRoute(builder:(context)=> OrderPage()));
        }
        break;
      case 3:
        {
          //我的合同
          Navigator.push(context, MaterialPageRoute(builder:(context)=> ContractPage()));
        }
        break;
      case 4:
        {
          //意见反馈
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => FeedbackPage()));
        }
        break;
    }
  }
}
