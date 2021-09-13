import 'package:flutter/material.dart';
import 'package:good_grandma/pages/work/freezer_sales/freezer_sales_detail.dart';

///冰柜销量列表
class FreezerSalesList extends StatelessWidget {
  var data;
  FreezerSalesList({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              offset: Offset(2, 1),
              blurRadius: 1.5,
            )
          ]
      ),
      child: InkWell(
        child: Column(
          mainAxisSize:MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Image.asset('assets/images/icon_freezer_sales.png', width: 25, height: 25),
                  SizedBox(width: 10),
                  Text('冰柜编号: ${data['code']}',style: TextStyle(fontSize: 15, color: Color(0XFF2F4058))),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              padding: EdgeInsets.only(left: 10.0),
              height: 40,
              color: Color(0XFFEFEFF4),
              child: Text('${data['region'] + data['province'] + data['city']}',style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
            ),
            //标题头部
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 230,
                    child: Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('客户名称: ${data['shop']}', style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                        SizedBox(height: 3),
                        Text('客户地址: ${data['address']}', style: TextStyle(fontSize: 12, color: Color(0XFF959EB1)))
                      ]
                    ))
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Color(0XFFFAEEEA), borderRadius: BorderRadius.circular(3),
                    ),
                    child: Column(
                      children: [
                        Text('${data['sales']}', style: TextStyle(fontSize: 15, color: Color(0XFFE45C26))),
                        Text('销量', style: TextStyle(fontSize: 10, color: Color(0XFFE45C26))),
                      ],
                    ),
                  )
                ],
              )
            )
          ],
        ),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder:(context)=> FreezerSalesDetail(
            data: data,
          )));
        },
      ),
    );
  }
}
