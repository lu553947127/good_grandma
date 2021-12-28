import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/models/file_model.dart';
import 'package:good_grandma/pages/files/file_detail_page.dart';
import 'package:good_grandma/pages/files/in_folder_page.dart';
import 'package:good_grandma/widgets/picture_big_view.dart';
import 'package:url_launcher/url_launcher.dart';

class FileCell extends StatelessWidget {
  const FileCell({
    Key key,
    this.parentId,
    @required this.model,
    this.showMenu = true,
    this.editAction,
    this.copyAction,
    this.deleteAction,
  }) : super(key: key);

  final String parentId;
  final FileModel model;
  final bool showMenu;
  final VoidCallback editAction;
  final VoidCallback copyAction;
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
            _onTap(context, model);
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
            visible: showMenu,
            child: IconButton(
                onPressed: () => _menuBtnOnTap(context),
                icon: Icon(Icons.more_horiz))),
      )),
    );
  }

  ///跳转打开文件页面
  _onTap(BuildContext context, FileModel fileModel) async {
    if (fileModel.type == 'png' || fileModel.type == 'jpg' || fileModel.type == 'jpeg'){
      List<String> imagesList = [];
      imagesList.add(fileModel.path);
      Navigator.of(context).push(FadeRoute(page: PhotoViewGalleryScreen(
        images: imagesList,//传入图片list
        index: 0,//传入当前点击的图片的index
        heroTag: 'simple',//传入当前点击的图片的hero tag （可选）
      )));
    }else {
      _launchURL(fileModel.path);
    }
  }

  ///打开文件夹页面
  void _openFolder(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => InFolderPage(folderModel: model)));
  }

  ///用内置浏览器打开网页
  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      EasyLoading.showToast('Could not launch $url');
    }
  }

  ///更多菜单点击事件
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
            if (editAction != null) editAction();
          }
          break;
        case '复制':
          {
            if (copyAction != null) copyAction();
          }
          break;
        case '删除':
          {
            if (deleteAction != null) deleteAction();
          }
          break;
      }
    }
  }

  ///更多菜单选择弹窗
  Future<String> _buildMenuDialog(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_) {
          List<String> titles = ['详细信息', '重命名', '复制', '删除'];
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
}
