import 'package:flutter/material.dart';
import 'package:good_grandma/models/employee_model.dart';
import 'package:good_grandma/widgets/search_text_widget.dart';

///选择人员
class SelectCityManagerPage extends StatefulWidget {
  const SelectCityManagerPage({Key key}) : super(key: key);

  @override
  _SelectCityManagerPageState createState() => _SelectCityManagerPageState();
}

class _SelectCityManagerPageState extends State<SelectCityManagerPage> {
  FocusNode _focusNode = FocusNode();
  TextEditingController _editingController = TextEditingController();
  List<EmployeeModel> _dataArray = [];
  @override
  void initState() {
    super.initState();
    _refresh();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('选择人员')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Scrollbar(
          child: CustomScrollView(
            slivers: [
              //搜索区域
              SearchTextWidget(
                  hintText: '请输入城市经理姓名',
                  editingController: _editingController,
                  focusNode: _focusNode,
                  onSearch: (text) {}),
              //列表
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    EmployeeModel model = _dataArray[index];
                    return Column(
                      children: [
                        ListTile(
                          title: Text(model.name),
                          onTap: () => Navigator.pop(context,model),
                        ),
                        const Divider(thickness: 1,height: 1,),
                      ],
                    );
                  }, childCount: _dataArray.length)),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    _dataArray.clear();
    _dataArray.addAll(List.generate(5, (index) => EmployeeModel(name: '张$index',id: '$index')));
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode?.dispose();
    _editingController?.dispose();
  }
}
