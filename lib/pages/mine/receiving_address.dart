import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/StoreModel.dart';
import 'package:good_grandma/pages/declaration_form/select_store_page.dart';
import 'package:good_grandma/pages/mine/receiving_address_add.dart';
import 'package:good_grandma/widgets/post_add_input_cell.dart';

///收货地址
class ReceivingAddress extends StatefulWidget {
  final String userId;
  final int orderType;
  const ReceivingAddress({Key key, this.userId, this.orderType}) : super(key: key);

  @override
  _ReceivingAddressState createState() => _ReceivingAddressState();
}

class _ReceivingAddressState extends State<ReceivingAddress> {

  List<dynamic> findCustomerAddressList = [];
  String userId = '';
  String userName = '';

  @override
  void initState() {
    super.initState();
    _findCustomerAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('收货地址'),
            actions: [
              TextButton(
                  child: Text("添加", style: TextStyle(fontSize: 14, color: Color(0xFFC08A3F))),
                  onPressed: () async {
                    if (widget.userId.isEmpty && userId.isEmpty){
                      showToast('请先选择客户，再添加');
                      return;
                    }
                    bool needRefresh = await Navigator.push(context,
                        MaterialPageRoute(builder:(context)=> ReceivingAddressAdd(userId: widget.userId, data: null)));
                    if(needRefresh != null && needRefresh){
                      _findCustomerAddress();
                    }
                  }
              )
            ]
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
                child: Visibility(
                  visible: widget.userId.isEmpty,
                  child: PostAddInputCell(
                      title: '客户',
                      value: userName,
                      hintText: '请选择客户',
                      endWidget: Icon(Icons.chevron_right),
                      onTap: () async {
                        StoreModel result = await Navigator.push(context,
                            MaterialPageRoute(builder: (_) => SelectStorePage(forOrder: true, orderType: widget.orderType)));
                        userId = result.id;
                        userName = result.name;
                        _findCustomerAddress();
                      }
                  )
                )
            ),
            findCustomerAddressList.length != 0 ?
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  Map model = findCustomerAddressList[index];
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                            title: Text('地址：${model['address']}'),
                            subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('联系人：${model['linkMain']}'),
                                  Text('联系电话：${model['phone']}')
                                ]
                            ),
                            trailing: IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () async {
                                  bool needRefresh = await Navigator.push(context,
                                      MaterialPageRoute(builder:(context)=> ReceivingAddressAdd(userId: widget.userId, data: model)));
                                  if(needRefresh != null && needRefresh){
                                    _findCustomerAddress();
                                  }
                                }
                            ),
                            onTap: () {
                              Navigator.pop(context, model);
                            }
                        ),
                        const Divider(thickness: 1, height: 1),
                      ]
                  );
                }, childCount: findCustomerAddressList.length)):
            SliverToBoxAdapter(
              child: Center(
                child: GestureDetector(
                  onTap: () async {
                    if (widget.userId.isEmpty && userId.isEmpty){
                      showToast('请先选择客户，再添加');
                      return;
                    }
                    bool needRefresh = await Navigator.push(context,
                        MaterialPageRoute(builder:(context)=> ReceivingAddressAdd(userId: widget.userId, data: null)));
                    if(needRefresh != null && needRefresh){
                      _findCustomerAddress();
                    }
                  },
                  child: Container(
                      margin: EdgeInsets.all(40),
                      child: Column(
                        children: [
                          Image.asset('assets/images/icon_empty_images.png', width: 150, height: 150),
                          SizedBox(height: 10),
                          Text('还没有添加收货地址，请点击添加')
                        ]
                      )
                  )
                )
              )
            )
          ]
        )
    );
  }

  ///收货地址列表
  Future<void> _findCustomerAddress() async {
    Map<String, dynamic> map = {'userId': widget.userId.isEmpty ? userId : widget.userId};
    final val = await requestPost(Api.findCustomerAddress, formData: map);
    var data = jsonDecode(val.toString());
    LogUtil.d('请求结果---findCustomerAddress----$data');
    findCustomerAddressList.clear();
    findCustomerAddressList = data['data'];
    if (mounted) setState(() {});
  }
}
