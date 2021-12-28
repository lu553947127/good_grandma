import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/widgets/submit_btn.dart';

///选择客户
class SelectCustomerPage extends StatefulWidget {
  const SelectCustomerPage({Key key, @required this.selCustomers})
      : super(key: key);
  final List<CustomerModel> selCustomers;

  @override
  _SelectCustomerPageState createState() => _SelectCustomerPageState();
}

class _SelectCustomerPageState extends State<SelectCustomerPage> {
  FocusNode _focusNode = FocusNode();
  TextEditingController _editingController = TextEditingController();
  List<CustomerModel> _customers = [];
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
      appBar: AppBar(title: Text('选择客户')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Scrollbar(
          child: CustomScrollView(
            slivers: [
              //搜索区域
              // SearchTextWidget(
              //     editingController: _editingController,
              //     focusNode: _focusNode,
              //     hintText: '请输入客户名称',
              //     onSearch: (text) {}),
              //所有人
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    ListTile(
                      leading: _selectedAll
                          ? Icon(Icons.check_box, color: AppColors.FFC68D3E)
                          : Icon(Icons.check_box_outline_blank),
                      title: Text('所有客户'),
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
                CustomerModel model = _customers[index];
                return Column(
                  children: [
                    ListTile(
                      leading: model.isSelected
                          ? Icon(Icons.check_box, color: AppColors.FFC68D3E)
                          : Icon(Icons.check_box_outline_blank),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(model.name ?? ''),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                Image.asset('assets/images/ic_login_phone.png',
                                    width: 12, height: 12),
                                Expanded(
                                    child: Text(model.phone,
                                        style: const TextStyle(
                                            color: AppColors.FF959EB1,
                                            fontSize: 12)))
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Image.asset('assets/images/sign_in_local2.png',
                                  width: 12, height: 12),
                              Expanded(
                                  child: Text(model.address,
                                      style: const TextStyle(
                                          color: AppColors.FF959EB1,
                                          fontSize: 12)))
                            ],
                          ),
                        ],
                      ),
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
              }, childCount: _customers.length)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: SubmitBtn(
            title: '确定',
            onPressed: () {
              List<CustomerModel> _selList =
                  _customers.where((employee) => employee.isSelected).toList();
              if (_selList.isEmpty) {
                EasyLoading.showToast('至少选择一个员工');
                return;
              }
              Navigator.pop(context, _selList);
            }),
      ),
    );
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    _customers.clear();
    for (int i = 0; i < 15; i++) {
      _customers.add(CustomerModel(
          name: '张${i + 1}',
          id: '${i + 1}',
          isSelected: _selectedAll,
          phone: '12344445555',
          address: 'sadkfhaksjhfklas'));
    }
    if (widget.selCustomers.isNotEmpty) {
      _selectedAll = false;
      _customers.forEach((employee) {
        employee.isSelected = false;
        widget.selCustomers.forEach((selEmployee) {
          if (selEmployee.id == employee.id) employee.isSelected = true;
        });
      });
    }
    setState(() {});
  }

  void _selectedAllBtnOnTap(BuildContext context) {
    _selectedAll = !_selectedAll;
    if (_selectedAll) {
      _customers.forEach((employee) {
        employee.isSelected = true;
      });
    } else {
      _customers.forEach((employee) {
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

class CustomerModel {
  String name;
  String phone;
  String address;
  String id;
  bool isSelected;
  CustomerModel({
    this.name = '',
    this.phone = '',
    this.address = '',
    this.id = '',
    this.isSelected = false,
  });
}
