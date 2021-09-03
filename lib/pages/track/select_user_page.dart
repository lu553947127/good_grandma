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
      body: Scrollbar(
        child: CustomScrollView(
          slivers: [
            //搜索区域
            SearchTextWidget(
                editingController: _editingController,
                focusNode: _focusNode,
                onSearch: (text) {}),
            //列表
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              EmployeeModel model = widget.userList[index];
              return Column(
                children: [
                  ListTile(
                      title: Text(model.name ?? ''),
                      onTap: () => Navigator.pop(context, model)),
                  divider
                ],
              );
            }, childCount: widget.userList.length)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode?.dispose();
    _editingController?.dispose();
  }
}