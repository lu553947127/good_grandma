import 'package:flutter/material.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';
import 'package:good_grandma/pages/work/customer_visit/customer_visit_edit.dart';
import 'package:good_grandma/widgets/picture_big_view.dart';

///拜访统计详情
class VisitStatisticsDetail extends StatelessWidget {
  final dynamic data;
  VisitStatisticsDetail({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> ipictures = (data['ipictures'] as List).cast();

    _setStatusText(status){
      switch(status){
        case 1:
          return '拜访中';
          break;
        case 2:
          return '已完成';
          break;
      }
    }

    _setTextColor(status){
      switch(status){
        case 1:
          return Color(0xFFE45C26);
          break;
        case 2:
          return Color(0xFF05A8C6);
          break;
      }
    }

    _setBgColor(status){
      switch(status){
        case 1:
          return Color(0xFFFAEEEA);
          break;
        case 2:
          return Color(0xFFE9F5F8);
          break;
      }
    }

    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text("拜访统计详细", style: TextStyle(fontSize: 18, color: Colors.black)),
            actions: [
              Visibility(
                visible: data['status'] == 1,
                child: TextButton(
                    child: Text("编辑", style: TextStyle(fontSize: 14, color: Color(0xFFC08A3F))),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder:(context)=> CustomerVisitEdit(data: data)));
                    }
                )
              )
            ]
        ),
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: EdgeInsets.all(15),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                                children: [
                                  Image.asset('assets/images/icon_visit_statistics.png', width: 25, height: 25),
                                  SizedBox(width: 10),
                                  Container(
                                      width: 220,
                                      child: Text(data['visitContent'], style: TextStyle(fontSize: 15, color: Color(0XFF2F4058))
                                          , overflow: TextOverflow.ellipsis, maxLines: 1)
                                  )
                                ]
                            ),
                            Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: _setBgColor(data['status']), borderRadius: BorderRadius.circular(3),
                                ),
                                child: Text(_setStatusText(data['status']), style: TextStyle(fontSize: 10, color: _setTextColor(data['status'])))
                            )
                          ]
                      )
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
                                            Image.asset('assets/images/icon_visit_statistics_name.png', width: 15, height: 15),
                                            SizedBox(width: 3),
                                            Text('拜访人: ',style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                                            SizedBox(width: 3),
                                            Text(data['userName'], style: TextStyle(fontSize: 12, color: Color(0XFF2F4058))),
                                          ]
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                          children: [
                                            Image.asset('assets/images/icon_visit_statistics_time.png', width: 15, height: 15),
                                            SizedBox(width: 3),
                                            Text('开始时间: ',style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                                            SizedBox(width: 3),
                                            Text(data['createTime'], style: TextStyle(fontSize: 12, color: Color(0XFF2F4058))),
                                          ]
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                          children: [
                                            Image.asset('assets/images/icon_visit_statistics_time.png', width: 15, height: 15),
                                            SizedBox(width: 3),
                                            Text('结束时间: ',style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                                            SizedBox(width: 3),
                                            Text(data['updateTime'], style: TextStyle(fontSize: 12, color: Color(0XFF2F4058))),
                                          ]
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                          children: [
                                            Image.asset('assets/images/icon_visit_statistics_custom.png', width: 15, height: 15),
                                            SizedBox(width: 3),
                                            Text('拜访客户: ',style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                                            SizedBox(width: 3),
                                            Text(data['customerName'], style: TextStyle(fontSize: 12, color: Color(0XFF2F4058))),
                                          ]
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                          children: [
                                            Image.asset('assets/images/icon_visit_statistics_custom.png', width: 15, height: 15),
                                            SizedBox(width: 3),
                                            Text('客户类型: ',style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                                            SizedBox(width: 3),
                                            Text(data['customerTypeName'], style: TextStyle(fontSize: 12, color: Color(0XFF2F4058))),
                                          ]
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Image.asset('assets/images/icon_visit_statistics_address.png', width: 15, height: 15),
                                            SizedBox(width: 3),
                                            Text('客户地址: ',style: TextStyle(fontSize: 12, color: Color(0XFF959EB1))),
                                            SizedBox(width: 3),
                                            Container(
                                                width: 200,
                                                child: Text(data['address'], style: TextStyle(fontSize: 12, color: Color(0XFF2F4058)), maxLines: 2)
                                            )
                                          ]
                                      )
                                    ]
                                )
                              ]
                          )
                      )
                  ),
                  Container(
                      margin: EdgeInsets.all(10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("拜访内容", style: TextStyle(fontSize: 14, color: Color(0XFF959EB1))),
                            SizedBox(height: 10),
                            Text(data['visitContent'],
                                style: TextStyle(fontSize: 14, color: Color(0XFF2F4058)))
                          ]
                      )
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("拜访图片", style: TextStyle(fontSize: 14, color: Color(0XFF959EB1))),),
                  SizedBox(height: 10),
                  Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: GridView.builder(
                          shrinkWrap: true,//为true可以解决子控件必须设置高度的问题
                          physics:NeverScrollableScrollPhysics(),//禁用滑动事件
                          padding: const EdgeInsets.all(0),
                          itemCount: ipictures.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8
                          ),
                          itemBuilder: (BuildContext content, int index){
                            return InkWell(
                                child: MyCacheImageView(
                                  imageURL: ipictures[index],
                                  width: 192,
                                  height: 108,
                                  errorWidgetChild: Image.asset('assets/images/icon_empty_user.png', width: 192.0, height: 108.0),
                                ),
                                onTap: (){
                                  Navigator.of(context).push(FadeRoute(page: PhotoViewGalleryScreen(
                                    images: ipictures,//传入图片list
                                    index: index,//传入当前点击的图片的index
                                    heroTag: 'simple',//传入当前点击的图片的hero tag （可选）
                                  )));
                                }
                            );
                          }
                      )
                  )
                ]
            )
        )
    );
  }
}
