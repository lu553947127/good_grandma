import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';
import 'package:good_grandma/widgets/picture_big_view.dart';

///审核详情自定义内容
class ExamineDetailContent extends StatelessWidget {
  final List taskFormList;
  var variables;
  ExamineDetailContent({Key key, this.taskFormList, this.variables}) : super(key: key);

  ///附件路径集合
  List<Map> fileList = [];
  ///显示图片组件集合
  List<Widget> _views = [];

  @override
  Widget build(BuildContext context) {

    if(variables['file'] != null){
      fileList = (variables['file'] as List).cast();
      LogUtil.d('fileList----$fileList');

      for (Map file in fileList) {
        _views.add(InkWell(
          child: Container(
            margin: EdgeInsets.only(top: 3),
            child: MyCacheImageView(
                imageURL: file['value'],
                width: 112,
                height: 63
            )
          ),
          onTap: (){
            List<String> imagesList = [];
            for (Map file in fileList) {
              imagesList.add(file['value']);
            }

            Navigator.of(context).push(FadeRoute(page: PhotoViewGalleryScreen(
              images: imagesList,//传入图片list
              index: 0,//传入当前点击的图片的index
              heroTag: 'simple',//传入当前点击的图片的hero tag （可选）
            )));
          },
        ));
      }
    }

    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(left: 15.0, right: 15.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0)),
            boxShadow: [
              BoxShadow(
                  offset: Offset(2, 1), //x,y轴
                  color: Colors.black.withOpacity(0.1), //投影颜色
                  blurRadius: 1 //投影距离
              )
            ]),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap:true,//范围内进行包裹（内容多高ListView就多高）
                physics:NeverScrollableScrollPhysics(),//禁用滑动事件
                itemCount: taskFormList.length,
                itemBuilder: (content, index){
                  return Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Offstage(
                            offstage: taskFormList[index]['name'] == '表单附件' ? true : false,
                            child: Text.rich(TextSpan(
                                text: '${taskFormList[index]['name']}   ',
                                style: const TextStyle(color: AppColors.FF959EB1, fontSize: 15.0),
                                children: [
                                  TextSpan(
                                      text: taskFormList[index]['value'].isEmpty ? '暂无' : taskFormList[index]['value'],
                                      style: const TextStyle(fontSize: 15, color: AppColors.FF2F4058))
                                ]
                            ))
                        ),
                        Offstage(
                            offstage: taskFormList[index]['name'] == '表单附件' ? false : true,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(taskFormList[index]['name'], style: TextStyle(fontSize: 15, color: AppColors.FF959EB1)),
                                SizedBox(width: 10),
                                fileList.length != 0 ?
                                Column(children: _views) :
                                Text('暂无附件', style: TextStyle(fontSize: 15, color: AppColors.FF2F4058))
                              ]
                            )
                        )
                      ]
                    )
                  );
                },
              )
            ],
          )
        )
      ),
    );
  }
}