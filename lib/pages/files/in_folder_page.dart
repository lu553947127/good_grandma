import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/models/file_model.dart';
import 'package:good_grandma/pages/files/add_folder_page.dart';
import 'package:good_grandma/widgets/file_cell.dart';

///文件夹列表
class InFolderPage extends StatefulWidget {
  const InFolderPage({Key key,@required this.folderModel}) : super(key: key);
  final FileModel folderModel;

  @override
  _InFolderPageState createState() => _InFolderPageState();
}

class _InFolderPageState extends State<InFolderPage> {
  List<FileModel> _files = [];
  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.folderModel.name)),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Scrollbar(
          child: CustomScrollView(
            slivers: [
              //列表
              SliverPadding(
                padding: const EdgeInsets.only(top: 10.0),
                sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      FileModel model = _files[index];
                      return FileCell(model: model);
                    }, childCount: _files.length)),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: AppColors.FFC68D3E,
        onPressed: () async {
          bool file = await buildNewFileDialog(context);
          if (file != null) {
            if(file){//n上传文件

            }
            else{//n文件夹
              bool needRefresh = await Navigator.push(context,
                  MaterialPageRoute(builder: (_) => AddFolderPage()));
              if(needRefresh != null && needRefresh){
                _refresh();
              }
            }
          }
        },
      ),
    );
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
    ]);
    setState(() {});
  }
}
