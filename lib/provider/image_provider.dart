import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';

///图片上传
class ImagesProvider with ChangeNotifier{

  ///图片地址
  var imgPath;
  ///图片地址结合
  List<String> filePath = [];
  ///map图片集合
  List<Map> imagePath = [];

  //选择图片集合
  imagesList(String image) async{
    filePath.add(image);
    notifyListeners();
  }

  //生成接口添加的数据
  addImageData(images, name) async{
    Map addData = new Map();
    addData['label'] = name;
    addData['value'] = images;
    imagePath.add(addData);
    notifyListeners();
  }

  //选择图片集合删除
  imagesListDelete(int index) async{
    if(filePath.length > 0){
      filePath.removeAt(index);
      imagePath.removeAt(index);
      notifyListeners();
    }
  }
}