import 'package:flutter/material.dart';

///加载中样式
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}

///加载失败样式
class LoadFailWidget extends StatelessWidget {
  const LoadFailWidget({Key key, this.retryAction}) : super(key: key);
  final VoidCallback retryAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
          onPressed: retryAction,
          child: const Text('加载失败，请点击重试',
              style: const TextStyle(color: Colors.grey, fontSize: 14.0))),
    );
  }
}
///没有数据的样式
class NoDataWidget extends StatelessWidget {
  const NoDataWidget({Key key, this.emptyRetry}) : super(key: key);
  final VoidCallback emptyRetry; //无数据事件处理

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: emptyRetry,
        child: Container(
            margin: EdgeInsets.all(40),
            child: Image.asset('assets/images/icon_empty_images.png', width: 150, height: 150)
        ),
      ),
    );
  }
}
