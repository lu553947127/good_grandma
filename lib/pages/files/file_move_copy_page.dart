import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/file_model.dart';
import 'package:good_grandma/pages/files/add_folder_page.dart';

///文件夹列表
class FileMoveCopyPage extends StatefulWidget {
  const FileMoveCopyPage(
      {Key key, @required this.model, this.id, this.parentId, this.folderModel})
      : super(key: key);

  ///当前文件夹的Id
  final String id;

  ///最上级的id
  final String parentId;

  ///要移动的文件
  final FileModel model;

  ///要打开的文件夹，可以为空
  final FileModel folderModel;

  @override
  _FileMoveCopyPageState createState() => _FileMoveCopyPageState();
}

class _FileMoveCopyPageState extends State<FileMoveCopyPage> {
  List<FileModel> fileCabinetList = [];

  ///文件柜列表
  _fileCabinetList(){
    Map<String, dynamic> map = {
      'parentId': widget.folderModel.id,
      'isDeleted': '0'
    };
    // print('param = $map');
    requestGet(Api.fileCabinetList, param: map).then((val) async{
      var data = json.decode(val.toString());
      // LogUtil.d('请求结果---fileCabinetList----$data');
      fileCabinetList.clear();
      final List<dynamic> list = data['data'];
      list.forEach((map) {
        FileModel model = FileModel.fromJson(map);
        fileCabinetList.add(model);
      });
      setState(() {});
    });
  }

  ///文件夹添加文件
  void _fileCopy(BuildContext context){
    Map<String, dynamic> map = {
      'id': widget.model.id,
      'parentId': widget.folderModel.id??'1',
      'superiorId': widget.folderModel.id??'1'};
    requestGet(Api.fileCopy, param: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---fileCopy----$data');
      if (data['code'] == 200){
        showToast("成功");
        Navigator.pop(context, true);
      }else {
        showToast(data['msg']);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fileCabinetList();
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.folderModel != null)
    //   print('widget.folderModel.name = ${widget.folderModel.name}');
    double btnW = (MediaQuery.of(context).size.width - 10.0) / 2 - 50;
    return Scaffold(
      appBar: AppBar(
          title: Text(
              widget.folderModel != null ? widget.folderModel.name : '我的文件')),
      body: Scrollbar(
          child: ListView.builder(
            itemBuilder: (c, index) {
              FileModel model = fileCabinetList[index];
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
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(model.isFolder == true ? model.author : model.sizeString + ' ' + model.author),
                          SizedBox(height: 5),
                          Text(model.updateTime)
                        ],
                      ),
                      trailing: Visibility(
                          visible: model.isFolder, child: Icon(Icons.chevron_right)),
                    )),
              );
            },
            itemCount: fileCabinetList.length,
          )),
      bottomNavigationBar: Padding(
        padding:
            EdgeInsets.only(bottom: 17 + MediaQuery.of(context).padding.bottom),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton(
                onPressed: () async{
                  String needRefresh = await Navigator.push(context,
                      MaterialPageRoute(builder: (_) => AddFolderPage(parentId: widget.folderModel.id)));
                  if(needRefresh != null){
                    _fileCabinetList();
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
                  _fileCopy(context);
                },
                style: ElevatedButton.styleFrom(primary: AppColors.FFC08A3F),
                child: SizedBox(
                    width: btnW,
                    height: 40.0,
                    child: Center(
                        child: const Text(
                      '复制到这里',
                      style:
                          TextStyle(color: Colors.white, fontSize: 14.0),
                    )))),
          ],
        ),
      ),
    );
  }

  ///打开下级文件夹
  void _openFolder(BuildContext context, FileModel folderModel) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => FileMoveCopyPage(
                folderModel: folderModel,
                model: widget.model,
                id: widget.model.id,
                parentId: widget.parentId)));
  }
}
