import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
import 'package:good_grandma/pages/examine/model/time_select_provider.dart';
import 'package:good_grandma/widgets/search_text_widget.dart';
import 'package:good_grandma/widgets/submit_btn.dart';

///多选人员列表
class SelectMoreUser extends StatefulWidget {
  final List<UserModel> selUser;
  final String title;
  SelectMoreUser({Key key, this.title, this.selUser}) : super(key: key);

  @override
  _SelectMoreUserState createState() => _SelectMoreUserState();
}

class _SelectMoreUserState extends State<SelectMoreUser> {
  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();
  FocusNode _focusNode = FocusNode();
  TextEditingController _editingController = TextEditingController();

  List<UserModel> _userList = [];
  int _current = 1;
  int _pageSize = 20;
  String name = '';

  @override
  void initState() {
    super.initState();
    _controller.callRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SearchTextWidget(
              editingController: _editingController,
              focusNode: _focusNode,
              hintText: '请输入搜索关键字',
              onSearch: _searchAction,
              onChanged: (text){
                _searchAction(text);
              }
          ),
          Expanded(
              child: MyEasyRefreshSliverWidget(
                  controller: _controller,
                  scrollController: _scrollController,
                  dataCount: _userList.length,
                  onRefresh: _refresh,
                  onLoad: _onLoad,
                  slivers: [
                    //列表
                    SliverGrid(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          UserModel userModel = _userList[index];
                          return _UserGridCell(
                              userModel: userModel,
                            onTap: null
                          );
                        }, childCount: _userList.length),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4, childAspectRatio: 0.8)),
                    SliverSafeArea(sliver: SliverToBoxAdapter()),
                  ])
          )
        ]
      ),
      bottomNavigationBar: SafeArea(
        child: SubmitBtn(
            title: '确定',
            onPressed: () {
              List<UserModel> _selList = _userList
                  .where((employee) => employee.isSelected)
                  .toList();
              if (_selList.isEmpty) {
                Fluttertoast.showToast(
                    msg: '选择抄送人不能为空', gravity: ToastGravity.CENTER);
                return;
              }
              Navigator.pop(context, _selList);
            }),
      )
    );
  }

  ///搜索关键字
  _searchAction(String text) {
    if (text.isEmpty) {
      name = '';
      _controller.callRefresh();
      return;
    }
    name = text;
    _refresh();
  }

  Future<void> _refresh() async {
    _current = 1;
    _downloadData();
  }

  Future<void> _onLoad() async {
    _current++;
    _downloadData();
  }

  Future<void> _downloadData() async {
    try {
      Map<String, dynamic> map = {
        'name': name,
        'current': _current,
        'size': _pageSize
      };
      final val = await requestGet(Api.sendSelectUser, param: map);
      LogUtil.d('sendSelectUser value = $val');
      var data = jsonDecode(val.toString());
      if (_current == 1) _userList.clear();
      final List<dynamic> list = data['data']['records'];
      list.forEach((map) {
        UserModel model = UserModel.fromJson(map);
        _userList.add(model);
      });

      if (widget.selUser.isNotEmpty) {
        _userList.forEach((goods) {
          goods.isSelected = false;
          widget.selUser.forEach((selEmployee) {
            if (selEmployee.id == goods.id) goods.isSelected = true;
          });
        });
      }
      bool noMore = false;
      if (list == null || list.isEmpty) noMore = true;
      _controller.finishRefresh(success: true);
      _controller.finishLoad(success: true, noMore: noMore);
      if (mounted) setState(() {});
    } catch (error) {
      _controller.finishRefresh(success: false);
      _controller.finishLoad(success: false, noMore: false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode?.dispose();
    _editingController?.dispose();
    _controller?.dispose();
    _scrollController?.dispose();
  }
}

class _UserGridCell extends StatefulWidget {
  const _UserGridCell({
    Key key,
    @required this.userModel,
    this.onTap,
  }) : super(key: key);
  final UserModel userModel;
  final VoidCallback onTap;
  @override
  State<StatefulWidget> createState() => _UserGridCellState();
}

class _UserGridCellState extends State<_UserGridCell> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(
                () => widget.userModel.isSelected = !widget.userModel.isSelected);
        if (widget.onTap != null) widget.onTap();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: Stack(
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyCacheImageView(
                          imageURL: widget.userModel.image,
                          width: 65.0,
                          height: 65.0,
                          errorWidgetChild: Image.asset('assets/images/icon_empty_user.png', width: 65.0, height: 65.0),
                        ),
                        Text(widget.userModel.name)
                      ]
                  ),
                  Visibility(
                    visible: widget.userModel.isSelected,
                    child: Container(
                      width: 65.0,
                      height: 85.0,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          border:
                          Border.all(color: AppColors.FFC08A3F, width: 4)),
                    )
                  ),
                  Visibility(
                    visible: widget.userModel.isSelected,
                    child: Positioned(
                        bottom: 3,
                        right: 3,
                        child: Image.asset('assets/images/goods_sel.png',
                            width: 15, height: 15)),
                  )
                ]
              )
            )
          )
        ]
      )
    );
  }
}

///多选选择返回回调
Future<List<UserModel>> showMultiSelectList(BuildContext context, TimeSelectProvider timeSelectProvider, title) async {
  List<UserModel> _selUserList = await Navigator.push(context, MaterialPageRoute(builder: (context) => SelectMoreUser(
      title: title,
      selUser: timeSelectProvider.userList
      )
    )
  );
  if (_selUserList != null) {
    timeSelectProvider.setArrays(
        timeSelectProvider.userList, _selUserList);
  }
  return _selUserList;
}
