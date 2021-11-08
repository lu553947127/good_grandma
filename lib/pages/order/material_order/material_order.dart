import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';

///物料订单页面
class MaterialOrderPage extends StatefulWidget {
  const MaterialOrderPage({Key key}) : super(key: key);

  @override
  _MaterialOrderPageState createState() => _MaterialOrderPageState();
}

class _MaterialOrderPageState extends State<MaterialOrderPage> {

  List<Map> materialList = [
    {
      "areaName":"地区",
      "time":"2020-05-29 16:00:00",
      "custName":"经销商名称",
      "address":"济南市高新区舜泰广场",
      "isMater":"是",
    },
    {
      "areaName":"地区",
      "time":"2020-05-29 16:00:00",
      "custName":"经销商名称",
      "address":"济南市高新区舜泰广场",
      "isMater":"是",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text("物料订单", style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700))
        ),
        body: ListView.builder(
            itemCount: materialList.length,
            itemBuilder: (context, index){
              return Container(
                  margin: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                  padding: const EdgeInsets.all(5.0),
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
                  child: ListTile(
                      title: Column(
                          mainAxisSize:MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //标题头部
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(materialList[index]['areaName'], style: TextStyle(fontSize: 14, color: Color(0XFF2F4058))),
                                        SizedBox(height: 10),
                                        Text(materialList[index]['time'], style: TextStyle(fontSize: 12, color: Color(0XFF959EB1)))
                                      ]
                                  ),
                                  Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Color(0XFF2F4058), borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: Text('状态', style: TextStyle(fontSize: 10, color: Color(0XFF959EB1)))
                                  )
                                ]
                            ),
                            SizedBox(height: 10),
                            //分割线
                            SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 1,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(color: Color(0xFFEFEFF4)),
                                )
                            ),
                            SizedBox(height: 5),
                            Container(
                                margin: EdgeInsets.only(top: 2),
                                child: Row(
                                    children: [
                                      Text('经销商名称: ',style: TextStyle(fontSize: 12,color: Color(0XFF959EB1))),
                                      SizedBox(width: 10),
                                      Text(materialList[index]['custName'], style: TextStyle(fontSize: 12,color: Color(0XFF2F4058)))
                                    ]
                                )
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 2),
                                child: Row(
                                    children: [
                                      Text('物料地址: ',style: TextStyle(fontSize: 12,color: Color(0XFF959EB1))),
                                      SizedBox(width: 10),
                                      Text(materialList[index]['address'], style: TextStyle(fontSize: 12,color: Color(0XFF2F4058)))
                                    ]
                                )
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 2),
                                child: Row(
                                    children: [
                                      Text('是否随货: ',style: TextStyle(fontSize: 12,color: Color(0XFF959EB1))),
                                      SizedBox(width: 10),
                                      Text(materialList[index]['isMater'], style: TextStyle(fontSize: 12,color: Color(0XFF2F4058)))
                                    ]
                                )
                            )
                          ]
                      ),
                      onTap: () {

                      }
                  )
              );
            }
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: AppColors.FFC68D3E,
            onPressed: (){

            }
        )
    );
  }
}
