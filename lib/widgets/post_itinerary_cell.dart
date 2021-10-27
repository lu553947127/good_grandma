import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:good_grandma/common/cities.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/week_post_add_new_model.dart';
import 'package:good_grandma/widgets/post_add_input_cell.dart';

class PostItineraryCell extends StatelessWidget {
  const PostItineraryCell({
    Key key,
    @required this.itModel,
    @required this.pickerItems,
    @required this.provinces,
    @required this.focusNode,
    @required this.editingController,
    @required this.selectAction,
  }) : super(key: key);

  final ItineraryNewModel itModel;
  final List<PickerItem> pickerItems;
  final List<ProvinceModel> provinces;
  final FocusNode focusNode;
  final TextEditingController editingController;
  final VoidCallback selectAction;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: ListTile(
          title: Text(itModel.title),
          subtitle: Column(
            children: [
              PostAddInputCell(
                  title: '上周计划城市',
                  value: itModel.lastCity,
                  hintText: '填写城市',
                  // endWidget:
                  //     Icon(Icons.chevron_right, color: AppColors.FF2F4058),
                  contentPadding: const EdgeInsets.only(left: 15.0),
                  onTap: () => AppUtil.showInputDialog(
                      context: context,
                      text: itModel.lastCity,
                      hintText: '请填写上周计划城市',
                      focusNode: focusNode,
                      editingController: editingController,
                      keyboardType: TextInputType.text,
                      callBack: (text) {
                        itModel.lastCity = text;
                        if (selectAction != null) selectAction();
                      })),
              PostAddInputCell(
                  title: '实际工作城市',
                  value: itModel.actualCity,
                  hintText: '填写城市',
                  // endWidget:
                  //     Icon(Icons.chevron_right, color: AppColors.FF2F4058),
                  contentPadding: const EdgeInsets.only(left: 15.0),
                  onTap: () => AppUtil.showInputDialog(
                      context: context,
                      text: itModel.actualCity,
                      hintText: '请填写实际工作城市',
                      focusNode: focusNode,
                      editingController: editingController,
                      keyboardType: TextInputType.text,
                      callBack: (text) {
                        itModel.actualCity = text;
                        if (selectAction != null) selectAction();
                      })),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                  child: Text('工作内容',
                      style: const TextStyle(
                          color: AppColors.FF2F4058, fontSize: 14.0)),
                ),
              ),
              GestureDetector(
                onTap: () => AppUtil.showInputDialog(
                    context: context,
                    text: itModel.work,
                    hintText: '请填写工作内容',
                    focusNode: focusNode,
                    editingController: editingController,
                    keyboardType: TextInputType.text,
                    callBack: (text) {
                      itModel.work = text;
                      if (selectAction != null) selectAction();
                    }),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.5),
                      border: Border.all(color: AppColors.FFEFEFF4, width: 1)),
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 15.0),
                  padding: const EdgeInsets.all(10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        itModel.work.isNotEmpty ? itModel.work : '请填写工作内容',
                        style: TextStyle(
                            color: itModel.work.isNotEmpty
                                ? Colors.black
                                : AppColors.FFC1C8D7)),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
