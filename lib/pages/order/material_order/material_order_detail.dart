import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/order/material_order/material_order_add.dart';
import 'package:good_grandma/pages/order/material_order/material_order_model.dart';
import 'package:good_grandma/widgets/marketing_activity_msg_cell.dart';
import 'package:good_grandma/widgets/post_detail_group_title.dart';
import 'package:good_grandma/widgets/submit_btn.dart';
import 'package:provider/provider.dart';

///物料订单详情
class MaterialOrderDetail extends StatefulWidget {
  final dynamic data;
  const MaterialOrderDetail({Key key, this.data}) : super(key: key);

  @override
  _MaterialOrderDetailState createState() => _MaterialOrderDetailState();
}

class _MaterialOrderDetailState extends State<MaterialOrderDetail> {
  @override
  Widget build(BuildContext context) {

    List<Map> materialDetailsList = (widget.data['materialDetailsVOS'] as List).cast();

    List<Map> _list1 = [
      {'title': '总价', 'value': widget.data['totalPrice']},
      {'title': '是否随货', 'value': widget.data['withGoods'] == 1 ? '是' : '否'},
      {'title': '经销商名称', 'value': widget.data['customerName']},
      {'title': '物料地址', 'value': widget.data['address']}
    ];

    _setTextStatus(status){
      switch(status){
        case 1:
          return '未审核';
          break;
        case 2:
          return '审核通过';
          break;
        case 3:
          return '已入库';
          break;
        case 4:
          return '驳回';
          break;
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text('物料订单详情')),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0)),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(2, 1), //x,y轴
                        color: Colors.black.withOpacity(0.1), //投影颜色
                        blurRadius: 1 //投影距离
                    )
                  ]
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.data['deptName'],style: TextStyle(fontSize: 14, color: Color(0XFFE45C26))),
                          SizedBox(height: 3),
                          Text(widget.data['createTime'],style: TextStyle(fontSize: 12, color: Color(0XFF959EB1)))
                        ]
                    ),
                    Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Color(0xFFF1E1E2), borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(_setTextStatus(widget.data['status']),
                            style: TextStyle(fontSize: 10, color: Color(0xFFDD0000)))
                    )
                  ]
              )
            )
          ),
          PostDetailGroupTitle(color: AppColors.FFC08A3F, name: '物料'),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Container(
                  margin: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        MarketingActivityMsgCell(title: '物料', value: materialDetailsList[index]['materialName']),
                        MarketingActivityMsgCell(title: '数量', value: materialDetailsList[index]['quantity'].toString()),
                        MarketingActivityMsgCell(title: '单价', value: materialDetailsList[index]['unitPrice'].toString())
                      ]
                  )
              );
            }, childCount: materialDetailsList.length),
          ),
          SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  Map map = _list1[index];
                  String title = map['title'];
                  String value = map['value'];
                  return MarketingActivityMsgCell(title: title, value: value);
                }, childCount: _list1.length),
              )
          ),
          SliverSafeArea(
              sliver: SliverToBoxAdapter(
                  child: Visibility(
                    visible: widget.data['status'] == 2 ? true : false,
                    child: SubmitBtn(
                        title: '入库',
                        onPressed: () {
                          _submitWarehousing(context);
                        }
                    )
                  )
              )
          ),
          SliverSafeArea(
              sliver: SliverToBoxAdapter(
                  child: Visibility(
                    visible: widget.data['status'] == 4 ? true : false,
                    child: SubmitBtn(
                        title: '驳回',
                        onPressed: () async {
                          MarketingOrderModel model = MarketingOrderModel();
                          bool needRefresh = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                  ChangeNotifierProvider<MarketingOrderModel>.value(
                                    value: model,
                                    child: MaterialOrderAddPage(id: widget.data['id'], data: widget.data, newKey: ''),
                                  )));
                          if(needRefresh != null && needRefresh){
                            Navigator.pop(context, true);
                          }
                        }
                    )
                  )
              )
          )
        ]
      )
    );
  }

  ///入库
  void _submitWarehousing(BuildContext context) async {

    Map<String, dynamic> map = {
      'id': widget.data['id']
    };

    LogUtil.d('请求结果---materialOrderAdd----$map');

    requestPost(Api.materialOrderWarehousing, formData: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---materialOrderWarehousing----$data');
      if (data['code'] == 200){
        showToast("成功");
        Navigator.pop(context, true);
      }else {
        showToast(data['msg']);
      }
    });
  }
}
