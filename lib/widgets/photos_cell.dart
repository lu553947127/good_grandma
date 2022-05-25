import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_luban/flutter_luban.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/pages/examine/model/time_select_provider.dart';
import 'package:good_grandma/provider/image_provider.dart';
import 'package:good_grandma/widgets/select_form.dart';
import 'package:good_grandma/widgets/select_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

///自定义多图片选择器
class CustomPhotoWidget extends StatelessWidget {
  CustomPhotoWidget({Key key,
    this.title,
    this.length,
    this.url,
    this.sizeHeight,
    this.bgColor = Colors.white,
    this.address = '未知位置'
  }) : super(key: key);

  final String title;
  final int length;

  ///上传附件url
  final String url;
  final Color bgColor;

  ///分割线间距
  double sizeHeight = 0;
  final String address;

  @override
  Widget build(BuildContext context) {
    final ImagesProvider imagesProvider = Provider.of<ImagesProvider>(context);
    return Container(
      color: bgColor,
      child: Column(
        children: [
          SizedBox(
              width: double.infinity,
              height: sizeHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Color(0xFFF5F5F8)),
              )
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Visibility(
                  visible: title.isNotEmpty,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      style: TextStyle(fontSize: 15, color: Colors.black87),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: GridView.builder(
                      shrinkWrap: true,//为true可以解决子控件必须设置高度的问题
                      physics:NeverScrollableScrollPhysics(),//禁用滑动事件
                      padding: const EdgeInsets.all(0),
                      itemCount: imagesProvider.filePath.length == length ? imagesProvider.filePath.length : length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8
                      ),
                      itemBuilder: (BuildContext content, int index){
                        if (title == '拜访图片'){
                          // return WatermarkImage(
                          //     index: index,
                          //     imagesProvider: imagesProvider,
                          //     url: url,
                          //     address: address
                          // );
                          return SelectImagesView(
                              title: title,
                              index: index,
                              imagesProvider: imagesProvider,
                              url: url
                          );
                        }else {
                          return SelectImagesView(
                              title: title,
                              index: index,
                              imagesProvider: imagesProvider,
                              url: url
                          );
                        }
                      }
                  )
                )
              ]
            )
          )
        ]
      )
    );
  }
}

class OaPhotoWidget extends StatefulWidget {
  final String title;

  ///上传附件url
  final String url;
  final Color bgColor;

  ///分割线间距
  double sizeHeight = 0;
  TimeSelectProvider timeSelectProvider;
  OaPhotoWidget({
    Key key,
    this.title,
    this.url,
    this.sizeHeight,
    this.bgColor = Colors.white,
    this.timeSelectProvider
  }) : super(key: key);

  @override
  _OaPhotoWidgetState createState() => _OaPhotoWidgetState();
}

class _OaPhotoWidgetState extends State<OaPhotoWidget> {

  final ImagePicker _picker = ImagePicker();

  Future<bool> _getImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        final tempDir = await getTemporaryDirectory();
        CompressObject compressObject = CompressObject(
          imageFile: File(pickedFile.path),
          path: tempDir.path,
          quality: 5,
        );
        EasyLoading.show(status: '图片压缩中...');
        Luban.compressImage(compressObject).then((_path) {
          EasyLoading.dismiss();
          getPutFile(widget.url, _path).then((val) async{
            var data = json.decode(val.toString());
            print('请求结果---uploadFile----$data');
            if (widget.title == '图片'){
              widget.timeSelectProvider.imageAdd(data['data']['link'], 'png', '');
            }else {
              widget.timeSelectProvider.fileAdd(data['data']['link'], 'png', '');
            }
          });
        });
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Pick image error: $e');
      return false;
    }
  }

  Future<ImageSource> _showBottomSheet() async {
    return await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          double w = 240.0;
          return Container(
              height: w,
              child: Column(
                  children: <Widget>[
                    ListTile(
                        title: Text('拍照', textAlign: TextAlign.center),
                        onTap: () {
                          Navigator.pop(context, ImageSource.camera);
                        }
                    ),
                    ListTile(
                        title: Text('从相册选择', textAlign: TextAlign.center),
                        onTap: () {
                          Navigator.pop(context, ImageSource.gallery);
                        }
                    ),
                    ListTile(
                        title: Text('从文件柜选择', textAlign: TextAlign.center),
                        onTap: () async {
                          Navigator.pop(context);
                          Map select = await showSelectFileList(context);
                          print('请求结果---select----$select');
                          if (widget.title == '图片'){
                            widget.timeSelectProvider.imageAdd(select['path'], select['type'], select['iconName']);
                          }else {
                            widget.timeSelectProvider.fileAdd(select['path'], select['type'], select['iconName']);
                          }
                        }
                    ),
                    ListTile(
                        title: Text('取消', textAlign: TextAlign.center),
                        onTap: () {
                          Navigator.pop(context);
                        }
                    )
                  ]
              )
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    List<Map> fileList = [];
    if (widget.title == '图片'){
      fileList = widget.timeSelectProvider.imagePath;
    }else {
      fileList = widget.timeSelectProvider.filePath;
    }

    return Container(
        color: widget.bgColor,
        child: Column(
            children: [
              SizedBox(
                  width: double.infinity,
                  height: widget.sizeHeight,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Color(0xFFF5F5F8)),
                  )
              ),
              Container(
                  child: Column(
                      children: [
                        Visibility(
                            visible: widget.title.isNotEmpty,
                            child: ListTile(
                              title: Text(widget.title, style: const TextStyle(color: AppColors.FF070E28, fontSize: 15.0)),
                              trailing: IconButton(
                                  onPressed: () async {
                                    //show
                                    final source = await _showBottomSheet();
                                    //image
                                    if (source == null) return;

                                    final bool result = await _getImage(source);
                                    if (!result) return;
                                    setState(() {});
                                  },
                                  icon: Icon(Icons.add_circle, color: AppColors.FFC68D3E)),
                            )
                        ),
                        Visibility(
                          visible: fileList.length > 0,
                          child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: GridView.builder(
                                  shrinkWrap: true,//为true可以解决子控件必须设置高度的问题
                                  physics:NeverScrollableScrollPhysics(),//禁用滑动事件
                                  padding: const EdgeInsets.all(0),
                                  itemCount: fileList.length,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 8,
                                      crossAxisSpacing: 8
                                  ),
                                  itemBuilder: (BuildContext content, int index){
                                    return OaSelectImagesView(
                                        title: widget.title,
                                        index: index,
                                        timeSelectProvider: widget.timeSelectProvider,
                                        url: widget.url
                                    );
                                  }
                              )
                          )
                        )
                      ]
                  )
              )
            ]
        )
    );
  }
}


