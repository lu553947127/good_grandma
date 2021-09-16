import 'dart:io';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/msg_list_model.dart';
import 'package:good_grandma/widgets/msg_detail_cell_content.dart';
import 'package:provider/provider.dart';

///规章详情
class RegularDocDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Body();
}

class _Body extends State<RegularDocDetailPage> {
  @override
  Widget build(BuildContext context) {
    final MsgListModel model = Provider.of<MsgListModel>(context);
    return Scaffold(
      appBar: AppBar(title: Text('规章详情')),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                //顶部信息
                MsgDetailCellContent(model: model),
                SizedBox(height: 10.0),
                //附件信息
                Visibility(
                  visible: model.haveEnclosure,
                  child: DownloadEnclosureWidget(model: model),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

///带下载功能的附件Widget
class DownloadEnclosureWidget extends StatefulWidget {
  const DownloadEnclosureWidget({Key key,@required this.model}) : super(key: key);
  final MsgListModel model;

  @override
  _DownloadEnclosureWidgetState createState() => _DownloadEnclosureWidgetState();
}

class _DownloadEnclosureWidgetState extends State<DownloadEnclosureWidget> {
  ///当前进度进度百分比  当前进度/总进度 从0-1
  double _currentProgress = 0.0;
  ///下载完成后的提示信息
  String _pathMsg = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: ListTile(
            leading: Image.asset('assets/images/msg_enclosure.png',
                width: 30, height: 30),
            title: Text(
              widget.model.enclosureName.isEmpty
                  ? '附件'
                  : widget.model.enclosureName,
              style: const TextStyle(
                  color: AppColors.FF2F4058, fontSize: 14.0),
            ),
            subtitle: Text(
                (widget.model.enclosureSize.isNotEmpty
                    ? double.parse(widget.model.enclosureSize).toStringAsFixed(2)
                    : '0') +
                    ' MB',
                style: const TextStyle(
                    color: AppColors.FFC1C8D7, fontSize: 11.0)),
            trailing: _currentProgress > 0 && _currentProgress < 1
                ? Container(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                  value: _currentProgress),
            )
                : IconButton(
              onPressed: () {
                if (widget.model.enclosureURL.isNotEmpty)
                  AppUtil.downloadFile(url: widget.model.enclosureURL,fileName: widget.model.enclosureName.isEmpty
                      ? '附件'
                      : widget.model.enclosureName,
                    onReceiveProgress: (int count, int total) {
                      if (mounted) setState(() => _currentProgress = count / total);
                      // LogUtil.d('onReceiveProgress count = $count,total = $total');
                    },
                    completedHandle: (){
                      _pathMsg = '下载完成\n请到\"/sdcard/download/好阿婆附件/\"中查看';
                      if(Platform.isIOS){
                        _pathMsg = '下载完成\n请到\"桌面-文件-我的iPhone-好阿婆-附件\"中查看';
                      }
                      if(mounted)
                        setState(() {});
                    }
                  );
              },
              icon: Image.asset(
                  'assets/images/download_image.png',
                  width: 24,
                  height: 24),
            ),
            onTap: () {
              if (widget.model.enclosureViewURL.isNotEmpty)
                AppUtil.launchURL(widget.model.enclosureViewURL);
              else
                AppUtil.showToastCenter('预览地址为空');
            },
          ),
        ),
        Visibility(
          visible: _pathMsg.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_pathMsg),
            )),
      ],
    );
  }
}

