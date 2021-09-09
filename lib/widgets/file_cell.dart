import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/models/file_model.dart';
import 'package:good_grandma/pages/files/add_folder_page.dart';
import 'package:good_grandma/pages/files/file_detail_page.dart';
import 'package:good_grandma/pages/files/file_move_copy_page.dart';
import 'package:good_grandma/pages/files/file_reader_page.dart';
import 'package:good_grandma/pages/files/in_folder_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileCell extends StatelessWidget {
  const FileCell({
    Key key,
    @required this.model,
    this.showMenu = true,
    this.deleteAction,
  }) : super(key: key);

  final FileModel model;
  final bool showMenu;
  final VoidCallback deleteAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
      child: Card(
          child: ListTile(
        onTap: () {
          if (model.isFolder) {
            _openFolder(context);
          } else {
            _onTap(context,model);
          }
        },
        leading: Image.asset(model.iconName, width: 25, height: 25),
        title: Text(model.name),
        subtitle: Text(
            model.sizeString + ' ' + model.author + ' ' + model.updateTime),
        trailing: Visibility(
            visible: showMenu,
            child: IconButton(
                onPressed: () => _menuBtnOnTap(context),
                icon: Icon(Icons.more_horiz))),
      )),
    );
  }

  _onTap(BuildContext context,FileModel fileModel) async {
    bool isGranted = await Permission.storage.isGranted;
    if (!isGranted) {
      isGranted = (await Permission.storage.request()).isGranted;
      if (!isGranted) {
        Fluttertoast.showToast(msg: 'NO Storage Permission');
        return;
      }
    }
    String localPath = await fileLocalName(fileModel.type, fileModel.path);
    if (!await File(localPath).exists()) {
      if (!await asset2Local(fileModel.type, fileModel.path)) {
        return;
      }
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
      return FileReaderPage(
        filePath: localPath,
        fileName: fileModel.name,
      );
    }));
  }

  fileLocalName(String type, String assetPath) async {
    String dic = await _localSavedDir() + "/filereader/files/";
    return dic + base64.encode(utf8.encode(assetPath)) + "." + type;
  }

  fileExists(String type, String assetPath) async {
    String fileName = await fileLocalName(type, assetPath);
    if (await File(fileName).exists()) {
      return true;
    }
    return false;
  }

  asset2Local(String type, String assetPath) async {
    if (Platform.isAndroid) {
      if (!await Permission.storage.isGranted) {
        debugPrint("没有存储权限");
        return false;
      }
    }

    File file = File(await fileLocalName(type, assetPath));
    if (await fileExists(type, assetPath)) {
      await file.delete();
    }
    await file.create(recursive: true);
    //await file.create();
    debugPrint("文件路径->" + file.path);
    ByteData bd = await rootBundle.load(assetPath);
    await file.writeAsBytes(bd.buffer.asUint8List(), flush: true);
    return true;
  }

  _localSavedDir() async {
    Directory dic;
    if (defaultTargetPlatform == TargetPlatform.android) {
      dic = await getExternalStorageDirectory();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      dic = await getApplicationDocumentsDirectory();
    }
    return dic?.path;
  }

  void _menuBtnOnTap(BuildContext context) async {
    String result = await _buildMenuDialog(context);
    if (result != null) {
      switch (result) {
        case '详细信息':
          {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => FileDetailPage(fileModel: model)));
          }
          break;
        case '重命名':
          {
            String rename = await Navigator.push(context,
                MaterialPageRoute(builder: (_) => AddFolderPage(model: model)));
            if (rename != null && rename.isNotEmpty) {
              model.name = rename;
            }
          }
          break;
        case '移动':
          {
            bool needRefresh = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => FileMoveCopyPage(model: model)));
            if (needRefresh != null && needRefresh) {}
          }
          break;
        case '复制':
          {
            bool needRefresh = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        FileMoveCopyPage(model: model, move: false)));
            if (needRefresh != null && needRefresh) {}
          }
          break;
        case '删除':
          {
            if (deleteAction != null) deleteAction();
          }
          break;
        case '下载':
          {}
          break;
      }
    }
  }

  Future<String> _buildMenuDialog(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_) {
          List<String> titles = ['详细信息', '重命名', '移动', '复制', '删除', '下载'];
          return Container(
            height: 350 + MediaQuery.of(context).padding.bottom,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: ListTile(
                    leading: Image.asset(model.iconName, width: 25, height: 25),
                    title: Text(model.name),
                    subtitle: Text(model.updateTime),
                  ),
                ),
                const Divider(height: 1, indent: 15.0, endIndent: 15.0),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemBuilder: (context, index) {
                      return ListTile(
                          onTap: () => Navigator.pop(context, titles[index]),
                          title: Text(titles[index]));
                    },
                    itemCount: titles.length,
                  ),
                ),
                const Divider(height: 1),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Container(
                      width: double.infinity,
                      height: 48,
                      child: Center(
                          child: const Text('取消',
                              style: TextStyle(
                                  color: AppColors.FF959EB1, fontSize: 14.0)))),
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom),
              ],
            ),
          );
        });
  }

  void _openFolder(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => InFolderPage(folderModel: model)));
  }
}
