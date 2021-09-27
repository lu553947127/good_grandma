import 'package:flutter/material.dart';
import 'package:flutter_filereader/flutter_filereader.dart';

class FileReaderPage extends StatefulWidget {
  const FileReaderPage({Key key,@required this.filePath, @required this.fileName}) : super(key: key);
  final String filePath;
  final String fileName;

  @override
  _FileReaderPageState createState() => _FileReaderPageState();
}

class _FileReaderPageState extends State<FileReaderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.fileName)),
      body: FileReaderView(
        filePath: widget.filePath,
      )
    );
  }
}
