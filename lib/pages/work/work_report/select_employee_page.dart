import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/models/employee_model.dart';
import 'package:good_grandma/widgets/search_text_widget.dart';
import 'package:good_grandma/widgets/submit_btn.dart';

///选择员工
class SelectEmployeePage extends StatefulWidget {
  const SelectEmployeePage({Key key, @required this.selEmployees}) : super(key: key);
  final List<EmployeeModel> selEmployees;

  @override
  _SelectEmployeePageState createState() => _SelectEmployeePageState();
}

class _SelectEmployeePageState extends State<SelectEmployeePage> {
  FocusNode _focusNode = FocusNode();
  TextEditingController _editingController = TextEditingController();
  List<EmployeeModel> _employees = [];
  bool _selectedAll = true;
  String keyword = '';

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final Divider divider = const Divider(
        color: AppColors.FFC1C8D7,
        thickness: 1,
        height: 1,
        indent: 15,
        endIndent: 15.0);
    return Scaffold(
      appBar: AppBar(title: Text('选择员工')),
      body: Column(
        children: [
          //搜索区域
          SearchTextWidget(
              editingController: _editingController,
              focusNode: _focusNode,
              onSearch: _searchAction,
              onChanged: (text){
                _searchAction(text);
              }
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: Scrollbar(
                child: CustomScrollView(
                  slivers: [
                    //所有人
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(_selectedAll
                                ? Icons.check_box
                                : Icons.check_box_outline_blank),
                            title: Text('所有人'),
                            onTap: () {
                              _selectedAllBtnOnTap(context);
                            },
                          ),
                          divider
                        ],
                      ),
                    ),
                    //列表
                    SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          EmployeeModel model = _employees[index];
                          return Column(
                            children: [
                              ListTile(
                                leading: Icon(model.isSelected
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank),
                                title: Text(model.name ?? ''),
                                onTap: () {
                                  setState(() {
                                    model.isSelected = !model.isSelected;
                                    if (!model.isSelected && _selectedAll)
                                      _selectedAll = false;
                                  });
                                },
                              ),
                              divider
                            ],
                          );
                        }, childCount: _employees.length)),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: SubmitBtn(
            title: '确定',
            onPressed: () {
              List<EmployeeModel> _selList =
                  _employees.where((employee) => employee.isSelected).toList();
              if (_selList.isEmpty) {
                EasyLoading.showToast('至少选择一个员工');
                return;
              }
              Navigator.pop(context, _selList);
            }),
      ),
    );
  }

  _searchAction(String text) {
    if (Platform.isAndroid){
      if (text.isEmpty) {
        _refresh();
        return;
      }
      List<EmployeeModel> tempList = [];
      tempList.addAll(_employees.where((element) => element.name.contains(text)));
      _employees.clear();
      _employees.addAll(tempList);
      setState(() {});
    }else {
      if (text.isEmpty) {
        keyword = '';
        _refresh();
        return;
      }
      keyword = text;
      _refresh();
    }
  }

  Future<void> _refresh() async {
    try{
      Map<String, dynamic> map = {'name': keyword};
      final val = await requestPost(Api.reportUserList, json: jsonEncode(map));
      // LogUtil.d('reportUserList value = $val');
      var data = jsonDecode(val.toString());
      _employees.clear();
      final List<dynamic> list = data['data'];
      list.forEach((map) {
        Map re = map as Map;
        EmployeeModel model = EmployeeModel(
            name: re['name']??'',
            id: re['id']??'',
            isSelected: _selectedAll);
        _employees.add(model);
      });
      if(widget.selEmployees.isNotEmpty){
        _selectedAll = false;
        _employees.forEach((employee) {
          employee.isSelected = false;
          widget.selEmployees.forEach((selEmployee) {
            if(selEmployee.id == employee.id)
              employee.isSelected = true;
          });
        });
      }
      if (mounted) setState(() {});
    }catch(error){

    }
  }

  void _selectedAllBtnOnTap(BuildContext context) {
    _selectedAll = !_selectedAll;
    if (_selectedAll) {
      _employees.forEach((employee) {
        employee.isSelected = true;
      });
    } else {
      _employees.forEach((employee) {
        employee.isSelected = false;
      });
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode?.dispose();
    _editingController?.dispose();
  }
}
