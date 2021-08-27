import 'package:flutter/material.dart';
import 'package:good_grandma/provider/image_provider.dart';
import 'package:good_grandma/widgets/select_image.dart';
import 'package:provider/provider.dart';

import '../form/tform.dart';

///自定义图片选择器
class CustomPhotosWidget extends StatelessWidget {
  CustomPhotosWidget({
    Key key,
    this.row,
  }) : super(key: key);

  final TFormRow row;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        children: [
          Container(
            height: 48,
            alignment: Alignment.centerLeft,
            child: Text(
              row.title,
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
          Container(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: (row.state as List).length,
              itemBuilder: (BuildContext context, int index) {
                return SelectImageView(
                  selected: (image) async {
                    //实际情况是上传照片 返回图片URL，这里模拟数据使用路径
                    row.state[index]["picurl"] = image.path;
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

///自定义多图片选择器
class CustomPhotoWidget extends StatelessWidget {
  CustomPhotoWidget({Key key,
    this.title,
    this.length,
    this.sizeHeight
  }) : super(key: key);

  final String title;
  final int length;

  ///分割线间距
  double sizeHeight = 0;

  @override
  Widget build(BuildContext context) {
    final ImagesProvider imagesProvider = Provider.of<ImagesProvider>(context);
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
              width: double.infinity,
              height: sizeHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Color(0xFFF5F5F8)),
              )
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: GridView.builder(
                      shrinkWrap: true,//为true可以解决子控件必须设置高度的问题
                      physics:NeverScrollableScrollPhysics(),//禁用滑动事件
                      itemCount: imagesProvider.filePath.length == length ? imagesProvider.filePath.length : length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8
                      ),
                      itemBuilder: (BuildContext content, int index){
                        return SelectImagesView(
                          index: index,
                          imagesProvider: imagesProvider,
                        );
                      }
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

