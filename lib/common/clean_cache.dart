import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
class CleanCache{
  ///得到缓存结果
  static Future<String> loadCache() async {
    Directory tempDir = await getTemporaryDirectory();
    double value = await _getTotalSizeOfFilesInDir(tempDir);
    /*tempDir.list(followLinks: false,recursive: true).listen((file){
          //打印每个缓存文件的路径
        print(file.path);
      });*/
    // print('临时目录大小: ' + value.toString());
    return  renderSize(value);
  }
  ///清除缓存
  static Future<String> cleanCache()async{
    PaintingBinding.instance.imageCache.clear();
    Directory tempDir = await getTemporaryDirectory();
    try {
      await _delDir(tempDir);
    }
    catch(error){
      print(error);
    }
    return loadCache();
  }

  // 循环计算文件的大小（递归）
  static Future<double> _getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    if (file is File) {
      int length = await file.length();
      return double.parse(length.toString());
    }
    if (file is Directory) {
      try {
        final List<FileSystemEntity> children = file.listSync();
        double total = 0;
        if (children != null)
          for (final FileSystemEntity child in children)
            total += await _getTotalSizeOfFilesInDir(child);
        return total;
      }
      catch(error){
        print('error = $error');
      }
    }
    return 0;
  }

  // 递归方式删除目录
  static Future<Null> _delDir(FileSystemEntity file) async {
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      for (final FileSystemEntity child in children) {
        await _delDir(child);
      }
    }
    try {
      await file.delete();
    }
    catch(error){
      print('file.delete error = $error');
    }
  }
  // 计算大小
  static renderSize(double value) {
    if (null == value) {
      return 0;
    }
    List<String> unitArr = []
      ..add('B')
      ..add('K')
      ..add('M')
      ..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    if (size ==  '0.00'){
      return '0M';
    }
    // print('size:${size == 0}\n ==SIZE${size}');
    return size + unitArr[index];
  }
}