import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/models/file_model.dart';
import 'package:good_grandma/pages/files/add_folder_page.dart';

///文件夹列表
class FileMoveCopyPage extends StatefulWidget {
  const FileMoveCopyPage(
      {Key key, @required this.model, this.move = true, this.folderModel})
      : super(key: key);

  ///要移动的文件
  final FileModel model;

  ///要打开的文件夹，可以为空
  final FileModel folderModel;

  ///标记是移动还是复制
  final bool move;

  @override
  _FileMoveCopyPageState createState() => _FileMoveCopyPageState();
}

class _FileMoveCopyPageState extends State<FileMoveCopyPage> {
  List<FileModel> _files = [];
  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.folderModel != null)
      print('widget.folderModel.name = ${widget.folderModel.name}');
    double btnW = (MediaQuery.of(context).size.width - 10.0) / 2 - 50;
    return Scaffold(
      appBar: AppBar(
          title: Text(
              widget.folderModel != null ? widget.folderModel.name : '我的文件')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Scrollbar(
            child: ListView.builder(
          itemBuilder: (c, index) {
            FileModel model = _files[index];
            return Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
              child: Card(
                  child: ListTile(
                onTap: () {
                  if (model.isFolder) {
                    _openFolder(context, model);
                  }
                },
                leading: Image.asset(model.iconName, width: 25, height: 25),
                title: Text(model.name),
                subtitle: Text(model.sizeString +
                    ' ' +
                    model.author +
                    ' ' +
                    model.updateTime),
                trailing: Visibility(
                    visible: model.isFolder, child: Icon(Icons.chevron_right)),
              )),
            );
          },
          itemCount: _files.length,
        )),
      ),
      bottomNavigationBar: Padding(
        padding:
            EdgeInsets.only(bottom: 17 + MediaQuery.of(context).padding.bottom),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton(
                onPressed: () async{
                  String needRefresh = await Navigator.push(context,
                      MaterialPageRoute(builder: (_) => AddFolderPage()));
                  if(needRefresh != null){
                    _refresh();
                  }
                },
                style: OutlinedButton.styleFrom(backgroundColor: Colors.white),
                child: SizedBox(
                    width: btnW,
                    height: 40.0,
                    child: Center(
                        child: const Text(
                      '新建文件夹',
                      style:
                          TextStyle(color: AppColors.FF2F4058, fontSize: 14.0),
                    )))),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context,true);
                },
                style: ElevatedButton.styleFrom(primary: AppColors.FFC08A3F),
                child: SizedBox(
                    width: btnW,
                    height: 40.0,
                    child: Center(
                        child: const Text(
                      '移动到这里',
                      style:
                          TextStyle(color: Colors.white, fontSize: 14.0),
                    )))),
          ],
        ),
      ),
    );
  }

  void _openFolder(BuildContext context, FileModel folderModel) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => FileMoveCopyPage(
                folderModel: folderModel,
                model: widget.model,
                move: widget.move)));
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    _files.clear();
    _files.addAll([
      FileModel(
        name: '文件夹名称',
        size: 12345,
        author: '张思',
        updateTime: '2020-09-09 00:00:00',
        isFolder: true,
      ),
      FileModel(
        name: '文件名称.doc',
        size: 12345,
        author: '张思',
        updateTime: '2020-09-09 00:00:00',
      ),
      FileModel(
        name: '文件名称.pptx',
        size: 12345,
        author: '张思',
        updateTime: '2020-09-09 00:00:00',
      ),
      FileModel(
        name: '文件名称.pptx',
        size: 12345,
        author: '张思',
        updateTime: '2020-09-09 00:00:00',
      ),
      FileModel(
        name: '文件名称.pptx',
        size: 12345,
        author: '张思',
        updateTime: '2020-09-09 00:00:00',
      ),
      FileModel(
        name: '文件名称.pptx',
        size: 12345,
        author: '张思',
        updateTime: '2020-09-09 00:00:00',
      ),
    ]);
    setState(() {});
  }
}
