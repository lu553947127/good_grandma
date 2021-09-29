import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/post_add_zn_model.dart';
import 'package:good_grandma/widgets/post_detail_group_title.dart';
import 'package:good_grandma/widgets/postadd_delete_plan_cell.dart';
import 'package:good_grandma/widgets/submit_btn.dart';
import 'package:provider/provider.dart';

///职能添加周报 月报
class PostAddZNPage extends StatefulWidget {
  const PostAddZNPage({
    Key key,
    this.isWeek = true,
    this.id = '',
  }) : super(key: key);

  ///是否是周报 否是月报
  final bool isWeek;
  final String id;

  @override
  _PostAddZNPageState createState() => _PostAddZNPageState();
}

class _PostAddZNPageState extends State<PostAddZNPage> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _editingController = TextEditingController();

  ///工作内容暂存
  String _currentWork = '';

  ///工作中存在的问题及需改进的方面暂存
  String _problem = '';

  ///工作计划暂存
  String _plan = '';

  ///建议暂存
  String _suggest = '';

  @override
  void initState() {
    super.initState();
    if (widget.id.isNotEmpty) _requestDetail();
  }

  ///标记草稿请求详情
  _requestDetail() async {
    requestPost(Api.reportDayDetail,
            json: jsonEncode({'id': widget.id, 'type': widget.isWeek ? 2 : 3}))
        .then((value) {
      Map map = jsonDecode(value.toString())['data'];
      final PostAddZNModel model =
          Provider.of<PostAddZNModel>(this.context, listen: false);
      model.fromJson(map);
      model.id = widget.id;
      // print('object');
    });
  }

  @override
  Widget build(BuildContext context) {
    String typeName = '周';
    if (!widget.isWeek) typeName = '月';
    final PostAddZNModel model = Provider.of<PostAddZNModel>(context);
    return WillPopScope(
      onWillPop: () async => await AppUtil.onWillPop(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text((widget.id.isNotEmpty ? '修改' : '新增') + typeName + '报'),
          actions: [
            TextButton(
                onPressed: () => _submitAction(context, model, 1),
                child:
                    const Text('保存草稿', style: TextStyle(color: Colors.black))),
          ],
        ),
        body: Scrollbar(
          child: CustomScrollView(
            slivers: [
              //本周工作内容
              PostDetailGroupTitle(color: null, name: '本' + typeName + '工作内容'),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                String text = model.currentWorks[index];
                return PostAddDeletePlanCell(
                  value: text,
                  hintText: '请填写工作内容',
                  isAdd: false,
                  textOnTap: () => AppUtil.showInputDialog(
                      context: context,
                      text: text,
                      hintText: '请填写工作内容',
                      focusNode: _focusNode,
                      editingController: _editingController,
                      keyboardType: TextInputType.text,
                      callBack: (text) {
                        model.editArrayWith(model.currentWorks, index, text);
                      }),
                  rightBtnOnTap: () {
                    model.deleteArrayWith(model.currentWorks, index);
                  },
                );
              }, childCount: model.currentWorks.length)),
              SliverToBoxAdapter(
                child: PostAddDeletePlanCell(
                    value: _currentWork,
                    hintText: '请填写工作内容',
                    isAdd: true,
                    textOnTap: () => AppUtil.showInputDialog(
                        context: context,
                        text: _currentWork,
                        hintText: '请填写工作内容',
                        focusNode: _focusNode,
                        editingController: _editingController,
                        keyboardType: TextInputType.text,
                        callBack: (text) {
                          if (mounted) setState(() => _currentWork = text);
                        }),
                    rightBtnOnTap: () {
                      if (_currentWork.isNotEmpty)
                        model.addToArray(model.currentWorks, _currentWork);
                      if (mounted) setState(() => _currentWork = '');
                    }),
              ),
              SliverToBoxAdapter(
                  child: Container(color: Colors.white, height: 10.0)),
              //本周工作中存在的问题及需改进的方面
              PostDetailGroupTitle(
                  color: null, name: '本' + typeName + '工作中存在的问题及需改进的方面'),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                String text = model.problems[index];
                return PostAddDeletePlanCell(
                  value: text,
                  hintText: '请填写工作中存在的问题及需改进的方面',
                  isAdd: false,
                  textOnTap: () => AppUtil.showInputDialog(
                      context: context,
                      text: text,
                      hintText: '请填写工作中存在的问题及需改进的方面',
                      focusNode: _focusNode,
                      editingController: _editingController,
                      keyboardType: TextInputType.text,
                      callBack: (text) {
                        model.editArrayWith(model.problems, index, text);
                      }),
                  rightBtnOnTap: () {
                    model.deleteArrayWith(model.problems, index);
                  },
                );
              }, childCount: model.problems.length)),
              SliverToBoxAdapter(
                child: PostAddDeletePlanCell(
                    value: _problem,
                    hintText: '请填写工作中存在的问题及需改进的方面',
                    isAdd: true,
                    textOnTap: () => AppUtil.showInputDialog(
                        context: context,
                        text: _problem,
                        hintText: '请填写工作中存在的问题及需改进的方面',
                        focusNode: _focusNode,
                        editingController: _editingController,
                        keyboardType: TextInputType.text,
                        callBack: (text) {
                          if (mounted) setState(() => _problem = text);
                        }),
                    rightBtnOnTap: () {
                      if (_problem.isNotEmpty)
                        model.addToArray(model.problems, _problem);
                      if (mounted) setState(() => _problem = '');
                    }),
              ),
              SliverToBoxAdapter(
                  child: Container(color: Colors.white, height: 10.0)),
              //下周工作计划
              PostDetailGroupTitle(color: null, name: '下' + typeName + '工作计划'),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                String text = model.plans[index];
                return PostAddDeletePlanCell(
                  value: text,
                  hintText: '请填写工作计划',
                  isAdd: false,
                  textOnTap: () => AppUtil.showInputDialog(
                      context: context,
                      text: text,
                      hintText: '请填写工作计划',
                      focusNode: _focusNode,
                      editingController: _editingController,
                      keyboardType: TextInputType.text,
                      callBack: (text) {
                        model.editArrayWith(model.plans, index, text);
                      }),
                  rightBtnOnTap: () {
                    model.deleteArrayWith(model.plans, index);
                  },
                );
              }, childCount: model.plans.length)),
              SliverToBoxAdapter(
                child: PostAddDeletePlanCell(
                    value: _plan,
                    hintText: '请填写工作计划',
                    isAdd: true,
                    textOnTap: () => AppUtil.showInputDialog(
                        context: context,
                        text: _plan,
                        hintText: '请填写工作计划',
                        focusNode: _focusNode,
                        editingController: _editingController,
                        keyboardType: TextInputType.text,
                        callBack: (text) {
                          if (mounted) setState(() => _plan = text);
                        }),
                    rightBtnOnTap: () {
                      if (_plan.isNotEmpty)
                        model.addToArray(model.plans, _plan);
                      if (mounted) setState(() => _plan = '');
                    }),
              ),
              SliverToBoxAdapter(
                  child: Container(color: Colors.white, height: 10.0)),
              //建议
              PostDetailGroupTitle(color: null, name: '建议'),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                String text = model.suggests[index];
                return PostAddDeletePlanCell(
                  value: text,
                  hintText: '请填写建议',
                  isAdd: false,
                  textOnTap: () => AppUtil.showInputDialog(
                      context: context,
                      text: text,
                      hintText: '请填写建议',
                      focusNode: _focusNode,
                      editingController: _editingController,
                      keyboardType: TextInputType.text,
                      callBack: (text) {
                        model.editArrayWith(model.suggests, index, text);
                      }),
                  rightBtnOnTap: () {
                    model.deleteArrayWith(model.suggests, index);
                  },
                );
              }, childCount: model.suggests.length)),
              SliverToBoxAdapter(
                child: PostAddDeletePlanCell(
                    value: _suggest,
                    hintText: '请填写建议',
                    isAdd: true,
                    textOnTap: () => AppUtil.showInputDialog(
                        context: context,
                        text: _suggest,
                        hintText: '请填写建议',
                        focusNode: _focusNode,
                        editingController: _editingController,
                        keyboardType: TextInputType.text,
                        callBack: (text) {
                          if (mounted) setState(() => _suggest = text);
                        }),
                    rightBtnOnTap: () {
                      if (_suggest.isNotEmpty)
                        model.addToArray(model.suggests, _suggest);
                      if (mounted) setState(() => _suggest = '');
                    }),
              ),
              SliverToBoxAdapter(
                  child: Container(color: Colors.white, height: 10.0)),
              SliverSafeArea(
                sliver: SliverToBoxAdapter(
                  child: SubmitBtn(
                    title: '提  交',
                    onPressed: () => _submitAction(context, model, 2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///提  交
  void _submitAction(
      BuildContext context, PostAddZNModel model, int status) async {
    if (model.currentWorks.isEmpty) {
      AppUtil.showToastCenter('请填写工作内容');
      return;
    }
    Map param = model.toJson();
    param['status'] = status;
    // LogUtil.d('param = ${jsonEncode(param)}');
    String url = Api.reportMonthAdd;
    if (widget.isWeek) {
      url = Api.reportWeekAdd;
    }
    requestPost(url, json: param).then((value) {
      var data = jsonDecode(value.toString());
      // print('data = $data');
      if (data['code'] == 200) Navigator.pop(context, true);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _editingController?.dispose();
    _focusNode?.dispose();
  }
}
