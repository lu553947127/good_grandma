import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/marketing_activity_model.dart';
import 'package:good_grandma/widgets/activity_add_text_cell.dart';
import 'package:good_grandma/widgets/add_content_input.dart';
import 'package:good_grandma/widgets/marketing_activity_detail_title.dart';
import 'package:good_grandma/widgets/post_detail_group_title.dart';
import 'package:good_grandma/widgets/submit_btn.dart';

///编辑活动报表
class EditActivityReportPage extends StatefulWidget {
  const EditActivityReportPage(
      {Key key,
      @required this.model,
      @required this.state,
      @required this.stateColor})
      : super(key: key);
  final MarketingActivityModel model;
  final String state;
  final Color stateColor;

  @override
  _EditActivityReportPageState createState() => _EditActivityReportPageState();
}

class _EditActivityReportPageState extends State<EditActivityReportPage> {
  final TextEditingController _editingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _selItem1 = true;
  @override
  Widget build(BuildContext context) {
    List<Map> infos = _getInfos(context);
    return WillPopScope(
      onWillPop: () => AppUtil.onWillPop(context),
      child: Scaffold(
          appBar: AppBar(title: const Text('编辑活动报表')),
          body: Scrollbar(
              child: CustomScrollView(
            slivers: [
              MarketingActivityDetailTitle(
                  model: widget.model,
                  state: widget.state,
                  stateColor: widget.stateColor,
                  showTime: false),
              PostDetailGroupTitle(color: null, name: '报表信息'),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    Map map = infos[index];
                    String title = map['title'];
                    String value = map['value'];
                    if(index == 2){
                      return Container(
                        color: Colors.white,
                        child: ListTile(
                          title: Row(
                            children: [
                              Text(title),
                              Spacer(),
                              TextButton(onPressed: (){
                                setState(() {
                                  _selItem1 = true;
                                });
                              }, child: Row(
                                children: [
                                  _selItem1
                                      ?Icon(Icons.check_circle,color: AppColors.FFC08A3F,size: 16.0)
                                      :Icon(Icons.radio_button_unchecked,color: AppColors.FFC1C8D7,size: 16.0),
                                  Text('选项',style: const TextStyle(color: AppColors.FF2F4058,fontSize: 14.0))
                                ],
                              )),
                              TextButton(onPressed: (){
                                setState(() {
                                  _selItem1 = false;
                                });
                              }, child: Row(
                                children: [
                                  !_selItem1
                                      ?Icon(Icons.check_circle,color: AppColors.FFC08A3F,size: 16.0)
                                      :Icon(Icons.radio_button_unchecked,color: AppColors.FFC1C8D7,size: 16.0),
                                  Text('选项',style: const TextStyle(color: AppColors.FF2F4058,fontSize: 14.0))
                                ],
                              )),
                            ],
                          ),
                        ),
                      );
                    }
                    String hintText = map['hintText'];
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
              SliverToBoxAdapter(
                child: ContentInputView(
                  sizeHeight: 10,
                  color: Colors.white,
                  leftTitle: '文本区域',
                  rightPlaceholder: '请输入内容',
                  onChanged: (tex) {
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: SubmitBtn(
                  title: '提  交',
                  onPressed: () {},
                ),
              )
            ],
          ))),
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
    switch(index){
      case 0:
        {
          AppUtil.showInputDialog(
              context: context,
              editingController: _editingController,
              focusNode: _focusNode,
              text: value,
              hintText: hintText,
              keyboardType: keyboardType,
              callBack: (text) {

              });
        }
        break;
      case 1:
        {
          //时间
          String result = await showPickerDate(context);
          if (result != null && result.isNotEmpty) {
          }
        }
        break;
    }
  }

  List<Map> _getInfos(BuildContext context) {
    return [
      {
        'title': '文本框',
        'hintText': '请输入内容',
        'value': '',
        'trailing': '',
        'isSelect': false,
        'keyboardType': null,
      },
      {
        'title': '时间',
        'hintText': '请选择时间',
        'value': '',
        'trailing': '',
        'isSelect': true,
        'keyboardType': null,
      },
      {
        'title': '单选按钮',
        'hintText': '请选择结束时间',
        'value': '',
        'trailing': '',
        'isSelect': true,
        'keyboardType': null,
      },
    ];
  }
  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _editingController.dispose();
  }
}
