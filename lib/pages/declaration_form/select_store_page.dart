import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/models/StoreModel.dart';
import 'package:good_grandma/widgets/search_text_widget.dart';

///选择商户
class SelectStorePage extends StatefulWidget {
  const SelectStorePage({
    Key key,
  }) : super(key: key);

  @override
  _SelectStorePageState createState() => _SelectStorePageState();
}

class _SelectStorePageState extends State<SelectStorePage> {
  FocusNode _focusNode = FocusNode();
  TextEditingController _editingController = TextEditingController();
  List<StoreModel> _stores = [];

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
      appBar: AppBar(title: Text('选择商户')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Scrollbar(
          child: CustomScrollView(
            slivers: [
              //搜索区域
              SearchTextWidget(
                  editingController: _editingController,
                  focusNode: _focusNode,
                  hintText: '请输入商户名称',
                  onSearch: (text) {}),
              //列表
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                StoreModel model = _stores[index];
                return Column(
                  children: [
                    ListTile(
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
                                    child: Text(' ' + model.phone,
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
                                  child: Text(' ' + model.address,
                                      style: const TextStyle(
                                          color: AppColors.FF959EB1,
                                          fontSize: 12)))
                            ],
                          ),
                        ],
                      ),
                      onTap: () => Navigator.pop(context, model),
                    ),
                    divider
                  ],
                );
              }, childCount: _stores.length)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    _stores.clear();
    _stores.addAll(List.generate(
        15,
        (index) => StoreModel(
            name: '商户商户商户商户商户${index + 1}',
            id: '${index + 1}',
            phone: '12344445555',
            address: 'sadkfhaksjhfklas')));
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode?.dispose();
    _editingController?.dispose();
  }
}
