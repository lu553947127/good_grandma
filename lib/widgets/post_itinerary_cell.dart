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
                  value: itModel.lastCity.city,
                  hintText: '选择城市',
                  endWidget:
                      Icon(Icons.chevron_right, color: AppColors.FF2F4058),
                  contentPadding: const EdgeInsets.only(left: 15.0),
                  onTap: () {
                    Picker(
                        adapter: PickerDataAdapter(data: pickerItems),
                        selecteds: itModel.lastCity.selectedIndexes,
                        changeToFirst: true,
                        hideHeader: false,
                        cancelText: '取消',
                        confirmText: '确定',
                        cancelTextStyle:
                            TextStyle(fontSize: 14, color: Color(0xFF2F4058)),
                        confirmTextStyle:
                            TextStyle(fontSize: 14, color: Color(0xFFC68D3E)),
                        columnPadding: const EdgeInsets.all(4.0),
                        onConfirm: (picker, value) {
                          final pro = provinces[value.first];
                          final city = pro.cities[value.last].citiesName;
                          final cityId = pro.cities[value.last].id;
                          itModel.lastCity.city = city;
                          itModel.lastCity.cityId = cityId;
                          itModel.lastCity.selectedIndexes = value;
                          if (selectAction != null) selectAction();
                          // print(value.toString());
                          // print(picker.adapter.text);
                        }).showModal(context);
                  }),
              PostAddInputCell(
                  title: '实际工作城市',
                  value: itModel.actualCity.city,
                  hintText: '选择城市',
                  endWidget:
                      Icon(Icons.chevron_right, color: AppColors.FF2F4058),
                  contentPadding: const EdgeInsets.only(left: 15.0),
                  onTap: () {
                    Picker(
                        adapter: PickerDataAdapter(data: pickerItems),
                        selecteds: itModel.actualCity.selectedIndexes,
                        changeToFirst: true,
                        hideHeader: false,
                        cancelText: '取消',
                        confirmText: '确定',
                        cancelTextStyle:
                            TextStyle(fontSize: 14, color: Color(0xFF2F4058)),
                        confirmTextStyle:
                            TextStyle(fontSize: 14, color: Color(0xFFC68D3E)),
                        columnPadding: const EdgeInsets.all(4.0),
                        onConfirm: (picker, value) {
                          final pro = provinces[value.first];
                          final city = pro.cities[value.last].citiesName;
                          final cityId = pro.cities[value.last].id;
                          itModel.actualCity.city = city;
                          itModel.actualCity.cityId = cityId;
                          itModel.actualCity.selectedIndexes = value;
                          if (selectAction != null) selectAction();
                          // print(value.toString());
                          // print(picker.adapter.text);
                        }).showModal(context);
                  }),
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
