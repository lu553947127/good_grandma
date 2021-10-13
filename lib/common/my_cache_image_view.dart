import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';

///对CachedNetworkImage进一步封装
class MyCacheImageView extends StatelessWidget {
  ///图片地址
  final String imageURL;

  ///宽度
  final double width;

  ///高度
  final double height;
  final Widget errorWidgetChild;
  final Color color;
  MyCacheImageView({
    Key key,
    @required this.imageURL,
    @required this.width,
    @required this.height,
    this.errorWidgetChild,
    this.color,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (imageURL == null || imageURL.length == 0) {
      return Container(
        color: this.errorWidgetChild != null
            ? Colors.transparent
            : Colors.grey[200],
        child: this.errorWidgetChild ??
            Icon(
              Icons.image,
              color: Colors.grey,
            ),
        width: width,
        height: height,
      );
    }
    return CachedNetworkImage(
      imageUrl: imageURL,
      width: width,
      height: height,
      fit: BoxFit.cover,
      color: color,
      placeholder: (context, url) => Center(child: CircularProgressIndicator(color: AppColors.FFC68D3E)),
      errorWidget: (context, url, error) => Container(
        color: this.errorWidgetChild != null
            ? Colors.transparent
            : Colors.grey[200],
        child: this.errorWidgetChild ??
            Image.asset('assets/images/icon_empty_user.png',
                width: width, height: height),
        width: width,
        height: height,
      ),
    );
  }
}
