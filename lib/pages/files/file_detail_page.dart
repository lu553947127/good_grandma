import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/models/file_model.dart';

///详细信息
class FileDetailPage extends StatelessWidget {
  const FileDetailPage({Key key,@required this.fileModel}) : super(key: key);
  final FileModel fileModel;

  @override
  Widget build(BuildContext context) {
    List<Map> list = [
      {'title':'文件大小','value':fileModel.sizeString},
      {'title':'创建者','value':fileModel.author},
      {'title':'创建时间','value':fileModel.createTime},
      {'title':'最新修改','value':fileModel.updateTime},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('详细信息')),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(30.0),
              child: Row(
                children: [
                  Image.asset(fileModel.iconName,width: 25,height: 25),
                  SizedBox(width: 10.0),
                  Expanded(child: Text(fileModel.name)),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10.0),
            sliver: SliverToBoxAdapter(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: List.generate(list.length, (index) => ListTile(
                      title: Text(list[index]['title'],style: const TextStyle(color: AppColors.FF959EB1,fontSize: 12.0)),
                      subtitle: Text(list[index]['value'],style: const TextStyle(color: AppColors.FF2F4058,fontSize: 14.0)),
                    )),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
