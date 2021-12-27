import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_easy_refresh_sliver.dart';
import 'package:good_grandma/common/store.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/file_model.dart';
import 'package:good_grandma/pages/files/add_folder_page.dart';
import 'package:good_grandma/pages/files/file_move_copy_page.dart';
import 'package:good_grandma/pages/work/work_report/work_type_title.dart';
import 'package:good_grandma/widgets/file_cell.dart';
import 'package:good_grandma/widgets/select_image.dart';

///文件柜
class FilesPage extends StatefulWidget {
  const FilesPage({Key key}) : super(key: key);

  @override
  _FilesPageState createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();
  int _current = 1;
  int _pageSize = 10;
  String parentId = '1';
  String type = '我的文档';
  List<Map> listTitle = [
    {'name': '我的文档'},//1
    {'name': '部门文档'},//2
    {'name': '公开库'},//0
  ];

  List<FileModel> fileCabinetList = [];

  @override
  void initState() {
    super.initState();
    _controller.callRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('文件柜')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WorkTypeTitle(
              color: Colors.white,
              type: type,
              list: listTitle,
              onPressed: () {
                parentId= '1';
                type = '我的文档';
                _controller.callRefresh();
              },
              onPressed2: () {
                parentId= '2';
                type = '部门文档';
                _controller.callRefresh();
              },
              onPressed3: () {
                parentId= '0';
                type = '公开库';
                _controller.callRefresh();
              }
          ),
          Padding(
              padding: const EdgeInsets.only(left: 15, top: 16, bottom: 10),
              child: Text('我的文件')
          ),
          Expanded(
            child: MyEasyRefreshSliverWidget(
                controller: _controller,
                scrollController: _scrollController,
                dataCount: fileCabinetList.length,
                onRefresh: _refresh,
                onLoad: _onLoad,
                slivers: [
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        FileModel model = fileCabinetList[index];
                        return FileCell(
                            model: model,
                            parentId: parentId,
                            editAction: () => _cellEditName(context, model),
                            copyAction: () => _cellCopyFile(context, model),
                            deleteAction: () => _cellDeleteWith(context, model)
                        );
                      }, childCount: fileCabinetList.length))
                ]
            )
          )
        ]
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: AppColors.FFC68D3E,
        onPressed: () async {
          bool file = await _buildNewFileDialog(context);
          if (file != null) {
            if(file){//n上传文件
              showImageRange(
                  context: context,
                  callBack: (Map param){
                    _fileAddFile(context, param);
                  }
              );
            }
            else{//n文件夹
              String needRefresh = await Navigator.push(context,
                  MaterialPageRoute(builder: (_) => AddFolderPage(parentId: parentId)));
              if(needRefresh != null){
                _controller.callRefresh();
              }
            }
          }
        }
      )
    );
  }

  Future<void> _refresh() async {
    _current = 1;
    await _downloadData();
  }

  Future<void> _onLoad() async {
    _current++;
    await _downloadData();
  }

  ///文件柜
  Future<void> _downloadData() async {
    try {
      Map<String, dynamic> map = {
        'parentId': parentId,
        'isDeleted': '0',
        'status': '1',
        'current': _current,
        'size': _pageSize
      };
      final val = await requestGet(Api.fileCabinetList, param: map);
      var data = jsonDecode(val.toString());
      LogUtil.d('请求结果---fileCabinetList----$data');
      if (_current == 1) fileCabinetList.clear();
      final List<dynamic> list = data['data'];
      list.forEach((map) {
        FileModel model = FileModel.fromJson(map);
        fileCabinetList.add(model);
      });
      bool noMore = false;
      if (list == null || list.isEmpty) noMore = true;
      _controller.finishRefresh(success: true);
      _controller.finishLoad(success: true, noMore: noMore);
      if (mounted) setState(() {});
    } catch (error) {
      _controller.finishRefresh(success: false);
      _controller.finishLoad(success: false, noMore: false);
    }
  }

  ///文件删除
  _fileDelete(FileModel model){
    if(parentId == '2' || parentId == '3'){
      if (model.userId != Store.readUserId()){
        Navigator.pop(context, false);
        showToast("不能删除其他人的文件哦");
        return;
      }
    }

    Map<String, dynamic> map = {'ids': model.id};
    requestGet(Api.fileDelete, param: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---fileDelete----$data');
      if (data['code'] == 200){
        showToast("成功");
        Navigator.pop(context, true);
      }else {
        showToast(data['msg']);
      }
    });
  }

  ///文件夹添加文件
  void _fileAddFile(BuildContext context, Map param){
    Map<String, dynamic> map = {
      'parentId': parentId,
      'title': param['name'],
      'fileName': param['name'],
      'path': param['image'],
      'size': param['size']};

    requestGet(Api.fileAddFile, param: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---fileAddFile----$data');
      if (data['code'] == 200){
        showToast("成功");
        _controller.callRefresh();
      }else {
        showToast(data['msg']);
      }
    });
  }

  ///重命名
  void _cellEditName(BuildContext context, FileModel model) async{
    if(parentId == '2' || parentId == '3'){
      if (model.userId != Store.readUserId()){
        showToast("不能操作其他人的文件哦");
        return;
      }
    }

    String rename = await Navigator.push(context,
        MaterialPageRoute(builder: (_) => AddFolderPage(parentId: parentId, model: model)));
    if (rename != null && rename.isNotEmpty) {
      model.name = rename;
      _controller.callRefresh();
    }
  }

  ///复制
  void _cellCopyFile(BuildContext context, FileModel model) async{
    bool needRefresh = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) =>
                FileMoveCopyPage(model: model,folderModel: FileModel(id: parentId,name: '文件柜'), id: parentId, parentId: parentId)));
    if (needRefresh != null && needRefresh) {
      _controller.callRefresh();
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
              child: const Text('取消', style: TextStyle(color: Color(0xFF999999)))),
          TextButton(onPressed: () => _fileDelete(model),
              child: const Text('确定', style: TextStyle(color: Color(0xFFC08A3F)))),
        ],
      );
    });
    if(result != null && result) {
      setState(() => fileCabinetList.remove(model));
    }
  }

  ///新增弹窗
  Future<bool> _buildNewFileDialog(BuildContext context) {
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
                        )
                      ]
                    )
                  ]
                )
              );
            });
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    _controller?.dispose();
    super.dispose();
  }
}
