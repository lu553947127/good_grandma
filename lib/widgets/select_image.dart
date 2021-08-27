import 'dart:convert';
import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/provider/image_provider.dart';
import 'package:good_grandma/widgets/picture_big_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SelectImageView extends StatefulWidget {
  SelectImageView({Key key, this.selected}) : super(key: key);

  final Future Function(File image) selected;

  @override
  _SelectImageViewState createState() => _SelectImageViewState();
}

class _SelectImageViewState extends State<SelectImageView> {
  final _picker = ImagePicker();
  File _image;
  String _imageUrl;

  Future<bool> _getImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.getImage(source: source);
      if (pickedFile != null) {
        _image = File(pickedFile.path);
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
          return Container(
            height: 180.0,
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text('拍照', textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.pop(context, ImageSource.camera);
                  },
                ),
                ListTile(
                  title: Text('从相册选择', textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.pop(context, ImageSource.gallery);
                  },
                ),
                ListTile(
                  title: Text('取消', textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        //show
        final source = await _showBottomSheet();
        //image
        if (source == null) return;
        final bool result = await _getImage(source);
        if (!result) return;
        if (widget.selected == null) return;
        final url = await widget.selected(_image);
        if (url != null) _imageUrl = url;
        setState(() {});
      },
      child: Container(
        width: 100,
        margin: EdgeInsets.all(5),
        color: Colors.grey[200],
        child: Center(
            child: _imageUrl != null
                ? Image.network(_imageUrl)
                : _image != null
                    ? kIsWeb
                        ? Image.network(_image.path)
                        : Image.file(_image)
                    : SizedBox.shrink()),
      ),
    );
  }
}

///多图片上传
class SelectImagesView extends StatefulWidget {
  SelectImagesView({Key key,
    this.index,
    this.imagesProvider
  }) : super(key: key);

  final int index;
  final ImagesProvider imagesProvider;

  @override
  _SelectImagesViewState createState() => _SelectImagesViewState();
}

class _SelectImagesViewState extends State<SelectImagesView> {

  final ImagePicker _picker = ImagePicker();

  Future<bool> _getImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        // getPutFile(pickedFile.path).then((val) async{
        //   var data = json.decode(val.toString());
        //   print('请求结果---uploadFile----$data');
        //   Provider.of<ImagesProvider>(context,listen: false).imagesList(pickedFile.path);
        // });

        Provider.of<ImagesProvider>(context,listen: false).imagesList(File(pickedFile.path));
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
          return Container(
            height: 180.0,
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text('拍照', textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.pop(context, ImageSource.camera);
                  },
                ),
                ListTile(
                  title: Text('从相册选择', textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.pop(context, ImageSource.gallery);
                  },
                ),
                ListTile(
                  title: Text('取消', textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    if(widget.index == widget.imagesProvider.filePath.length){
      return GestureDetector(
        child: Image.asset('assets/images/icon_add_images.png', width: 192, height: 108),
        onTap: () async{
          //show
          final source = await _showBottomSheet();
          //image
          if (source == null) return;
          final bool result = await _getImage(source);
          if (!result) return;
          setState(() {});
        },
      );
    }else{
      return Container(
          child: widget.imagesProvider.filePath.length > widget.index ?
          InkWell(
            child: Stack(
              children: <Widget>[
                Image.file(widget.imagesProvider.filePath[widget.index], width: 192, height: 108),
                Positioned(
                  right: 0,
                  child: InkWell(
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Image.asset('assets/images/icon_delete_images.png', width: 13, height: 13),
                    ),
                    onTap: (){
                      Provider.of<ImagesProvider>(context,listen: false).imagesListDelete(widget.index);
                    },
                  ),
                )
              ],
            ),
            onTap: (){
              Navigator.of(context).push(FadeRoute(page: PhotoViewGalleryScreen(
                images: widget.imagesProvider.filePath,//传入图片list
                index: widget.index,//传入当前点击的图片的index
                heroTag: 'simple',//传入当前点击的图片的hero tag （可选）
              )));
            },
          ) :
          Container()
      );
    }
  }
}

