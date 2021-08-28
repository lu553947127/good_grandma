import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:good_grandma/common/colors.dart';
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
              SearchTextWidget(
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
              Navigator.pop(context, _selList);
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
