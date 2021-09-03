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
