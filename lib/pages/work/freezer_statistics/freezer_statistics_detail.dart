import 'package:flutter/material.dart';

///冰柜统计详情
class FreezerStatisticsDetail extends StatefulWidget {
  var data;
  FreezerStatisticsDetail({Key key, this.data}) : super(key: key);

  @override
  _FreezerStatisticsDetailState createState() => _FreezerStatisticsDetailState();
}

class _FreezerStatisticsDetailState extends State<FreezerStatisticsDetail> {

  _setTextColor(status){
    switch(status){
      case 0://维修中
        return Color(0xFFC08A3F);
        break;
      case 1://正常
        return Color(0xFF12BD95);
        break;
      case 2://报废
        return Color(0xFF999999);
        break;
    }
  }

  _setBgColor(status){
    switch(status){
      case 0://维修中
        return Color(0xFFF1EEEA);
        break;
      case 1://正常
        return Color(0xFFE4F2F1);
        break;
      case 2://报废
        return Color(0xFFEEEFF2);
        break;
    }
  }

  _setStatus(status){
    switch(status){
      case 0:
        return '维修中';
        break;
      case 1:
        return '正常';
        break;
      case 2:
        return '报废';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    Image.asset('assets/images/icon_freezer_statistics.png', width: 25, height: 25),
                    SizedBox(width: 10),
                    Text('冰柜编号: ${widget.data['code']}',style: TextStyle(fontSize: 15, color: Color(0XFF2F4058))),
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
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset('assets/images/icon_freezer_brand.png', width: 15, height: 15),
                                      SizedBox(width: 3),
                                      Text('品牌: ',style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                                      SizedBox(width: 3),
                                      Text('${widget.data['brandName']}',style: TextStyle(fontSize: 12, color: Color(0XFF2F4058))),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Image.asset('assets/images/icon_freezer_model.png', width: 15, height: 15),
                                      SizedBox(width: 3),
                                      Text('型号: ',style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                                      SizedBox(width: 3),
                                      Text('${widget.data['modelName']}',style: TextStyle(fontSize: 12, color: Color(0XFF2F4058))),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Image.asset('assets/images/icon_freezer_year.png', width: 15, height: 15),
                                      SizedBox(width: 3),
                                      Text('年份: ',style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                                      SizedBox(width: 3),
                                      Text('${widget.data['birthday']}',style: TextStyle(fontSize: 12, color: Color(0XFF2F4058))),
                                    ],
                                  )
                                ]
                            ),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: _setBgColor(widget.data['status']), borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: Text(_setStatus(widget.data['status']), style: TextStyle(fontSize: 10, color: _setTextColor(widget.data['status']))),
                                  ),
                                  SizedBox(height: 3),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: widget.data['useing'] == '0' ? Color(0xFFEEEFF2) : Color(0XFFFAEEEA), borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: Text(widget.data['useing'] == '0' ? '未开柜' : '已开柜', style: TextStyle(fontSize: 10, color: widget.data['useing'] == 0 ? Color(0xFF999999) : Color(0XFFE45C26))),
                                  )
                                ]
                            )
                          ]
                      )
                  )
              ),
              Container(
                  margin: EdgeInsets.all(20),
                  padding:EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('区域',style: TextStyle(fontSize: 14, color: Color(0XFF959EB1))),
                            Text('${widget.data['deptName']}',style: TextStyle(fontSize: 14, color: Color(0XFF2F4058))),
                          ],
                        ),
                        // SizedBox(height: 15),
                        // SizedBox(
                        //     width: double.infinity,
                        //     height: 1,
                        //     child: DecoratedBox(
                        //       decoration: BoxDecoration(color: Color(0xFFF5F5F8)),
                        //     )
                        // ),
                        // SizedBox(height: 15),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text('城市',style: TextStyle(fontSize: 14, color: Color(0XFF959EB1))),
                        //     Text('${widget.data['province']}',style: TextStyle(fontSize: 14, color: Color(0XFF2F4058))),
                        //   ],
                        // ),
                        // SizedBox(height: 15),
                        // SizedBox(
                        //     width: double.infinity,
                        //     height: 1,
                        //     child: DecoratedBox(
                        //       decoration: BoxDecoration(color: Color(0xFFF5F5F8)),
                        //     )
                        // ),
                        // SizedBox(height: 15),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text('区县',style: TextStyle(fontSize: 14, color: Color(0XFF959EB1))),
                        //     Text('${widget.data['city']}',style: TextStyle(fontSize: 14, color: Color(0XFF2F4058))),
                        //   ],
                        // ),
                        SizedBox(height: 15),
                        SizedBox(
                            width: double.infinity,
                            height: 1,
                            child: DecoratedBox(
                              decoration: BoxDecoration(color: Color(0xFFF5F5F8)),
                            )
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('城市经理',style: TextStyle(fontSize: 14, color: Color(0XFF959EB1))),
                            Text('${widget.data['managerName']}',style: TextStyle(fontSize: 14, color: Color(0XFF2F4058))),
                          ],
                        ),
                        SizedBox(height: 15),
                        SizedBox(
                            width: double.infinity,
                            height: 1,
                            child: DecoratedBox(
                              decoration: BoxDecoration(color: Color(0xFFF5F5F8)),
                            )
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('经理电话',style: TextStyle(fontSize: 14, color: Color(0XFF959EB1))),
                            Text('${widget.data['cityPhone']}',style: TextStyle(fontSize: 14, color: Color(0XFF2F4058))),
                          ]
                        )
                      ]
                  )
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  padding:EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('店铺名称',style: TextStyle(fontSize: 14, color: Color(0XFF959EB1))),
                            Text('${widget.data['shop']}',style: TextStyle(fontSize: 14, color: Color(0XFF2F4058))),
                          ],
                        ),
                        SizedBox(height: 15),
                        SizedBox(
                            width: double.infinity,
                            height: 1,
                            child: DecoratedBox(
                              decoration: BoxDecoration(color: Color(0xFFF5F5F8)),
                            )
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('店主姓名',style: TextStyle(fontSize: 14, color: Color(0XFF959EB1))),
                            Text('${widget.data['shopOwner']}',style: TextStyle(fontSize: 14, color: Color(0XFF2F4058))),
                          ],
                        ),
                        SizedBox(height: 15),
                        SizedBox(
                            width: double.infinity,
                            height: 1,
                            child: DecoratedBox(
                              decoration: BoxDecoration(color: Color(0xFFF5F5F8)),
                            )
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('店主电话',style: TextStyle(fontSize: 14, color: Color(0XFF959EB1))),
                            Text('${widget.data['shopPhone']}',style: TextStyle(fontSize: 14, color: Color(0XFF2F4058))),
                          ],
                        ),
                        SizedBox(height: 15),
                        SizedBox(
                            width: double.infinity,
                            height: 1,
                            child: DecoratedBox(
                              decoration: BoxDecoration(color: Color(0xFFF5F5F8)),
                            )
                        ),
                        SizedBox(height: 15),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('所在地址',style: TextStyle(fontSize: 14, color: Color(0XFF959EB1))),
                            SizedBox(width: 15),
                            Container(
                                width: 200,
                                child: Text('${widget.data['address']}',style: TextStyle(fontSize: 14, color: Color(0XFF2F4058)), maxLines: 2)
                            )
                          ]
                        )
                      ]
                  )
              )
            ]
          )
        )
      )
    );
  }
}
