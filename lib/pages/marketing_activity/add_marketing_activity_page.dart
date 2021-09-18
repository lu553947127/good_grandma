import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';
import 'package:good_grandma/common/number_counter.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/goods_model.dart';
import 'package:good_grandma/models/marketing_activity_model.dart';
import 'package:good_grandma/pages/stock/select_goods_page.dart';
import 'package:good_grandma/widgets/activity_add_text_cell.dart';
import 'package:good_grandma/widgets/add_content_input.dart';
import 'package:good_grandma/widgets/submit_btn.dart';
import 'package:provider/provider.dart';

///新增市场活动
class AddMarketingActivityPage extends StatefulWidget {
  const AddMarketingActivityPage({Key key}) : super(key: key);

  @override
  _AddMarketingActivityPageState createState() =>
      _AddMarketingActivityPageState();
}

class _AddMarketingActivityPageState extends State<AddMarketingActivityPage> {
  final TextEditingController _editingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final MarketingActivityModel activityModel =
        Provider.of<MarketingActivityModel>(context);
    List<Map> infos = _getInfos(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('新增市场活动')),
        body: Scrollbar(
          child: CustomScrollView(
            slivers: [
              //活动信息
              SliverToBoxAdapter(
                child: ListTile(
                    title: const Text('活动信息',
                        style: TextStyle(
                            color: AppColors.FF959EB1, fontSize: 12.0))),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                Map map = infos[index];
                String title = map['title'];
                String hintText = map['hintText'];
                String value = map['value'];
                String trailingStr = map['trailing'];
                bool isSelect = map['isSelect'];
                TextInputType keyboardType = map['keyboardType'];
                Widget trailing;
                if (isSelect)
                  trailing = Icon(Icons.chevron_right);
                else if (trailingStr.isNotEmpty) trailing = Text(trailingStr);
                return ActivityAddTextCell(
                  title: title,
                  hintText: hintText,
                  value: value,
                  trailing: trailing,
                  onTap: () => _infoCellOnTap(
                      context: context,
                      index: index,
                      isSelect: isSelect,
                      value: value,
                      hintText: hintText,
                      keyboardType: keyboardType),
                );
              }, childCount: infos.length)),
              //活动商品
              SliverToBoxAdapter(
                child: ListTile(
                  title: const Text('商品名称',
                      style:
                          TextStyle(color: AppColors.FF959EB1, fontSize: 12.0)),
                  trailing: IconButton(
                      onPressed: () async {
                        List<GoodsModel> _selGoodsList = await Navigator.push(
                            context, MaterialPageRoute(builder: (_) {
                          return SelectGoodsPage(
                              selGoods: activityModel.goodsList, customerId: '',);
                        }));
                        if (_selGoodsList != null) {
                          activityModel.setGoodsList(_selGoodsList);
                          setState(() {});
                        }
                      },
                      icon: Icon(Icons.add_circle, color: AppColors.FFC68D3E)),
                ),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                GoodsModel model = activityModel.goodsList[index];
                return Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10.0),
                        title: Stack(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 9),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: MyCacheImageView(
                                          imageURL: model.image,
                                          width: 90,
                                          height: 82)),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                        model.name,
                                        style: const TextStyle(
                                            color: AppColors.FF2F4058,
                                            fontSize: 14.0),
                                      ),
                                    ),
                                    Text(
                                      model.specs.toString(),
                                      style: const TextStyle(
                                          color: AppColors.FF959EB1,
                                          fontSize: 12.0),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            //删除按钮
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                  onTap: () =>
                                      activityModel.deleteGoodsWith(index),
                                  child: Icon(Icons.delete_forever_outlined)),
                            ),
                            //修改数量
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: NumberCounter(
                                num: model.count,
                                subBtnOnTap: (){
                                  if(model.count==0)
                                    return;
                                  model.count--;
                                  activityModel.editGoodsWith(index, model);
                                },
                                addBtnOnTap: (){
                                  model.count++;
                                  activityModel.editGoodsWith(index, model);
                                },
                                numOnTap: () => AppUtil.showInputDialog(
                                    context: context,
                                    editingController: _editingController,
                                    focusNode: _focusNode,
                                    text: model.count.toString(),
                                    hintText: '请输入数字',
                                    keyboardType: TextInputType.number,
                                    callBack: (num){
                                      if(num.isEmpty)
                                        model.count = 0;
                                      else
                                        model.count = int.parse(num);
                                      activityModel.editGoodsWith(index, model);
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                          color: AppColors.FFEFEFF4,
                          thickness: 1,
                          height: 1,
                          indent: 15,
                          endIndent: 15)
                    ],
                  ),
                );
              }, childCount: activityModel.goodsList.length)),
              //活动描述
              SliverToBoxAdapter(
                child: ContentInputView(
                  sizeHeight: 10,
                  color: Colors.white,
                  leftTitle: '活动描述',
                  rightPlaceholder: '请输入活动描述',
                  onChanged: (tex) {
                    activityModel.setDescription(tex);
                  },
                ),
              ),
              //提  交
              SliverSafeArea(
                sliver: SliverToBoxAdapter(
                  child: SubmitBtn(
                      title: '提  交',
                      onPressed: () {
                        _submitAction(context);
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _infoCellOnTap({
    @required BuildContext context,
    @required int index,
    @required bool isSelect,
    @required String value,
    @required String hintText,
    @required TextInputType keyboardType,
  }) async {
    final MarketingActivityModel activityModel =
        Provider.of<MarketingActivityModel>(context, listen: false);
    if (isSelect) {
      switch (index) {
        case 2:
          {
            //活动类型
            String result = await showPicker(['类型一', '类型二'], context);
            if (result != null && result.isNotEmpty) {
              activityModel.setType(result);
            }
          }
          break;
        case 3:
          {
            //开始时间
            String result = await showPickerDate(context);
            if (result != null && result.isNotEmpty) {
              activityModel.setStartTime(result);
            }
          }
          break;
        case 4:
          {
            //结束时间
            String result = await showPickerDate(context);
            if (result != null && result.isNotEmpty) {
              activityModel.setEndTime(result);
            }
          }
          break;
      }
    } else {
      AppUtil.showInputDialog(
          context: context,
          editingController: _editingController,
          focusNode: _focusNode,
          text: value,
          hintText: hintText,
          keyboardType: keyboardType,
          callBack: (text) {
            switch (index) {
              case 0: //活动名称
                activityModel.setTitle(text);
                break;
              case 1: //负责人
                activityModel.setLeading(text);
                break;
              case 5: //主办方
                activityModel.setSponsor(text);
                break;
              case 6: //目标群体
                activityModel.setTarget(text);
                break;
              case 7: //目标数量
                activityModel.setTargetCount(text);
                break;
              case 8: //预算成本
                activityModel.setBudgetCount(text);
                break;
            }
          });
    }
  }

  List<Map> _getInfos(BuildContext context) {
    final MarketingActivityModel activityModel =
        Provider.of<MarketingActivityModel>(context);
    return [
      {
        'title': '活动名称',
        'hintText': '请输入活动名称',
        'value': activityModel.title,
        'trailing': '',
        'isSelect': false,
        'keyboardType': null,
      },
      {
        'title': '负责人',
        'hintText': '请输入负责人姓名',
        'value': activityModel.leading,
        'trailing': '',
        'isSelect': false,
        'keyboardType': null,
      },
      {
        'title': '活动类型',
        'hintText': '请选择活动类型',
        'value': activityModel.type,
        'trailing': '',
        'isSelect': true,
        'keyboardType': null,
      },
      {
        'title': '开始时间',
        'hintText': '请选择开始时间',
        'value': activityModel.startTime,
        'trailing': '',
        'isSelect': true,
        'keyboardType': null,
      },
      {
        'title': '结束时间',
        'hintText': '请选择结束时间',
        'value': activityModel.endTime,
        'trailing': '',
        'isSelect': true,
        'keyboardType': null,
      },
      {
        'title': '主办方',
        'hintText': '请输入主办方名称',
        'value': activityModel.sponsor,
        'trailing': '',
        'isSelect': false,
        'keyboardType': null,
      },
      {
        'title': '目标群体',
        'hintText': '请输入目标群体',
        'value': activityModel.target,
        'trailing': '',
        'isSelect': false,
        'keyboardType': null,
      },
      {
        'title': '目标数量',
        'hintText': '请输入目标群体数量',
        'value': activityModel.targetCount,
        'trailing': '',
        'isSelect': false,
        'keyboardType': TextInputType.number,
      },
      {
        'title': '预算成本',
        'hintText': '请输入预算成本',
        'value': activityModel.budgetCount,
        'trailing': '万元',
        'isSelect': false,
        'keyboardType': TextInputType.numberWithOptions(decimal: true),
      },
    ];
  }

  void _submitAction(BuildContext context) async {
    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _editingController.dispose();
  }
}


