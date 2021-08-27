import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:good_grandma/common/cities.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/week_post_add_model.dart';
import 'package:good_grandma/widgets/post_add_input_cell.dart';
import 'package:good_grandma/widgets/post_detail_group_title.dart';
import 'package:good_grandma/widgets/postadd_delete_plan_cell.dart';
import 'package:good_grandma/widgets/submit_btn.dart';
import 'package:provider/provider.dart';

///新增周报
class WeekPostAddPage extends StatefulWidget {
  WeekPostAddPage({
    Key key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _Body();
}

class _Body extends State<WeekPostAddPage> {
  final List<Map> _list1 = [
    {'title': '本月目标', 'end': '元', 'hintText': '请填写金额'},
    {'title': '本周实际', 'end': '元', 'hintText': '请填写金额'},
    {'title': '本月累计', 'end': '元', 'hintText': '请填写金额'},
    {'title': '月度达成率', 'end': '%', 'hintText': ''},
    {'title': '下周规划进货金额', 'end': '元', 'hintText': '请填写金额'},
  ];
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _editingController = TextEditingController();

  ///今日工作总结暂存
  String _todaySummary = '';

  ///明日工作计划暂存
  String _plan = '';
  final List<PickerItem> _pickerItems = [];
  final List<ProvinceModel> _provinces = [];

  @override
  void initState() {
    super.initState();
    _initCityArray();
  }

  @override
  Widget build(BuildContext context) {
    final WeekPostAddModel model = Provider.of<WeekPostAddModel>(context);
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
    ];
    model.itineraries.forEach((itineraryModel) {
      //周一
      slivers.add(SliverToBoxAdapter(
          child: _WhiteBGTitleView(title: itineraryModel.title)));
      slivers.add(_buildWeekSliverList(context, itineraryModel));
      slivers.add(_buildWeekAddBtn(context, itineraryModel));
    });
    //本周区域重点工作总结
    slivers
        .add(SliverToBoxAdapter(child: _WhiteBGTitleView(title: '本周区域重点工作总结')));
    //列表
    slivers.add(
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
    );
    //添加按钮
    slivers.add(SliverToBoxAdapter(
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
    ));
    //白底
    slivers.add(SliverToBoxAdapter(
        child: Container(color: Colors.white, height: 10.0)));
    //下周行程及重点工作内容
    slivers.add(PostDetailGroupTitle(color: null, name: '下周行程及重点工作内容'));
    //选择城市
    slivers.add(SliverList(delegate: SliverChildBuilderDelegate((context,index){
      CityPlanModel cityModel = model.cities[index];
      return PostAddInputCell(
        title: cityModel.title,
        value: cityModel.city,
        hintText: '请选择城市',
        endWidget: Icon(Icons.chevron_right),
        onTap: () {
          Picker(
              adapter: PickerDataAdapter(data: _pickerItems),
              selecteds: cityModel.selectedIndexes,
              changeToFirst: true,
              hideHeader: false,
              cancelText: '取消',
              confirmText: '确定',
              cancelTextStyle: TextStyle(fontSize: 14, color: Color(0xFF2F4058)),
              confirmTextStyle: TextStyle(fontSize: 14, color: Color(0xFFC68D3E)),
              columnPadding: const EdgeInsets.all(4.0),
              onConfirm: (picker, value) {
                final pro = _provinces[value.first];
                final city = pro.cities[value.last].citiesName;
                model.editCityWith(index: index,selectedIndexes: value,city: city,selectedNames: [pro.provinceName,city]);
                // print(value.toString());
                // print(picker.adapter.text);
              }
          ).showModal(this.context);
          // _showPickerModal(context);
          // model.editCityWith(index, 'value');
        },
      );
    },childCount: model.cities.length)));
    //下周工作内容
    slivers.add(SliverToBoxAdapter(child: _WhiteBGTitleView(title: '下周工作内容')));
    //列表
    slivers.add(SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
      String text = model.plans[index];
      return PostAddDeletePlanCell(
        value: text,
        hintText: '请填写下周工作内容',
        isAdd: false,
        textOnTap: () => AppUtil.showInputDialog(
            context: context,
            text: text,
            hintText: '请填写下周工作内容',
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
          hintText: '请填写下周工作内容',
          isAdd: true,
          textOnTap: () => AppUtil.showInputDialog(
              context: context,
              text: _plan,
              hintText: '请填写下周工作内容',
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
          title: const Text('新增周报'),
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
  _initCityArray(){
    final List ps = jsonDecode(Cities);
    ps.forEach((map) {
      ProvinceModel provinceModel = ProvinceModel.fromJson(map);
      _provinces.add(provinceModel);
      final List<PickerItem> cityPickerItems = [];
      provinceModel.cities.forEach((city) {
        cityPickerItems.add(PickerItem(text: Text(city.citiesName),value: city.citiesName));
      });
      _pickerItems.add(PickerItem(text: Text(provinceModel.provinceName),value: provinceModel.provinceName,children: cityPickerItems));
    });
  }

  SliverToBoxAdapter _buildWeekAddBtn(
      BuildContext context, ItineraryModel itineraryModel) {
    final WeekPostAddModel model = Provider.of<WeekPostAddModel>(context);
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
    final WeekPostAddModel model = Provider.of<WeekPostAddModel>(context);
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
