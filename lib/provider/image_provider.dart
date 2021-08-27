import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';

class ImagesProvider with ChangeNotifier{

  ///图片地址
  var imgPath;
  ///图片地址结合
  List<File> filePath = [];

  //选择图片集合
  imagesList(File image) async{
    filePath.add(image);
    notifyListeners();
  }

  //选择图片集合删除
  imagesListDelete(int index) async{
    if(filePath.length > 0){
      filePath.removeAt(index);
      notifyListeners();
    }
  }
}