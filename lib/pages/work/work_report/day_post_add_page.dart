import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/day_post_add_model.dart';
import 'package:good_grandma/widgets/post_add_input_cell.dart';
import 'package:good_grandma/widgets/post_detail_group_title.dart';
import 'package:good_grandma/widgets/postadd_delete_plan_cell.dart';
import 'package:good_grandma/widgets/submit_btn.dart';
import 'package:provider/provider.dart';

///新增日报
class DayPostAddPage extends StatefulWidget {
  DayPostAddPage({
    Key key,
    this.id = '',
  }) : super(key: key);
  final String id;
  @override
  State<StatefulWidget> createState() => _Body();
}

class _Body extends State<DayPostAddPage> {
  final List<Map> _list1 = [
    {'title': '本月目标', 'end': '元', 'hintText': '请填写金额'},
    {'title': '今日销售', 'end': '元', 'hintText': '请填写金额'},
    {'title': '本月累计', 'end': '元', 'hintText': '请填写金额'},
    {'title': '月度达成率', 'end': '%', 'hintText': ''},
  ];
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.id.isNotEmpty) _requestDetail();
  }

  ///标记草稿请求详情
  _requestDetail() async {
    requestPost(Api.reportDayDetail,
        json: jsonEncode({'id': widget.id, 'type': 1})).then((value) {
      //LogUtil.d('reportDayDetail value = $value');
      Map map = jsonDecode(value.toString())['data'];
      final DayPostAddModel model =
          Provider.of<DayPostAddModel>(this.context, listen: false);
      model.fromJson(map);
      model.id = widget.id;
      // print('object');
    });
  }

  @override
  Widget build(BuildContext context) {
    final DayPostAddModel model = Provider.of<DayPostAddModel>(context);
    final List values = [
      model.target,
      model.actual,
      model.cumulative,
      model.achievementRate
    ];
    return WillPopScope(
      onWillPop: () async => await AppUtil.onWillPop(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('新增日报'),
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
              //销量进度追踪
              PostDetailGroupTitle(color: null, name: '销量进度追踪'),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                Map map = _list1[index];
                String title = map['title'];
                String end = map['end'];
                String hintText = map['hintText'];
                String value = values[index];
                return PostAddInputCell(
                  title: title,
                  value: value,
                  hintText: hintText,
                  end: end,
                  onTap: () => AppUtil.showInputDialog(
                      context: context,
                      text: value,
                      hintText: hintText,
                      focusNode: _focusNode,
                      editingController: _editingController,
                      keyboardType: TextInputType.numberWithOptions(
                          signed: false, decimal: true),
                      callBack: (text) {
                        if(!AppUtil.isNumeric(text)){
                          AppUtil.showToastCenter('请输入数字');
                          return;
                        }
                        switch (index) {
                          case 0:
                            model.setTarget(text);
                            break;
                          case 1:
                            model.setActual(text);
                            break;
                          case 2:
                            model.setCumulative(text);
                            break;
                        }
                      }),
                );
              }, childCount: _list1.length)),
              //今日工作总结
              PostDetailGroupTitle(color: null, name: '今日工作总结'),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                String text = model.summaries[index];
                return PostAddDeletePlanCell(
                  value: text,
                  hintText: '请填写今日工作总结',
                  isAdd: false,
                  textOnTap: () => AppUtil.showInputDialog(
                      context: context,
                      text: text,
                      hintText: '请填写今日工作总结',
                      focusNode: _focusNode,
                      editingController: _editingController,
                      keyboardType: TextInputType.text,
                      callBack: (text) => model.editSummariesWith(index, text)),
                  rightBtnOnTap: () => model.deleteSummariesWith(index),
                );
              }, childCount: model.summaries.length)),
              SliverToBoxAdapter(
                child: PostAddDeletePlanCell(
                    value: '',
                    hintText: '请填写今日工作总结',
                    isAdd: true,
                    textOnTap: () => AppUtil.showInputDialog(
                        context: context,
                        text: '',
                        hintText: '请填写今日工作总结',
                        focusNode: _focusNode,
                        editingController: _editingController,
                        keyboardType: TextInputType.text,
                        callBack: (text) {
                          if (text.isNotEmpty)
                            model.addSummary(text);
                        }),
                    rightBtnOnTap: () {}),
              ),
              SliverToBoxAdapter(
                  child: Container(color: Colors.white, height: 10.0)),
              //明日工作计划
              PostDetailGroupTitle(color: null, name: '明日工作计划'),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                String text = model.plans[index];
                return PostAddDeletePlanCell(
                  value: text,
                  hintText: '请填写明日工作计划',
                  isAdd: false,
                  textOnTap: () => AppUtil.showInputDialog(
                      context: context,
                      text: text,
                      hintText: '请填写明日工作计划',
                      focusNode: _focusNode,
                      editingController: _editingController,
                      keyboardType: TextInputType.text,
                      callBack: (text) {
                        model.editPlanWith(index, text);
                      }),
                  rightBtnOnTap: () {
                    model.deletePlanWith(index);
                  },
                );
              }, childCount: model.plans.length)),
              SliverToBoxAdapter(
                child: PostAddDeletePlanCell(
                    value: '',
                    hintText: '请填写明日工作计划',
                    isAdd: true,
                    textOnTap: () => AppUtil.showInputDialog(
                        context: context,
                        text: '',
                        hintText: '请填写明日工作计划',
                        focusNode: _focusNode,
                        editingController: _editingController,
                        keyboardType: TextInputType.text,
                        callBack: (text) {
                          if (text.isNotEmpty) model.addPlan(text);
                        }),
                    rightBtnOnTap: () { }),
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
      BuildContext context, DayPostAddModel model, int status) async {
    String param = _dealModelToJson(context, model, status);
    if (param.isEmpty) return;
    print('param = $param');
    requestPost(Api.reportDayAdd, json: param).then((value) {
      var data = jsonDecode(value.toString());
      print('data = $data');
      if (data['code'] == 200) Navigator.pop(context, true);
    });
  }

  ///status 1:草稿 2：提交
  String _dealModelToJson(
      BuildContext context, DayPostAddModel model, int status) {
    if (model.target.isEmpty && status != 1) {
      AppUtil.showToastCenter('请填写本月目标');
      return '';
    }
    if (model.actual.isEmpty && status != 1) {
      AppUtil.showToastCenter('请填写今日销售');
      return '';
    }
    if (model.cumulative.isEmpty && status != 1) {
      AppUtil.showToastCenter('请填写本月累计');
      return '';
    }
    if (model.summaries.isEmpty && status != 1) {
      AppUtil.showToastCenter('请填写工作总结');
      return '';
    }
    if (model.plans.isEmpty && status != 1) {
      AppUtil.showToastCenter('请填写工作计划');
      return '';
    }
    if (model.plans.isEmpty && model.target.isEmpty && model.summaries.isEmpty && model.cumulative.isEmpty && model.actual.isEmpty) {
      AppUtil.showToastCenter('请至少填写一项');
      return '';
    }
    Map param = {
      'targetmonth': model.target,
      'saleday': model.actual,
      'salemonth': model.cumulative,
      'daywork': model.summaries.isNotEmpty?jsonEncode(model.summaries):'',
      'tomwork': model.plans.isNotEmpty?jsonEncode(model.plans):'',
      'status': status,
      'id':widget.id,
    };
    return jsonEncode(param);
  }

  @override
  void dispose() {
    super.dispose();
    _editingController?.dispose();
    _focusNode?.dispose();
  }
}
