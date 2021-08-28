import 'package:flutter/material.dart';

///冰柜销量详情
class FreezerSalesDetail extends StatefulWidget {
  var data;
  FreezerSalesDetail({Key key, this.data}) : super(key: key);

  @override
  _FreezerSalesDetailState createState() => _FreezerSalesDetailState();
}

class _FreezerSalesDetailState extends State<FreezerSalesDetail> {
  @override
  Widget build(BuildContext context) {

    List<Map> list = [
      {'title' : '商品名称1', 'num1': '100','num2' : '10', 'num3' : '90','number' : '450.00'},
      {'title' : '商品名称1', 'num1': '100','num2' : '10', 'num3' : '90','number' : '450.00'},
      {'title' : '商品名称1', 'num1': '100','num2' : '10', 'num3' : '90','number' : '450.00'},
      {'title' : '商品名称1', 'num1': '100','num2' : '10', 'num3' : '90','number' : '450.00'},
      {'title' : '商品名称1', 'num1': '100','num2' : '10', 'num3' : '90','number' : '450.00'},
      {'title' : '商品名称1', 'num1': '100','num2' : '10', 'num3' : '90','number' : '450.00'},
      {'title' : '商品名称1', 'num1': '100','num2' : '10', 'num3' : '90','number' : '450.00'},
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("冰柜详细",style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Image.asset('assets/images/icon_freezer_sales.png', width: 25, height: 25),
                    SizedBox(width: 10),
                    Text(widget.data['title'],style: TextStyle(fontSize: 15, color: Color(0XFF2F4058))),
                  ],
                ),
              ),
              Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0)),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(2, 1), //x,y轴
                            color: Colors.black.withOpacity(0.1), //投影颜色
                            blurRadius: 1 //投影距离
                        )
                      ]),
                  child: Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                          children: [
                            Row(
                              children: [
                                Image.asset('assets/images/icon_freezer_area.png', width: 15, height: 15),
                                SizedBox(width: 3),
                                Text('所属区域: ',style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                                SizedBox(width: 3),
                                Text('大区名称 - 山东省 - 济南市',style: TextStyle(fontSize: 12, color: Color(0XFF2F4058))),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Image.asset('assets/images/icon_freezer_name.png', width: 15, height: 15),
                                SizedBox(width: 3),
                                Text('客户名称: ',style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                                SizedBox(width: 3),
                                Text('高速石化济阳服务区',style: TextStyle(fontSize: 12, color: Color(0XFF2F4058))),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Image.asset('assets/images/icon_freezer_phone.png', width: 15, height: 15),
                                SizedBox(width: 3),
                                Text('客户电话: ',style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                                SizedBox(width: 3),
                                Text('18888888888',style: TextStyle(fontSize: 12, color: Color(0XFF2F4058))),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                                children: [
                                  Image.asset('assets/images/icon_freezer_address.png', width: 15, height: 15),
                                  SizedBox(width: 3),
                                  Text('客户地址: ',style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                                  SizedBox(width: 3),
                                  Text('济阳高速服务区',style: TextStyle(fontSize: 12, color: Color(0XFF2F4058))),
                                ]
                            ),
                            SizedBox(height: 15),
                            SizedBox(
                              width: double.infinity,
                              height: 0.5,
                              child: DecoratedBox(
                                decoration: BoxDecoration(color: Color(0xFFC1C8D7)),
                              ),
                            ),
                            SizedBox(height: 15),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text('总销量(箱): ',style: TextStyle(fontSize: 12, color: Color(0XFF2F4058))),
                                      SizedBox(width: 3),
                                      Text('1321',style: TextStyle(fontSize: 14, color: Color(0XFFE45C26))),
                                    ],
                                  ),
                                  Row(
                                      children: [
                                        Text('总销售金额(元): ',style: TextStyle(fontSize: 12, color: Color(0XFF2F4058))),
                                        SizedBox(width: 3),
                                        Text('¥1321',style: TextStyle(fontSize: 14, color: Color(0XFFE45C26))),
                                      ]
                                  )
                                ]
                            )
                          ]
                      )
                  )
              ),
              ListView.builder(
                shrinkWrap:true,//范围内进行包裹（内容多高ListView就多高）
                physics:NeverScrollableScrollPhysics(),//禁止滚动
                itemCount: list.length,
                itemBuilder: (content, index){
                  return Container(
                      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${list[index]['title']}',style: TextStyle(fontSize: 14,color: Color(0XFF2F4058))),
                          SizedBox(height: 10),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text('${list[index]['num1']}',style: TextStyle(fontSize: 14,color: Color(0XFF2F4058))),
                                    SizedBox(height: 5),
                                    Text('进货数量(箱)',style: TextStyle(fontSize: 11,color: Color(0XFF959EB1))),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text('${list[index]['num2']}',style: TextStyle(fontSize: 14,color: Color(0XFF2F4058))),
                                    SizedBox(height: 5),
                                    Text('奖励数量(箱)',style: TextStyle(fontSize: 11,color: Color(0XFF959EB1))),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text('${list[index]['num3']}',style: TextStyle(fontSize: 14,color: Color(0XFF2F4058))),
                                    SizedBox(height: 5),
                                    Text('销售数量(箱)',style: TextStyle(fontSize: 11,color: Color(0XFF959EB1))),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text('¥${list[index]['number']}',style: TextStyle(fontSize: 14,color: Color(0XFFE45C26))),
                                    SizedBox(height: 5),
                                    Text('销售金额(元)',style: TextStyle(fontSize: 11,color: Color(0XFF959EB1))),
                                  ],
                                )
                              ]
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            height: 0.5,
                            child: DecoratedBox(
                              decoration: BoxDecoration(color: Color(0xFFC1C8D7)),
                            ),
                          )
                        ],
                      )
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
