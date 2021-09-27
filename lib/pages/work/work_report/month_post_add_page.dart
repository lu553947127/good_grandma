import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/store.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/month_post_add_new_model.dart';
import 'package:good_grandma/models/week_post_add_new_model.dart';
import 'package:good_grandma/widgets/post_add_input_cell.dart';
import 'package:good_grandma/widgets/post_detail_group_title.dart';
import 'package:good_grandma/widgets/post_sales_tracking_cell.dart';
import 'package:good_grandma/widgets/postadd_delete_plan_cell.dart';
import 'package:good_grandma/widgets/select_tree.dart';
import 'package:good_grandma/widgets/submit_btn.dart';
import 'package:good_grandma/widgets/white_bg_title_view.dart';
import 'package:provider/provider.dart';

///新增月报
class MonthPostAddPage extends StatefulWidget {
  MonthPostAddPage({
    Key key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _Body();
}

class _Body extends State<MonthPostAddPage> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _editingController = TextEditingController();

  ///今日工作总结暂存
  String _todaySummary = '';

  ///明日工作计划暂存
  String _plan = '';

  ///问题反馈以及解决方案暂存
  String _report = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MonthPostAddNewModel model =
        Provider.of<MonthPostAddNewModel>(context);
    List<Map> list1 = [
      {'title': '本月目标', 'value': model.target.toStringAsFixed(2), 'end': '万元'},
      {'title': '本月实际', 'value': model.actual.toStringAsFixed(2), 'end': '万元'},
      {
        'title': '本月累计',
        'value': model.cumulative.toStringAsFixed(2),
        'end': '万元'
      },
      {
        'title': '月度差额',
        'value': model.difference.toStringAsFixed(2),
        'end': '万元'
      },
      {
        'title': '月度达成率',
        'value': (model.completionRate * 100).toStringAsFixed(2),
        'end': '%'
      },
      {
        'title': '下月规划进货金额',
        'value': model.nextTarget.toStringAsFixed(2),
        'end': '万元'
      }
    ];

    List<Widget> slivers = [
      SliverToBoxAdapter(
        child: Column(
          children: [
            PostAddInputCell(
                title: '报告人',
                value: Store.readNickName() + ' - ' + Store.readPostName(),
                hintText: '',
                onTap: null),
            PostAddInputCell(
              title: '时间',
              value: model.time,
              hintText: '请选择时间',
              endWidget: Icon(Icons.chevron_right),
              onTap: () async {
                String time = await showPickerDate(context);
                if (time != null && time.isNotEmpty) {
                  model.setTime(time);
                }
              },
            ),
          ],
        ),
      ),
      //销量进度追踪 +
      SliverToBoxAdapter(
        child: ListTile(
          title: const Text('销量进度追踪',
              style: TextStyle(color: AppColors.FF959EB1, fontSize: 12.0)),
          trailing: IconButton(
              onPressed: () =>
                  model.addToSalesTrackingList(SalesTrackingModel()),
              icon: Icon(Icons.add_circle, color: AppColors.FFC68D3E)),
        ),
      ),
      ////销量进度追踪list
      SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
        SalesTrackingModel salesTrackingModel = model.salesTrackingList[index];
        return PostSalesTrackingCell(
          salesTrackingModel: salesTrackingModel,
          forWeek: false,
          selectAction: () async {
            Map area = await showSelectTreeList(context, '');
            // print('area = $area');
            if (area != null && area.isNotEmpty) {
              String areaName = area['areaName'];
              String deptId = area['deptId'];
              salesTrackingModel.area.city = areaName;
              salesTrackingModel.area.cityId = deptId;
              model.editSalesTrackingListWith(index, salesTrackingModel);
            }
          },
          setTextAction: () =>
              model.editSalesTrackingListWith(index, salesTrackingModel),
          deleteAction: () => model.deleteSalesTrackingListWith(index),
        );
      }, childCount: model.salesTrackingList.length)),
      //合计
      SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          color: Colors.white,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('合计',
                style: const TextStyle(color: Colors.red, fontSize: 14.0)),
          ),
        ),
      ),
      SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
        Map map = list1[index];
        String title = map['title'];
        String value = map['value'];
        String hintText = map['hintText'];
        String end = map['end'];
        return Container(
          color: Colors.white,
          child: PostAddInputCellCore(
            onTap: null,
            title: title,
            value: value,
            hintText: hintText,
            endWidget: null,
            end: end,
            titleColor: AppColors.FF959EB1,
          ),
        );
      }, childCount: list1.length)),

      //本月重点工作总结
      PostDetailGroupTitle(color: null, name: '本月重点工作总结'),
      //列表
      SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
        String text = model.summaries[index];
        return PostAddDeletePlanCell(
          value: text,
          hintText: '请填写本月重点工作总结',
          isAdd: false,
          textOnTap: () => AppUtil.showInputDialog(
            context: context,
            text: text,
            hintText: '请填写本月重点工作总结',
            focusNode: _focusNode,
            editingController: _editingController,
            keyboardType: TextInputType.text,
            callBack: (text) =>
                model.editStringArrayWith(model.summaries, index, text),
          ),
          rightBtnOnTap: () =>
              model.deleteStringArrayWith(model.summaries, index),
        );
      }, childCount: model.summaries.length)),
      //添加按钮
      SliverToBoxAdapter(
        child: PostAddDeletePlanCell(
            value: _todaySummary,
            hintText: '请填写本月重点工作总结',
            isAdd: true,
            textOnTap: () => AppUtil.showInputDialog(
                context: context,
                text: _todaySummary,
                hintText: '请填写本月重点工作总结',
                focusNode: _focusNode,
                editingController: _editingController,
                keyboardType: TextInputType.text,
                callBack: (text) {
                  if (mounted) setState(() => _todaySummary = text);
                }),
            rightBtnOnTap: () {
              if (_todaySummary.isNotEmpty)
                model.addToStringArray(model.summaries, _todaySummary);
              if (mounted) setState(() => _todaySummary = '');
            }),
      ),
      //白底
      SliverToBoxAdapter(child: Container(color: Colors.white, height: 10.0)),
      //下月行程及工作内容
      PostDetailGroupTitle(color: null, name: '下月行程及工作内容'),
    ];
    //下月行程及工作内容
    model.itineraries.forEach((itineraryModel) {
      slivers.add(SliverToBoxAdapter(
          child: WhiteBGTitleView(title: itineraryModel.title)));
      slivers.add(_buildWeekSliverList(context, itineraryModel, model));
      slivers.add(_buildWeekAddBtn(context, itineraryModel, model));
    });
    //白底
    slivers.add(SliverToBoxAdapter(
        child: Container(color: Colors.white, height: 10.0)));

    //重点工作内容
    slivers.add(PostDetailGroupTitle(color: null, name: '重点工作内容'));
    //列表
    slivers.add(SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
      String text = model.plans[index];
      return PostAddDeletePlanCell(
        value: text,
        hintText: '请填写重点工作内容',
        isAdd: false,
        textOnTap: () => AppUtil.showInputDialog(
            context: context,
            text: text,
            hintText: '请填写重点工作内容',
            focusNode: _focusNode,
            editingController: _editingController,
            keyboardType: TextInputType.text,
            callBack: (text) =>
                model.editStringArrayWith(model.plans, index, text)),
        rightBtnOnTap: () => model.deleteStringArrayWith(model.plans, index),
      );
    }, childCount: model.plans.length)));
    //添加按钮
    slivers.add(SliverToBoxAdapter(
      child: PostAddDeletePlanCell(
          value: _plan,
          hintText: '请填写重点工作内容',
          isAdd: true,
          textOnTap: () => AppUtil.showInputDialog(
              context: context,
              text: _plan,
              hintText: '请填写重点工作内容',
              focusNode: _focusNode,
              editingController: _editingController,
              keyboardType: TextInputType.text,
              callBack: (text) {
                if (mounted) setState(() => _plan = text);
              }),
          rightBtnOnTap: () {
            if (_plan.isNotEmpty) model.addToStringArray(model.plans, _plan);
            if (mounted) setState(() => _plan = '');
          }),
    ));
    //白底
    slivers.add(SliverToBoxAdapter(
        child: Container(color: Colors.white, height: 10.0)));

    //问题反馈以及解决方案
    slivers.add(PostDetailGroupTitle(color: null, name: '问题反馈以及解决方案'));
    //列表
    slivers.add(SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
      String text = model.reports[index];
      return PostAddDeletePlanCell(
        value: text,
        hintText: '请填写问题反馈以及解决方案',
        isAdd: false,
        textOnTap: () => AppUtil.showInputDialog(
            context: context,
            text: text,
            hintText: '请填写问题反馈以及解决方案',
            focusNode: _focusNode,
            editingController: _editingController,
            keyboardType: TextInputType.text,
            callBack: (text) =>
                model.editStringArrayWith(model.reports, index, text)),
        rightBtnOnTap: () => model.deleteStringArrayWith(model.reports, index),
      );
    }, childCount: model.reports.length)));
    //添加按钮
    slivers.add(SliverToBoxAdapter(
      child: PostAddDeletePlanCell(
          value: _report,
          hintText: '请填写问题反馈以及解决方案',
          isAdd: true,
          textOnTap: () => AppUtil.showInputDialog(
              context: context,
              text: _report,
              hintText: '请填写问题反馈以及解决方案',
              focusNode: _focusNode,
              editingController: _editingController,
              keyboardType: TextInputType.text,
              callBack: (text) {
                if (mounted) setState(() => _report = text);
              }),
          rightBtnOnTap: () {
            if (_report.isNotEmpty)
              model.addToStringArray(model.reports, _report);
            if (mounted) setState(() => _report = '');
          }),
    ));
    //白底
    slivers.add(SliverToBoxAdapter(
        child: Container(color: Colors.white, height: 10.0)));

    slivers.add(SliverSafeArea(
      sliver: SliverToBoxAdapter(
        child: SubmitBtn(
          title: '提  交',
          onPressed: () => _submitAction(context, model, 2),
        ),
      ),
    ));

    return WillPopScope(
      onWillPop: () async => await AppUtil.onWillPop(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('新增月报'),
          actions: [
            TextButton(
                onPressed: () => _submitAction(context, model, 1),
                child:
                    const Text('保存草稿', style: TextStyle(color: Colors.black))),
          ],
        ),
        body: Scrollbar(
          child: CustomScrollView(slivers: slivers),
        ),
      ),
    );
  }

  ///提  交
  void _submitAction(
      BuildContext context, MonthPostAddNewModel model, int status) async {
    if (model.time.isEmpty) {
      AppUtil.showToastCenter('请选择时间');
      return;
    }
    if (model.salesTrackingList.isEmpty) {
      AppUtil.showToastCenter('请填写销量进度追踪');
      return;
    }
    bool needShow = false;
    model.salesTrackingList.forEach((SalesTrackingModel saModel) {
      if (saModel.area.cityId.isEmpty) {
        needShow = true;
      }
    });
    if (needShow) {
      AppUtil.showToastCenter('请选择区域');
      return;
    }
    Map param = model.toJson();
    param['userName'] = Store.readNickName();
    param['postName'] = Store.readPostName();
    param['status'] = status;
    LogUtil.d('param = ${jsonEncode(param)}');
    requestPost(Api.reportMonthAdd, json: param).then((value) {
      var data = jsonDecode(value.toString());
      // print('data = $data');
      if (data['code'] == 200) Navigator.pop(context, true);
    });
  }

  SliverToBoxAdapter _buildWeekAddBtn(BuildContext context,
      ItineraryModel itineraryModel, MonthPostAddNewModel model) {
    return SliverToBoxAdapter(
      child: PostAddDeletePlanCell(
          value: itineraryModel.tempWork,
          hintText: '请填写行程及工作内容',
          isAdd: true,
          textOnTap: () => AppUtil.showInputDialog(
              context: context,
              text: itineraryModel.tempWork,
              hintText: '请填写行程及工作内容',
              focusNode: _focusNode,
              editingController: _editingController,
              keyboardType: TextInputType.text,
              callBack: (text) {
                if (mounted) setState(() => itineraryModel.tempWork = text);
              }),
          rightBtnOnTap: () {
            if (itineraryModel.tempWork.isNotEmpty)
              model.addItineraryWorks(
                  model: itineraryModel, text: itineraryModel.tempWork);
            if (mounted) setState(() => itineraryModel.tempWork = '');
          }),
    );
  }

  SliverList _buildWeekSliverList(BuildContext context,
      ItineraryModel itineraryModel, MonthPostAddNewModel model) {
    return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
      String text = itineraryModel.works[index];
      return Column(
        children: [
          PostAddDeletePlanCell(
            value: text,
            hintText: '请填写行程及工作内容',
            isAdd: false,
            textOnTap: () => AppUtil.showInputDialog(
              context: context,
              text: text,
              hintText: '请填写行程及工作内容',
              focusNode: _focusNode,
              editingController: _editingController,
              keyboardType: TextInputType.text,
              callBack: (text) => model.editItineraryWorksWith(
                  model: itineraryModel, index: index, value: text),
            ),
            rightBtnOnTap: () => model.deleteItineraryWorksWith(
                model: itineraryModel, index: index),
          ),
        ],
      );
    }, childCount: itineraryModel.works.length));
  }

  @override
  void dispose() {
    super.dispose();
    _editingController?.dispose();
    _focusNode?.dispose();
  }
}
