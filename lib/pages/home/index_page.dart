import 'package:flutter/material.dart';
import 'package:good_grandma/common/application.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/pages/home/app_page.dart';
import 'package:good_grandma/pages/home/home_page.dart';
import 'package:good_grandma/pages/mine/mine_page.dart';
import 'package:good_grandma/pages/message/msg_page.dart';
import 'package:good_grandma/pages/home/examine/shenpi_page.dart';

///首页底部tabbar
class IndexPage extends StatefulWidget {
  const IndexPage({Key key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int _selectedIndex = 0;
  final List<BottomNavigationBarItem> _bottomNavItems = [
    BottomNavigationBarItem(
        icon: Image.asset('assets/images/tabbar_home.png',width: 22.0,height: 22.0),
        activeIcon: Image.asset('assets/images/tabbar_home_sel.png',width: 22.0,height: 22.0),
        label: '首页'),
    BottomNavigationBarItem(
        icon: Image.asset('assets/images/tabbar_msg.png',width: 22.0,height: 22.0),
        activeIcon: Image.asset('assets/images/tabbar_msg_sel.png',width: 22.0,height: 22.0),
        label: '消息'),
    BottomNavigationBarItem(
        icon: Image.asset('assets/images/tabbar_app.png',width: 22.0,height: 22.0),
        activeIcon: Image.asset('assets/images/tabbar_app_sel.png',width: 22.0,height: 22.0),
        label: '应用'),
    BottomNavigationBarItem(
        icon: Image.asset('assets/images/tabbar_shenpi.png',width: 22.0,height: 22.0),
        activeIcon: Image.asset('assets/images/tabbar_shenpi_sel.png',width: 22.0,height: 22.0),
        label: '审批申请'),
    BottomNavigationBarItem(
        icon: Image.asset('assets/images/tabbar_mine.png',width: 22.0,height: 22.0),
        activeIcon: Image.asset('assets/images/tabbar_mine_sel.png',width: 22.0,height: 22.0),
        label: '我的'),
  ];
  List<Widget> _pages = [];

  void _switchTabbarIndex(int index){
    setState(() => _selectedIndex = index);
  }

  @override
  void initState() {
    super.initState();

    // _bottomNavItems.removeWhere((map) => map.label == '审批申请');

    _pages.addAll([
      HomePage(switchTabbarIndex: (index) => _switchTabbarIndex(index),),
      MsgPage(),
      AppPage(shenpiOnTap: ()=> _switchTabbarIndex(3),),
      ShenPiPage(),
      MinePage()]);
  }

  @override
  Widget build(BuildContext context) {
    Application.appContext = context;
    return Scaffold(
      ///使用BottomNavigationBar 切换页面时重新加载的解决方案
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomNavItems,
        selectedItemColor: AppColors.FFC68D3E,
        unselectedItemColor: AppColors.FF959EB1,
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        showUnselectedLabels: true,
        enableFeedback: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex)
      setState(() => _selectedIndex = index);
  }
}
