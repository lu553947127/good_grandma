import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

///附件在线查看详情
class FileViewPages extends StatefulWidget {
  final String title;
  final String url;
  const FileViewPages({Key key, this.title, this.url}) : super(key: key);

  @override
  State<FileViewPages> createState() => _FileViewPagesState();
}

class _FileViewPagesState extends State<FileViewPages> {

  final String fileTop = 'http://101.132.36.246:8012/onlinePreview?url=';

  // String fileUrl = fileTop + encodeBase64(widget.url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: WebView(
            initialUrl: 'http://101.132.36.246:8012/onlinePreview?url=aHR0cHM6Ly9oYXAtZmlsZS5vc3MtY24tc2hhbmdoYWkuYWxpeXVuY3MuY29tL3VwbG9hZC9vYS8yMDIyMDcxOC9mY2Y4ZTNkOS05MTM1LTQ1ODEtODc0OC01NTc2NTYyZDcxYTMuemlw',
            javascriptMode: JavascriptMode.unrestricted)
    );
  }
}
