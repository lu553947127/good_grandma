import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/models/employee_model.dart';
import 'package:good_grandma/widgets/search_text_widget.dart';

///选择人员
class SelectUserPage extends StatefulWidget {
  const SelectUserPage({Key key, @required this.userList}) : super(key: key);
  final List<EmployeeModel> userList;

  @override
  _SelectUserPageState createState() => _SelectUserPageState();
}

class _SelectUserPageState extends State<SelectUserPage> {
  FocusNode _focusNode = FocusNode();
  TextEditingController _editingController = TextEditingController();
  List<EmployeeModel> _employees = [];

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
      appBar: AppBar(title: const Text('选择人员')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Scrollbar(
          child: CustomScrollView(
            slivers: [
              //搜索区域
              SearchTextWidget(
                  editingController: _editingController,
                  focusNode: _focusNode,
                  onSearch: _searchAction),
              //列表
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                EmployeeModel model = _employees[index];
                return Column(
                  children: [
                    ListTile(
                        title: Text(model.name ?? ''),
                        onTap: () => Navigator.pop(context, model)),
                    divider
                  ],
                );
              }, childCount: _employees.length)),
            ],
          ),
        ),
      ),
    );
  }
  _searchAction(String text) {
    if (text.isEmpty) {
      _refresh();
      return;
    }
    List<EmployeeModel> tempList = [];
    tempList.addAll(_employees.where((element) => element.name.contains(text)));
    _employees.clear();
    _employees.addAll(tempList);
    setState(() {});
  }

  Future<void> _refresh()async{
    _employees.clear();
    _employees.addAll(widget.userList);
    if(mounted)
      setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode?.dispose();
    _editingController?.dispose();
  }
}
