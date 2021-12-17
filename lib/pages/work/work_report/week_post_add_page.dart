import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/cities.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/store.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/week_post_add_new_model.dart';
import 'package:good_grandma/widgets/post_add_input_cell.dart';
import 'package:good_grandma/widgets/post_detail_group_title.dart';
import 'package:good_grandma/widgets/post_itinerary_cell.dart';
import 'package:good_grandma/widgets/post_sales_tracking_cell.dart';
import 'package:good_grandma/widgets/postadd_delete_plan_cell.dart';
import 'package:good_grandma/widgets/select_tree.dart';
import 'package:good_grandma/widgets/submit_btn.dart';
import 'package:good_grandma/widgets/white_bg_title_view.dart';
import 'package:provider/provider.dart';

///新增周报
class WeekPostAddPage extends StatefulWidget {
  WeekPostAddPage({
    Key key,
    this.id = '',
  }) : super(key: key);
  final String id;
  @override
  State<StatefulWidget> createState() => _Body();
}

class _Body extends State<WeekPostAddPage> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _editingController = TextEditingController();
  final List<PickerItem> _pickerItems = [];
  final List<ProvinceModel> _provinces = [];
  final List<String> _provinceNames = [];

  @override
  void initState() {
    super.initState();
    _getRegionList();
    if (widget.id.isNotEmpty) _requestDetail();
  }

  ///标记草稿请求详情
  _requestDetail() async {
    requestPost(Api.reportDayDetail,
        json: jsonEncode({'id': widget.id, 'type': 2})).then((value) {
      Map map = jsonDecode(value.toString())['data'];
      final WeekPostAddNewModel model =
          Provider.of<WeekPostAddNewModel>(this.context, listen: false);
      model.fromJson(map);
      model.id = widget.id;
      // print('object');
    });
  }

  @override
  Widget build(BuildContext context) {
    final WeekPostAddNewModel model = Provider.of<WeekPostAddNewModel>(context);
    List<Map> list1 = _getList1(model);

    return WillPopScope(
      onWillPop: () async => await AppUtil.onWillPop(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.id.isNotEmpty ? '编辑周报' : '新增周报'),
          actions: [
            TextButton(
                onPressed: () => _submitAction(context, model, 1),
                child:
                    const Text('保存草稿', style: TextStyle(color: Colors.black))),
          ],
        ),
        body: Scrollbar(
          child: CustomScrollView(slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  PostAddInputCell(
                    title: '报告人',
                    value: Store.readNickName() + ' - ' + Store.readPostName(),
                    hintText: '',
                    onTap: null,
                  ),
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
                    style:
                        TextStyle(color: AppColors.FF959EB1, fontSize: 12.0)),
                trailing: IconButton(
                    onPressed: () =>
                        model.addToSalesTrackingList(SalesTrackingModel()),
                    icon: Icon(Icons.add_circle, color: AppColors.FFC68D3E)),
              ),
            ),
            ////销量进度追踪list
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              SalesTrackingModel salesTrackingModel =
                  model.salesTrackingList[index];
              return PostSalesTrackingCell(
                salesTrackingModel: salesTrackingModel,
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
                      style:
                          const TextStyle(color: Colors.red, fontSize: 14.0)),
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
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6),
                  title: title,
                  value: value,
                  hintText: hintText,
                  endWidget: null,
                  end: end,
                  titleColor: AppColors.FF959EB1,
                ),
              );
            }, childCount: list1.length)),
            //目标达成说明
            SliverToBoxAdapter(child: WhiteBGTitleView(title: '目标达成说明')),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: GestureDetector(
                  onTap: () => AppUtil.showInputDialog(
                      context: context,
                      text: model.targetDesc,
                      hintText: '请填写目标达成说明',
                      focusNode: _focusNode,
                      editingController: _editingController,
                      keyboardType: TextInputType.text,
                      callBack: (text) {
                        model.setTargetDesc(text);
                      }),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.5),
                        border:
                            Border.all(color: AppColors.FFEFEFF4, width: 1)),
                    width: double.infinity,
                    margin: const EdgeInsets.only(left: 15.0, right: 15.0),
                    padding: const EdgeInsets.all(10.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          model.targetDesc.isNotEmpty
                              ? model.targetDesc
                              : '请填写目标达成说明',
                          style: TextStyle(
                              color: model.targetDesc.isNotEmpty
                                  ? Colors.black
                                  : AppColors.FFC1C8D7)),
                    ),
                  ),
                ),
              ),
            ),
            //本周行程及工作内容
            PostDetailGroupTitle(color: null, name: '本周行程及工作内容'),
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              ItineraryNewModel itModel = model.itineraries[index];
              return PostItineraryCell(
                  itModel: itModel,
                  focusNode: _focusNode,
                  editingController: _editingController,
                  provinces: _provinces,
                  pickerItems: _pickerItems,
                  selectAction: () =>
                      model.editItineraryNewModelWith(itModel, index));
            }, childCount: model.itineraries.length)),
            //本周区域重点工作总结
            SliverToBoxAdapter(child: WhiteBGTitleView(title: '本周区域重点工作总结')),
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
                  value: '',
                  hintText: '请填写本周区域重点工作总结',
                  isAdd: true,
                  textOnTap: () => AppUtil.showInputDialog(
                      context: context,
                      text: '',
                      hintText: '请填写本周区域重点工作总结',
                      focusNode: _focusNode,
                      editingController: _editingController,
                      keyboardType: TextInputType.text,
                      callBack: (text) {
                        if (text.isNotEmpty)
                          model.addToStringArray(model.summaries, text);
                      }),
                  rightBtnOnTap: () {}),
            ),
            //白底
            SliverToBoxAdapter(
                child: Container(color: Colors.white, height: 10.0)),
            //下周行程及重点工作内容
            PostDetailGroupTitle(color: null, name: '下周行程及重点工作内容'),
            //填写城市
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              CityPlanModel cityModel = model.cities[index];
              return PostAddInputCell(
                title: cityModel.title,
                value: cityModel.city,
                hintText: '请填写城市',
                onTap: () => AppUtil.showInputDialog(
                    context: context,
                    text: cityModel.city,
                    hintText: '请填写城市',
                    focusNode: _focusNode,
                    editingController: _editingController,
                    keyboardType: TextInputType.text,
                    callBack: (text) {
                      cityModel.city = text;
                      model.editCityWith(index: index, city: cityModel.city);
                    }),
              );
            }, childCount: model.cities.length)),
            //下周工作内容
            SliverToBoxAdapter(child: WhiteBGTitleView(title: '下周工作内容')),
            //列表
            SliverList(
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
                    callBack: (text) =>
                        model.editStringArrayWith(model.plans, index, text)),
                rightBtnOnTap: () =>
                    model.deleteStringArrayWith(model.plans, index),
              );
            }, childCount: model.plans.length)),
            //添加按钮
            SliverToBoxAdapter(
              child: PostAddDeletePlanCell(
                  value: '',
                  hintText: '请填写下周工作内容',
                  isAdd: true,
                  textOnTap: () => AppUtil.showInputDialog(
                      context: context,
                      text: '',
                      hintText: '请填写下周工作内容',
                      focusNode: _focusNode,
                      editingController: _editingController,
                      keyboardType: TextInputType.text,
                      callBack: (text) {
                        if (text.isNotEmpty)
                          model.addToStringArray(model.plans, text);
                      }),
                  rightBtnOnTap: () {}),
            ),
            //白底
            SliverToBoxAdapter(
                child: Container(color: Colors.white, height: 10.0)),
            SliverSafeArea(
              sliver: SliverToBoxAdapter(
                child: SubmitBtn(
                  title: '提  交',
                  onPressed: () => _submitAction(context, model, 2),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  List<Map> _getList1(WeekPostAddNewModel model) {
    return [
      {'title': '本周目标', 'value': model.target.toStringAsFixed(2), 'end': '万元'},
      {'title': '本周实际', 'value': model.actual.toStringAsFixed(2), 'end': '万元'},
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
        'value': model.completionRate.toStringAsFixed(2),
        'end': '%'
      },
      {
        'title': '下周规划进货金额',
        'value': model.nextTarget.toStringAsFixed(2),
        'end': '万元'
      }
    ];
  }

  ///提  交
  void _submitAction(
      BuildContext context, WeekPostAddNewModel model, int status) async {
    if (model.time.isEmpty && status != 1) {
      AppUtil.showToastCenter('请选择时间');
      return;
    }
    if (model.salesTrackingList.isEmpty && status != 1) {
      AppUtil.showToastCenter('请填写销量进度追踪');
      return;
    }
    bool needShow = false;
    model.salesTrackingList.forEach((SalesTrackingModel saModel) {
      if (saModel.area.cityId.isEmpty) {
        needShow = true;
      }
    });
    if (needShow && status != 1) {
      AppUtil.showToastCenter('请选择区域');
      return;
    }
    // if (model.cumulative.isEmpty) {
    //   AppUtil.showToastCenter('请填写本月累计');
    //   return;
    // }
    // if (model.nextTarget.isEmpty) {
    //   AppUtil.showToastCenter('请填写下周规划进货金额');
    //   return;
    // }
    // bool needShow = false;
    // model.itineraries.forEach((ItineraryModel itineraryModel) {
    //   if (itineraryModel.works.isEmpty) {
    //     needShow = true;
    //   }
    // });
    // if (needShow) {
    //   AppUtil.showToastCenter('请填写本周行程及工作内容');
    //   return;
    // }
    // if (model.summaries.isEmpty) {
    //   AppUtil.showToastCenter('请填写本周区域重点工作总结');
    //   return;
    // }
    // needShow = false;
    // if (model.cities.isEmpty) {
    //   AppUtil.showToastCenter('请选择下周行程');
    //   return;
    // }
    // if (model.plans.isEmpty) {
    //   AppUtil.showToastCenter('请填写下周工作内容');
    //   return;
    // }
    Map param = model.toJson();
    param['userName'] = Store.readNickName();
    param['postName'] = Store.readPostName();
    param['status'] = status;
    LogUtil.d('param = ${jsonEncode(param)}');
    requestPost(Api.reportWeekAdd, json: param).then((value) {
      var data = jsonDecode(value.toString());
      print('data = $data');
      if (data['code'] == 200) Navigator.pop(context, true);
    });
  }

  void _getRegionList() async {
    requestGet(Api.regionList).then((value) {
      LogUtil.d('value = $value');
      var data = jsonDecode(value.toString());
      final List<dynamic> list = data['data'];
      _provinces.clear();
      _provinceNames.clear();
      list.forEach((pro) {
        ProvinceModel provinceModel = ProvinceModel.fromJson(pro);
        if (provinceModel.cities.isNotEmpty) {
          _provinces.add(provinceModel);
          _provinceNames.add(provinceModel.provinceName);
          final List<PickerItem> cityPickerItems = [];
          provinceModel.cities.forEach((city) {
            cityPickerItems.add(PickerItem(
                text: Text(city.citiesName), value: city.citiesName));
          });
          _pickerItems.add(PickerItem(
              text: Text(provinceModel.provinceName),
              value: provinceModel.provinceName,
              children: cityPickerItems));
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _editingController?.dispose();
    _focusNode?.dispose();
  }
}
