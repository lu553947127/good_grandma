import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/week_post_add_new_model.dart';
import 'package:good_grandma/widgets/post_add_input_cell.dart';

class PostSalesTrackingCell extends StatelessWidget {
  PostSalesTrackingCell({
    Key key,
    @required this.salesTrackingModel,
    this.forWeek = true,
    @required this.selectAction,
    @required this.setTextAction,
    @required this.deleteAction,
  }) : super(key: key);

  final SalesTrackingModel salesTrackingModel;
  final bool forWeek;
  final VoidCallback selectAction;
  final VoidCallback setTextAction;
  final VoidCallback deleteAction;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Map> list = [
      {
        'title': '区域',
        'value': salesTrackingModel.area.city,
        'end': '>',
        'hintText': '请选择区域'
      },
      {
        'title': '本${forWeek?'周':'月'}目标',
        'value': salesTrackingModel.target.toStringAsFixed(2),
        'end': '万元',
        'hintText': '请输入金额'
      },
      {
        'title': '本${forWeek?'周':'月'}实际',
        'value': salesTrackingModel.actual.toStringAsFixed(2),
        'end': '万元',
        'hintText': '请输入金额'
      },
      {
        'title': '本月累计',
        'value': salesTrackingModel.cumulative.toStringAsFixed(2),
        'end': '万元',
        'hintText': '请输入金额'
      },
      {
        'title': '月度差额',
        'value': salesTrackingModel.difference.toStringAsFixed(2),
        'end': '万元',
        'hintText': '请输入金额'
      },
      {
        'title': '月度达成率',
        'value': salesTrackingModel.completionRate.toStringAsFixed(2),
        'end': '%',
        'hintText': ''
      },
      {
        'title': '下周规划进货金额',
        'value': salesTrackingModel.nextTarget.toStringAsFixed(2),
        'end': '万元',
        'hintText': '请输入金额'
      },
    ];
    return Container(
        color: Colors.white,
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          title: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.FFEFEFF4, width: 1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              children: [
                ...List.generate(list.length, (index) {
                  Map map = list[index];
                  String title = map['title'];
                  String value = map['value'];
                  String hintText = map['hintText'];
                  String end = map['end'];
                  return PostAddInputCell(
                      title: title,
                      value: value,
                      hintText: hintText,
                      bgColor: AppColors.FFFBFBFC,
                      endWidget: end == '>'
                          ? Icon(Icons.chevron_right, color: AppColors.FF2F4058)
                          : null,
                      end: end,
                      onTap: () async{
                        if (index == 0) {
                          if (selectAction != null) selectAction();
                        } else {
                          AppUtil.showInputDialog(
                              context: context,
                              text: value == '0.00' ? '':value,
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
                                  case 1:
                                    {
                                      salesTrackingModel.target =
                                          double.parse(text);
                                      if (setTextAction != null) setTextAction();
                                    }
                                    break;
                                  case 2:
                                    {
                                      salesTrackingModel.actual =
                                          double.parse(text);
                                      if (setTextAction != null) setTextAction();
                                    }
                                    break;
                                  case 3:
                                    {
                                      salesTrackingModel.cumulative =
                                          double.parse(text);
                                      if (setTextAction != null) setTextAction();
                                    }
                                    break;
                                  case 4:
                                    {
                                      salesTrackingModel.difference =
                                          double.parse(text);
                                      if (setTextAction != null) setTextAction();
                                    }
                                    break;
                                  case 5:
                                    {
                                      salesTrackingModel.completionRate =
                                          double.parse(text);
                                      if (setTextAction != null) setTextAction();
                                    }
                                    break;
                                  case 6:
                                    {
                                      salesTrackingModel.nextTarget =
                                          double.parse(text);
                                      if (setTextAction != null) setTextAction();
                                    }
                                    break;
                                }
                              });
                        }
                      });
                }),
                Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        onPressed: deleteAction,
                        icon:
                        Icon(Icons.delete_forever_outlined, color: Colors.red)))
              ],
            ),
          ),
        ));
  }
}
