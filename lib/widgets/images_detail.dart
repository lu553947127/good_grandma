import 'package:flutter/material.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';

///图片查看详情
class ImagesDetailPage extends StatefulWidget {
  final String images;
  const ImagesDetailPage({Key key, this.images}) : super(key: key);

  @override
  _ImagesDetailPageState createState() => _ImagesDetailPageState();
}

class _ImagesDetailPageState extends State<ImagesDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('图片查看')),
      body: MyCacheImageView(
        imageURL: widget.images,
        width: double.infinity,
        height: double.infinity,
        errorWidgetChild: Image.asset('assets/images/icon_empty_user.png', width: 192.0, height: 108.0),
      )
    );
  }
}
