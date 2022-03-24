import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/pages/mine/receiving_address_add.dart';

///收货地址
class ReceivingAddress extends StatefulWidget {
  final String userId;
  const ReceivingAddress({Key key, this.userId}) : super(key: key);

  @override
  _ReceivingAddressState createState() => _ReceivingAddressState();
}

class _ReceivingAddressState extends State<ReceivingAddress> {

  List<dynamic> findCustomerAddressList = [];

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
    Map<String, dynamic> map = {'userId': widget.userId};
    final val = await requestPost(Api.findCustomerAddress, formData: map);
    var data = jsonDecode(val.toString());
    LogUtil.d('请求结果---findCustomerAddress----$data');
    findCustomerAddressList.clear();
    findCustomerAddressList = data['data'];
    if (mounted) setState(() {});
  }
}
