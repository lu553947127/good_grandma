import 'package:flutter/material.dart';
import 'package:good_grandma/provider/image_provider.dart';
import 'package:good_grandma/widgets/select_image.dart';
import 'package:provider/provider.dart';

///自定义多图片选择器
class CustomPhotoWidget extends StatelessWidget {
  CustomPhotoWidget({Key key,
    this.title,
    this.length,
    this.url,
    this.sizeHeight,
    this.bgColor = Colors.white,
  }) : super(key: key);

  final String title;
  final int length;

  ///上传附件url
  final String url;
  final Color bgColor;

  ///分割线间距
  double sizeHeight = 0;

  @override
  Widget build(BuildContext context) {
    final ImagesProvider imagesProvider = Provider.of<ImagesProvider>(context);
    return Container(
      color: bgColor,
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
                Visibility(
                  visible: title.isNotEmpty,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      style: TextStyle(fontSize: 15, color: Colors.black87),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: GridView.builder(
                      shrinkWrap: true,//为true可以解决子控件必须设置高度的问题
                      physics:NeverScrollableScrollPhysics(),//禁用滑动事件
                      padding: const EdgeInsets.all(0),
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
                          url: url
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

