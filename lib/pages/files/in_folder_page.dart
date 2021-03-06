import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/store.dart';
import 'package:good_grandma/models/file_model.dart';
import 'package:good_grandma/pages/files/add_folder_page.dart';
import 'package:good_grandma/pages/files/file_move_copy_page.dart';
import 'package:good_grandma/widgets/file_cell.dart';
import 'package:good_grandma/widgets/select_image.dart';

///文件夹列表
class InFolderPage extends StatefulWidget {
  const InFolderPage({Key key,@required this.folderModel, this.parentId}) : super(key: key);
  final FileModel folderModel;
  final String parentId;

  @override
  _InFolderPageState createState() => _InFolderPageState();
}

class _InFolderPageState extends State<InFolderPage> {

  List<FileModel> fileCabinetList = [];

  ///文件柜列表
  _fileCabinetList(){
    Map<String, dynamic> map = {
      'parentId': widget.folderModel.id,
      'isDeleted': '0'
    };
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

  ///文件删除
  _fileDelete(FileModel model){
    if(widget.parentId == '2' || widget.parentId == '3'){
      if (model.userId != Store.readUserId()){
        Navigator.pop(context, false);
        EasyLoading.showToast("不能删除其他人的文件哦");
        return;
      }
    }

    Map<String, dynamic> map = {'ids': model.id};
    requestGet(Api.fileDelete, param: map).then((val) async{
      var data = json.decode(val.toString());
      // LogUtil.d('请求结果---fileDelete----$data');
      if (data['code'] == 200){
        EasyLoading.showToast("成功");
        Navigator.pop(context, true);
      }else {
        EasyLoading.showToast(data['msg']);
      }
    });
  }

  ///文件夹添加文件
  void _fileAddFile(BuildContext context, Map param){
    Map<String, dynamic> map = {
      'parentId': widget.folderModel.id,
      'title': param['name'],
      'fileName': param['name'],
      'path': param['image'],
      'size': param['size']};

    requestGet(Api.fileAddFile, param: map).then((val) async{
      var data = json.decode(val.toString());
      // LogUtil.d('请求结果---fileAddFile----$data');
      if (data['code'] == 200){
        EasyLoading.showToast("成功");
        _fileCabinetList();
      }else {
        EasyLoading.showToast(data['msg']);
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
    return Scaffold(
      appBar: AppBar(title: Text(widget.folderModel.name)),
      body: Scrollbar(
        child: CustomScrollView(
          slivers: [
            fileCabinetList.length > 0 ?
            //列表
            SliverPadding(
              padding: const EdgeInsets.only(top: 10.0),
              sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    FileModel model = fileCabinetList[index];
                    return FileCell(
                        model: model,
                        parentId: widget.parentId,
                        editAction: () => _cellEditName(context, model),
                        copyAction: () => _cellCopyFile(context, model),
                        deleteAction: () => _cellDeleteWith(context, model)
                    );
                  }, childCount: fileCabinetList.length))
            ) :
            SliverToBoxAdapter(
                child: Container(
                    margin: EdgeInsets.all(40),
                    child: Image.asset('assets/images/icon_empty_images.png', width: 150, height: 150)
                )
            )
          ]
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: AppColors.FFC68D3E,
        onPressed: () async {
          bool file = await buildNewFileDialog(context);
          if (file != null) {
            if(file){//n上传文件
              aliSignature();
            }
            else{//n文件夹
              String needRefresh = await Navigator.push(context,
                  MaterialPageRoute(builder: (_) => AddFolderPage(parentId: widget.folderModel.id)));
              if(needRefresh != null){
                _fileCabinetList();
              }
            }
          }
        },
      ),
    );
  }

  ///重命名
  void _cellEditName(BuildContext context, FileModel model) async{
    if(widget.parentId == '2' || widget.parentId == '3'){
      if (model.userId != Store.readUserId()){
        EasyLoading.showToast("不能操作其他人的文件哦");
        return;
      }
    }

    String rename = await Navigator.push(context,
        MaterialPageRoute(builder: (_) => AddFolderPage(parentId: widget.folderModel.id, model: model)));
    if (rename != null && rename.isNotEmpty) {
      model.name = rename;
      _fileCabinetList();
    }
  }

  ///复制
  void _cellCopyFile(BuildContext context, FileModel model) async{
    bool needRefresh = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) =>
                FileMoveCopyPage(model: model,folderModel: FileModel(id: '1',name: '文件柜'), id: model.id, parentId: widget.parentId)));
    if (needRefresh != null && needRefresh) {
      _fileCabinetList();
    }
  }

  ///删除
  void _cellDeleteWith(BuildContext context, FileModel model) async{
    bool result = await showDialog(context: context, builder: (_){
      return AlertDialog(
        title: const Text('警告'),
        content: const Text('确定要删除吗？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context,false),
              child: Text('取消', style: TextStyle(color: Color(0xFF999999)))),
          TextButton(onPressed: () => _fileDelete(model),
              child: Text('确定', style: TextStyle(color: Color(0xFFC08A3F)))),
        ],
      );
    });
    if(result != null && result) {
      setState(() => fileCabinetList.remove(model));
    }
  }

  Future<bool> buildNewFileDialog(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_) {
          return Container(
            height: 165 + MediaQuery.of(context).padding.bottom,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.vertical(top: Radius.circular(20.0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: const Text('新建文件',
                      style: TextStyle(fontSize: 15.0)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Column(
                          children: [
                            Image.asset('assets/images/file_folder.png',width: 25,height: 25),
                            const Text('\n文件夹',style: TextStyle(color: Colors.black,fontSize: 12.0)),
                          ],
                        )
                    ),
                    TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Column(
                          children: [
                            Image.asset('assets/images/file_new.png',width: 25,height: 25),
                            const Text('\n上传文件',style: TextStyle(color: Colors.black,fontSize: 12.0)),
                          ],
                        )
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  ///获取阿里oss配置信息
  aliSignature(){
    Map<String, dynamic> map = {'dir': 'file'};
    requestPost(Api.aliSignature, json: jsonEncode(map)).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---aliSignature----$data');
      Store.saveOssAccessKeyId(data['data']['accessId']);
      Store.saveOssEndpoint(data['data']['host']);
      Store.saveOssPolicy(data['data']['policy']);
      Store.saveOssSignature(data['data']['signature']);
      Store.saveOssDir(data['data']['dir']);

      showImageRange(
          context: context,
          callBack: (Map param){
            _fileAddFile(context, param);
          }
      );
    });
  }
}
