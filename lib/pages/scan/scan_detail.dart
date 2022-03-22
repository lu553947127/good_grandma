import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';
import 'package:good_grandma/widgets/picture_big_view.dart';
import 'package:good_grandma/widgets/post_add_input_cell.dart';

///扫描二维码详情
class ScanDetail extends StatefulWidget {
  final dynamic data;
  const ScanDetail({Key key, this.data}) : super(key: key);

  @override
  _ScanDetailState createState() => _ScanDetailState();
}

class _ScanDetailState extends State<ScanDetail> {
  @override
  Widget build(BuildContext context) {

    List<Map> _list = [
      {'title': '冰柜编码', 'value': widget.data['code']},
      {'title': '所属客户', 'value': widget.data['dealerName']},
      {'title': '是否专柜', 'value': widget.data['exclusive'] ? '是' : '否'},
      {'title': '冰柜品牌', 'value': widget.data['brandName']},
      {'title': '冰柜型号', 'value': widget.data['modelName']},
      {'title': '冰柜年份', 'value': widget.data['birthday']},
      {'title': '店铺名称', 'value': widget.data['shop']},
      {'title': '店主姓名', 'value': widget.data['shopOwner']},
      {'title': '店主电话', 'value': widget.data['shopPhone']},
      {'title': '店铺地址', 'value': widget.data['address']},
      {'title': '是否投放', 'value': widget.data['useing'] == '1' ? '是' : '否'},
    ];

    List<Map> _list2 = [
      {'title': '门头照', 'value': widget.data['shopImgsArr']},
      {'title': '冰柜整体照片', 'value': widget.data['workImgsArr']},
      {'title': '冰柜陈列照片', 'value': widget.data['freezerImgsArr']}
    ];

    return Scaffold(
      appBar: AppBar(title: Text('扫描结果详情')),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              Map map = _list[index];
              return PostAddInputCell(
                  title: map['title'],
                  value: map['value'],
                  hintText: map['value'],
                  endWidget: null,
                  onTap: null
              );}, childCount:_list.length)),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                Map map = _list2[index];
                List<String> imageList = (map['value'] as List).cast();
                return Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(map['title'], style: TextStyle(fontSize: 14, color: AppColors.FF2F4058))),
                      Visibility(
                        visible: imageList.isNotEmpty,
                        child: Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: GridView.builder(
                                shrinkWrap: true,//为true可以解决子控件必须设置高度的问题
                                physics:NeverScrollableScrollPhysics(),//禁用滑动事件
                                padding: const EdgeInsets.all(0),
                                itemCount: imageList.length,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8
                                ),
                                itemBuilder: (BuildContext content, int index){
                                  return InkWell(
                                      child: MyCacheImageView(
                                        imageURL: imageList[index],
                                        width: 192,
                                        height: 108,
                                        errorWidgetChild: Image.asset('assets/images/icon_empty_user.png', width: 192.0, height: 108.0),
                                      ),
                                      onTap: (){
                                        Navigator.of(context).push(FadeRoute(page: PhotoViewGalleryScreen(
                                          images: imageList,//传入图片list
                                          index: index,//传入当前点击的图片的index
                                          heroTag: 'simple',//传入当前点击的图片的hero tag （可选）
                                        )));
                                      }
                                  );
                                }
                            )
                        )
                      )
                    ]
                  ),
                );}, childCount:_list2.length)),
          SliverToBoxAdapter(child: Container(color: Colors.white, height: 30))
        ]
      )
    );
  }
}
