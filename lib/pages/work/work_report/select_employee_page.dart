import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:good_grandma/common/colors.dart';
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
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Scrollbar(
          child: CustomScrollView(
            slivers: [
              //搜索区域
              _SearchTextWidget(
                  editingController: _editingController,
                  focusNode: _focusNode,
                  onSearch: (text) {}),
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
      bottomNavigationBar: SafeArea(
        child: SubmitBtn(
            title: '确定',
            onPressed: () {
              List<EmployeeModel> _selList =
                  _employees.where((employee) => employee.isSelected).toList();
              if (_selList.isEmpty) {
                Fluttertoast.showToast(msg: '至少选择一个员工',gravity: ToastGravity.CENTER);
                return;
              }
              Navigator.pop(context, _employees);
            }),
      ),
    );
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    _employees.clear();
    for (int i = 0; i < 15; i++) {
      _employees.add(EmployeeModel(
          name: '张${i + 1}', id: '${i + 1}', isSelected: _selectedAll));
    }
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
    setState(() {});
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

class EmployeeModel {
  final String name;
  final String id;
  bool isSelected;

  EmployeeModel({
    this.name = '',
    this.id = '',
    this.isSelected = false,
  });
}

///搜索框
class _SearchTextWidget extends StatelessWidget {
  const _SearchTextWidget({
    Key key,
    @required TextEditingController editingController,
    @required FocusNode focusNode,
    this.onSearch,
  })  : _editingController = editingController,
        _focusNode = focusNode,
        super(key: key);

  final TextEditingController _editingController;
  final FocusNode _focusNode;
  final Function(String text) onSearch;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            offset: Offset(0, 1),
            blurRadius: 5,
          )
        ]),
        child: Container(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          decoration: BoxDecoration(
              color: AppColors.FFEFEFF4,
              borderRadius: BorderRadius.circular(30 / 2)),
          child: TextField(
            controller: _editingController,
            focusNode: _focusNode,
            maxLines: 1,
            selectionHeightStyle: BoxHeightStyle.max,
            textInputAction: TextInputAction.search,
            onSubmitted: onSearch,
            decoration: InputDecoration(
              icon: Icon(Icons.search, size: 20, color: AppColors.FFC1C8D7),
              contentPadding: const EdgeInsets.only(),
              hintText: '请输入员工姓名',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30 / 2),
                borderSide: BorderSide.none,
              ),
              hintStyle:
                  const TextStyle(color: AppColors.FFC1C8D7, fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }
}
