import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:good_grandma/common/loading_widget.dart';

/// 刷新视图
class MyEasyRefreshSliverWidget extends StatelessWidget {
  const MyEasyRefreshSliverWidget({
    Key key,
    @required this.controller,
    @required this.scrollController,
    this.firstRefresh = true,
    @required this.dataCount,
    @required this.onRefresh,
    @required this.onLoad,
    @required this.slivers,
  }) : super(key: key);
  final List<Widget> slivers;
  final bool firstRefresh;
  final EasyRefreshController controller;
  final ScrollController scrollController;
  final int dataCount;
  final VoidCallback onRefresh;
  final VoidCallback onLoad;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: EasyRefresh.custom(
        slivers: slivers,
        firstRefresh: firstRefresh,
        firstRefreshWidget: firstRefresh ? LoadingWidget() : null,
        enableControlFinishRefresh: true,
        enableControlFinishLoad: onLoad != null,
        controller: controller,
        scrollController: scrollController,
        header: BezierCircleHeader(backgroundColor: Color(0xFFC68D3E)),
        footer: onLoad != null
            ?  BezierBounceFooter(backgroundColor: Color(0xFFC68D3E))
        // ClassicalFooter(
        //         enableInfiniteLoad: true,
        //         enableHapticFeedback: true,
        //         loadText: '上拉加载',
        //         loadReadyText: '松手,加载更多!',
        //         loadingText: '加载中...',
        //         loadedText: '加载完成',
        //         loadFailedText: '加载失败',
        //         noMoreText: '没有更多数据了!',
        //       )
            : null,
        emptyWidget:
            dataCount == 0 ? NoDataWidget(emptyRetry: onRefresh) : null,
        onRefresh: onRefresh,
        onLoad: onLoad,
      ),
    );
  }
}
