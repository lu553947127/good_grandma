import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/month_post_add_model.dart';
import 'package:good_grandma/models/week_post_add_model.dart';
import 'package:good_grandma/widgets/post_add_input_cell.dart';
import 'package:good_grandma/widgets/post_detail_group_title.dart';
import 'package:good_grandma/widgets/postadd_delete_plan_cell.dart';
import 'package:good_grandma/widgets/submit_btn.dart';
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
  final List<Map> _list1 = [
    {'title': '本月目标', 'end': '元', 'hintText': '请填写金额'},
    {'title': '本月实际', 'end': '元', 'hintText': '请填写金额'},
    {'title': '本月累计', 'end': '元', 'hintText': '请填写金额'},
    {'title': '月度达成率', 'end': '%', 'hintText': ''},
    {'title': '下月规划进货金额', 'end': '元', 'hintText': '请填写金额'},
  ];
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
    final MonthPostAddModel model = Provider.of<MonthPostAddModel>(context);
    final List values = [
      model.target,
      model.actual,
      model.cumulative,
      model.achievementRate,
      model.nextTarget,
    ];

    List<Widget> slivers = [
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
                  keyboardType:
                  TextInputType.numberWithOptions(signed: false, decimal: true),
                  callBack: (text) {
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
                      case 4:
                        model.setNextTarget(text);
                        break;
                    }
                  }),
            );
          }, childCount: _list1.length)),
      //本周行程及工作内容
      PostDetailGroupTitle(color: null, name: '本周行程及工作内容'),
      //本周区域重点工作总结
      SliverToBoxAdapter(child: _WhiteBGTitleView(title: '本周区域重点工作总结')),
      //列表
      SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            String text = model.summaries[index];
            return PostAddDeletePlanCell(
              value: text,
              hintText: '请填写本周区域重点工作总结',
              isAdd: false,
              textOnTap: () => AppUtil.showInputDialog(
                context: context,
                text: text,
                hintText: '请填写本周区域重点工作总结',
                focusNode: _focusNode,
                editingController: _editingController,
                keyboardType: TextInputType.text,
                callBack: (text) => model.editSummariesWith(index, text),
              ),
              rightBtnOnTap: () => model.deleteSummariesWith(index),
            );
          }, childCount: model.summaries.length)),
      //添加按钮
      SliverToBoxAdapter(
        child: PostAddDeletePlanCell(
            value: _todaySummary,
            hintText: '请填写本周区域重点工作总结',
            isAdd: true,
            textOnTap: () => AppUtil.showInputDialog(
                context: context,
                text: _todaySummary,
                hintText: '请填写本周区域重点工作总结',
                focusNode: _focusNode,
                editingController: _editingController,
                keyboardType: TextInputType.text,
                callBack: (text) {
                  if (mounted) setState(() => _todaySummary = text);
                }),
            rightBtnOnTap: () {
              if (_todaySummary.isNotEmpty) model.addSummary(_todaySummary);
              if (mounted) setState(() => _todaySummary = '');
            }),
      ),
      //白底
      SliverToBoxAdapter(
          child: Container(color: Colors.white, height: 10.0)),
      //下月行程及工作内容
      PostDetailGroupTitle(color: null, name: '下月行程及工作内容'),
    ];
    //下月行程及工作内容
    model.itineraries.forEach((itineraryModel) {
      slivers.add(SliverToBoxAdapter(
          child: _WhiteBGTitleView(title: itineraryModel.title)));
      slivers.add(_buildWeekSliverList(context, itineraryModel));
      slivers.add(_buildWeekAddBtn(context, itineraryModel));
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
                callBack: (text) => model.editPlanWith(index, text)),
            rightBtnOnTap: () => model.deletePlanWith(index),
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
            if (_plan.isNotEmpty) model.addPlan(_plan);
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
                callBack: (text) => model.editReportWith(index, text)),
            rightBtnOnTap: () => model.deleteReportWith(index),
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
            if (_report.isNotEmpty) model.addPlan(_report);
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
          onPressed: () => _submitAction(context),
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
                onPressed: () => _saveDraftAction(context),
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

  ///保存草稿
  void _saveDraftAction(BuildContext context) async {
    // final WeekPostAddModel model =
    //     Provider.of<WeekPostAddModel>(context, listen: false);
  }

  ///提  交
  void _submitAction(BuildContext context) async {
    // final WeekPostAddModel model =
    //     Provider.of<WeekPostAddModel>(context, listen: false);
  }

  SliverToBoxAdapter _buildWeekAddBtn(
      BuildContext context, ItineraryModel itineraryModel) {
    final MonthPostAddModel model = Provider.of<MonthPostAddModel>(context);
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

  SliverList _buildWeekSliverList(
      BuildContext context, ItineraryModel itineraryModel) {
    final MonthPostAddModel model = Provider.of<MonthPostAddModel>(context);
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

class _WhiteBGTitleView extends StatelessWidget {
  const _WhiteBGTitleView({
    Key key,
    @required String title,
  })  : _title = title,
        super(key: key);

  final String _title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
      child: Text(
        _title,
        style: const TextStyle(color: AppColors.FF2F4058, fontSize: 14.0),
      ),
    );
  }
}
