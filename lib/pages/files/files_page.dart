// import 'dart:io';

// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/models/file_model.dart';
import 'package:good_grandma/pages/files/add_folder_page.dart';
import 'package:good_grandma/pages/work/work_report/work_type_title.dart';
import 'package:good_grandma/widgets/file_cell.dart';
import 'package:good_grandma/widgets/search_text_widget.dart';
// import 'package:permission_handler/permission_handler.dart';

///文件柜
class FilesPage extends StatefulWidget {
  const FilesPage({Key key}) : super(key: key);

  @override
  _FilesPageState createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  FocusNode _focusNode = FocusNode();
  TextEditingController _editingController = TextEditingController();
  List<FileModel> _files = [];

  String type = '我的文档';
  List<Map> listTitle = [
    {'name': '我的文档'},//1
    {'name': '部门文档'},//2
    {'name': '公开库'},//0
  ];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('文件柜')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Scrollbar(
          child: CustomScrollView(
            slivers: [
              //搜索区域
              //切换选项卡
              WorkTypeTitle(
                color: Colors.white,
                type: type,
                list: listTitle,
                onPressed: () {
                  setState(() {
                    type = listTitle[0]['name'];
                  });
                },
                onPressed2: () {
                  setState(() {
                    type = listTitle[1]['name'];
                  });
                },
                onPressed3: () {
                  setState(() {
                    type = listTitle[2]['name'];
                  });
                },
              ),
              // SearchTextWidget(
              //     editingController: _editingController,
              //     focusNode: _focusNode,
              //     hintText: '输入搜索关键字',
              //     onSearch: (text) {}),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 16, bottom: 10),
                  child: Text('我的文件'),
                ),
              ),
              //列表
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                FileModel model = _files[index];
                return FileCell(model: model,deleteAction: () => _cellDeleteWith(context,model),);
              }, childCount: _files.length)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: AppColors.FFC68D3E,
        onPressed: () async {
          bool file = await _buildNewFileDialog(context);
          if (file != null) {
            if(file){//n上传文件
              _pickLocalFile(context);
            }
            else{//n文件夹
              String needRefresh = await Navigator.push(context,
                  MaterialPageRoute(builder: (_) => AddFolderPage()));
              if(needRefresh != null){
                _refresh();
              }
            }
          }
        },
      ),
    );
  }
  _pickLocalFile(BuildContext context) async{
    // bool isGranted = await Permission.storage.isGranted;
    // if (!isGranted) {
    //   isGranted = (await Permission.storage.request()).isGranted;
    //   if (!isGranted) {
    //     Fluttertoast.showToast(msg: 'NO Storage Permission');
    //     return;
    //   }
    // }
    // FilePickerResult result = await FilePicker.platform.pickFiles();
    //
    // if(result != null) {
    //   // File file = File(result.files.single.path);
    //   PlatformFile file = result.files.first;
    //
    //   print(file.name);
    //   print(file.bytes);
    //   print(file.size);
    //   print(file.extension);
    //   print(file.path);
    // } else {
    //   // User canceled the picker
    // }
  }

  void _cellDeleteWith(BuildContext context,FileModel model) async{
    bool result = await showDialog(context: context, builder: (_){
      return AlertDialog(
        title: const Text('警告'),
        content: const Text('确定要删除吗？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context,false), child: const Text('取消')),
          TextButton(onPressed: () => Navigator.pop(context,true), child: const Text('确定')),
        ],
      );
    });
    if(result != null && result) {
      setState(() => _files.remove(model));
    }
  }

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
                        ),
                      ],
                    ),
                  ],
                ),
              );
            });
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
        name: '附件1：济南市工程技术专业课学习的通知.doc',
        path: 'assets/file/5.doc',
        size: 12345,
        author: '张思',
        updateTime: '2020-09-09 00:00:00',
      ),
      FileModel(
        name: '1.xlsx',
        path: 'assets/file/1.xlsx',
        size: 12345,
        author: '张思',
        updateTime: '2020-09-09 00:00:00',
      ),
      FileModel(
        name: '2021年全员培训考核试题库附答案.txt',
        path: 'assets/file/2.txt',
        size: 12345,
        author: '张思',
        updateTime: '2020-09-09 00:00:00',
      ),
      FileModel(
        name: '菜单.png',
        path: 'assets/file/4.png',
        size: 12345,
        author: '张思',
        updateTime: '2020-09-09 00:00:00',
      ),
      FileModel(
        name: '附件3：章丘区应急管理局关于开展企业全员安全生产“大学习、大培训、大考试”专项行动的通知.pdf',
        path: 'assets/file/6.pdf',
        size: 12345,
        author: '张思',
        updateTime: '2020-09-09 00:00:00',
      ),
      // FileModel(
      //   name: '文件名称.doc',
      //   size: 12345,
      //   author: '张思',
      //   updateTime: '2020-09-09 00:00:00',
      // ),
      // FileModel(
      //   name: '文件名称.pptx',
      //   size: 12345,
      //   author: '张思',
      //   updateTime: '2020-09-09 00:00:00',
      // ),
    ]);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode?.dispose();
    _editingController?.dispose();
  }
}
