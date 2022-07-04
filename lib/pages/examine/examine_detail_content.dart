import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/examine/examine_detail_content_form.dart';
import 'package:good_grandma/widgets/picture_big_view.dart';
import 'package:url_launcher/url_launcher.dart';

///审核详情自定义内容
class ExamineDetailContent extends StatelessWidget {
  final List taskFormList;
  final dynamic variables;
  ExamineDetailContent({Key key, this.taskFormList, this.variables}) : super(key: key);

  ///附件路径集合
  List<Map> fileList = [];
  ///图片路径集合
  List<Map> imagesList = [];
  ///显示附件组件集合
  List<Widget> _views = [];
  ///显示图片组件集合
  List<Widget> _views2 = [];
  ///支付对象信息表单集合
  List<Map> zhifuList = [];
  ///出差明细表单集合
  List<Map> chuchaiList = [];
  ///出差日程表单集合
  List<Map> chuchairichengList = [];
  ///试吃品列表集合
  List<Map> sampleList = [];
  ///费用列表集合
  List<Map> costList = [];

  ///用内置浏览器打开网页
  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      EasyLoading.showToast('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {

    if(variables['file'] != null && variables['file'].toString().isNotEmpty){
      fileList = (variables['file'] as List).cast();
      LogUtil.d('fileList----$fileList');
      for (Map file in fileList) {
        if(file['value'] != null) {
          String last = '';
          try {
            last = file['value'].split('.').last;
          } on Exception catch (e, s) {
            print(s);
          }

          List<String> imagesList = [];
          imagesList.add(file['value']);

          _views.add(last.toLowerCase() == 'jpg' ||
              last.toLowerCase() == 'jpeg' ||
              last.toLowerCase() == 'png' ||
              last.toLowerCase() == 'gif' ? InkWell(
              child: Container(
                  margin: EdgeInsets.only(top: 3),
                  child: MyCacheImageView(
                      imageURL: file['value'],
                      width: 112,
                      height: 63
                  )
              ),
              onTap: (){
                Navigator.of(context).push(FadeRoute(page: PhotoViewGalleryScreen(
                  images: imagesList,//传入图片list
                  index: 0,//传入当前点击的图片的index
                  heroTag: 'simple',//传入当前点击的图片的hero tag （可选）
                )));
              }
          ) :
          InkWell(
            child: Container(
              margin: EdgeInsets.only(top: 4.0, bottom: 4.0),
              height: 30,
                decoration: new BoxDecoration(
                    border: new Border.all(color: Color(0xFFEFEFF4), width: 0.6),
                    color: Colors.white,
                    borderRadius: new BorderRadius.circular((5.0))
                ),
              child: Container(
                  color: Color(0xFFFAFBFD),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(width: 240, margin: EdgeInsets.only(left: 5.0), child: Text('${file['label']}',
                          style: TextStyle(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis)),
                      Container(margin: EdgeInsets.only(right: 5.0), child: Image.asset('assets/images/icon_upload_file.png',
                          width: 15.0, height: 15.0))
                    ]
                  )
              )
            ),
            onTap: (){
              _launchURL(file['value']);
            }
          ));
        }else {
          _views.add(Text('数据显示异常'));
        }
      }
    }

    if(variables['biaodanfujian'] != null && variables['biaodanfujian'].toString().isNotEmpty){
      fileList = (variables['biaodanfujian'] as List).cast();
      LogUtil.d('fileList----$fileList');
      for (Map file in fileList) {
        if(file['value'] != null) {
          String last = '';
          try {
            last = file['value'].split('.').last;
          } on Exception catch (e, s) {
            print(s);
          }

          List<String> imagesList = [];
          imagesList.add(file['value']);

          _views.add(last.toLowerCase() == 'jpg' ||
              last.toLowerCase() == 'jpeg' ||
              last.toLowerCase() == 'png' ||
              last.toLowerCase() == 'gif' ? InkWell(
              child: Container(
                  margin: EdgeInsets.only(top: 3),
                  child: MyCacheImageView(
                      imageURL: file['value'],
                      width: 112,
                      height: 63
                  )
              ),
              onTap: (){
                Navigator.of(context).push(FadeRoute(page: PhotoViewGalleryScreen(
                  images: imagesList,//传入图片list
                  index: 0,//传入当前点击的图片的index
                  heroTag: 'simple',//传入当前点击的图片的hero tag （可选）
                )));
              }
          ) :
          InkWell(
            child: Container(
                margin: EdgeInsets.only(top: 4.0, bottom: 4.0),
                height: 30,
                decoration: new BoxDecoration(
                    border: new Border.all(color: Color(0xFFEFEFF4), width: 0.6),
                    color: Colors.white,
                    borderRadius: new BorderRadius.circular((5.0))
                ),
                child: Container(
                    color: Color(0xFFFAFBFD),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(width: 240, margin: EdgeInsets.only(left: 5.0), child: Text('${file['label']}',
                              style: TextStyle(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis)),
                          Container(margin: EdgeInsets.only(right: 5.0), child: Image.asset('assets/images/icon_upload_file.png',
                              width: 15.0, height: 15.0))
                        ]
                    )
                )
            ),
            onTap: (){
              _launchURL(file['value']);
            },
          ));
        }else {
          _views.add(Text('数据显示异常'));
        }
      }
    }

    if(variables['fujian'] != null && variables['fujian'].toString().isNotEmpty){
      fileList = (variables['fujian'] as List).cast();
      LogUtil.d('fileList----$fileList');
      for (Map file in fileList) {
        if(file['value'] != null) {
          String last = '';
          try {
            last = file['value'].split('.').last;
          } on Exception catch (e, s) {
            print(s);
          }

          List<String> imagesList = [];
          imagesList.add(file['value']);

          _views.add(last.toLowerCase() == 'jpg' ||
              last.toLowerCase() == 'jpeg' ||
              last.toLowerCase() == 'png' ||
              last.toLowerCase() == 'gif' ? InkWell(
              child: Container(
                  margin: EdgeInsets.only(top: 3),
                  child: MyCacheImageView(
                      imageURL: file['value'],
                      width: 112,
                      height: 63
                  )
              ),
              onTap: (){
                Navigator.of(context).push(FadeRoute(page: PhotoViewGalleryScreen(
                  images: imagesList,//传入图片list
                  index: 0,//传入当前点击的图片的index
                  heroTag: 'simple',//传入当前点击的图片的hero tag （可选）
                )));
              }
          ) :
          InkWell(
            child: Container(
                margin: EdgeInsets.only(top: 4.0, bottom: 4.0),
                height: 30,
                decoration: new BoxDecoration(
                    border: new Border.all(color: Color(0xFFEFEFF4), width: 0.6),
                    color: Colors.white,
                    borderRadius: new BorderRadius.circular((5.0))
                ),
                child: Container(
                    color: Color(0xFFFAFBFD),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(width: 240, margin: EdgeInsets.only(left: 5.0), child: Text('${file['label']}',
                              style: TextStyle(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis)),
                          Container(margin: EdgeInsets.only(right: 5.0), child: Image.asset('assets/images/icon_upload_file.png',
                              width: 15.0, height: 15.0))
                        ]
                    )
                )
            ),
            onTap: (){
              _launchURL(file['value']);
            },
          ));
        }else {
          _views.add(Text('数据显示异常'));
        }
      }
    }

    if(variables['1630552552652_12159'] != null && variables['1630552552652_12159'].toString().isNotEmpty){
      fileList = (variables['1630552552652_12159'] as List).cast();
      LogUtil.d('fileList----$fileList');
      for (Map file in fileList) {
        if(file['value'] != null) {
          String last = '';
          try {
            last = file['value'].split('.').last;
          } on Exception catch (e, s) {
            print(s);
          }

          List<String> imagesList = [];
          imagesList.add(file['value']);

          _views.add(last.toLowerCase() == 'jpg' ||
              last.toLowerCase() == 'jpeg' ||
              last.toLowerCase() == 'png' ||
              last.toLowerCase() == 'gif' ? InkWell(
              child: Container(
                  margin: EdgeInsets.only(top: 3),
                  child: MyCacheImageView(
                      imageURL: file['value'],
                      width: 112,
                      height: 63
                  )
              ),
              onTap: (){
                Navigator.of(context).push(FadeRoute(page: PhotoViewGalleryScreen(
                  images: imagesList,//传入图片list
                  index: 0,//传入当前点击的图片的index
                  heroTag: 'simple',//传入当前点击的图片的hero tag （可选）
                )));
              }
          ) :
          InkWell(
            child: Container(
                margin: EdgeInsets.only(top: 4.0, bottom: 4.0),
                height: 30,
                decoration: new BoxDecoration(
                    border: new Border.all(color: Color(0xFFEFEFF4), width: 0.6),
                    color: Colors.white,
                    borderRadius: new BorderRadius.circular((5.0))
                ),
                child: Container(
                    color: Color(0xFFFAFBFD),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(width: 240, margin: EdgeInsets.only(left: 5.0), child: Text('${file['label']}',
                              style: TextStyle(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis)),
                          Container(margin: EdgeInsets.only(right: 5.0), child: Image.asset('assets/images/icon_upload_file.png',
                              width: 15.0, height: 15.0))
                        ]
                    )
                )
            ),
            onTap: (){
              _launchURL(file['value']);
            },
          ));
        }else {
          _views.add(Text('数据显示异常'));
        }
      }
    }

    if(variables['tupian'] != null && variables['tupian'].toString().isNotEmpty){
      imagesList = (variables['tupian'] as List).cast();
      LogUtil.d('tupian----$imagesList');
      for (Map file in imagesList) {
        _views2.add(InkWell(
          child: Container(
              margin: EdgeInsets.only(top: 3),
              child: MyCacheImageView(
                  imageURL: file['value'],
                  width: 112,
                  height: 63
              )
          ),
          onTap: (){
            List<String> images = [];
            for (Map file in imagesList) {
              images.add(file['value']);
            }
            Navigator.of(context).push(FadeRoute(page: PhotoViewGalleryScreen(
              images: images,//传入图片list
              index: 0,//传入当前点击的图片的index
              heroTag: 'simple',//传入当前点击的图片的hero tag （可选）
            )));
          },
        ));
      }
    }

    if(variables['zhifuduixiangxinxi'] != null){
      zhifuList = (variables['zhifuduixiangxinxi'] as List).cast();

      LogUtil.d('zhifuList----$zhifuList');

      for(int i=0; i < taskFormList.length; i++) {
        if (taskFormList[i]['name'] == '单位名称'){
          taskFormList.removeAt(i);
        }
        if (taskFormList[i]['name'] == '账号'){
          taskFormList.removeAt(i);
        }
        if (taskFormList[i]['name'] == '开户行名称'){
          taskFormList.removeAt(i);
        }
        if (taskFormList[i]['name'] == '金额'){
          taskFormList.removeAt(i);
        }
        if (taskFormList[i]['name'] == '支付方式'){
          taskFormList.removeAt(i);
        }
        if (taskFormList[i]['name'] == '备注'){
          taskFormList.removeAt(i);
        }
      }

      LogUtil.d('taskFormList----$taskFormList');
    }

    if(variables['chuchaimingxi'] != null){
      chuchaiList = (variables['chuchaimingxi'] as List).cast();

      LogUtil.d('chuchaiList----$chuchaiList');

      for(int i=0; i < taskFormList.length; i++) {
        if (taskFormList[i]['name'] == '起止时间'){
          taskFormList.removeAt(i);
        }
        if (taskFormList[i]['name'] == '合计天数'){
          taskFormList.removeAt(i);
        }
        if (taskFormList[i]['name'] == '起止地点'){
          taskFormList.removeAt(i);
        }
        if (taskFormList[i]['name'] == '出差目的'){
          taskFormList.removeAt(i);
        }
        if (taskFormList[i]['name'] == '交通金额'){
          taskFormList.removeAt(i);
        }
        if (taskFormList[i]['name'] == '市内交通'){
          taskFormList.removeAt(i);
        }
        if (taskFormList[i]['name'] == '住宿金额'){
          taskFormList.removeAt(i);
        }
        if (taskFormList[i]['name'] == '补助金额'){
          taskFormList.removeAt(i);
        }
        if (taskFormList[i]['name'] == '其他金额'){
          taskFormList.removeAt(i);
        }
        if (taskFormList[i]['name'] == '备注'){
          taskFormList.removeAt(i);
        }
      }

      LogUtil.d('taskFormList----$taskFormList');
    }

    if(variables['chuchairicheng'] != null){
      chuchairichengList = (variables['chuchairicheng'] as List).cast();

      LogUtil.d('chuchairichengList----$chuchairichengList');

      for(int i=0; i < taskFormList.length; i++) {

        if (taskFormList[i]['name'] == '出发地'){
          taskFormList.removeAt(i);
        }
        if (taskFormList[i]['name'] == '目的地'){
          taskFormList.removeAt(i);
        }
        if (taskFormList[i]['name'] == '预计出差日期'){
          taskFormList.removeAt(i);
        }
      }

      LogUtil.d('taskFormList----$taskFormList');
    }

    if(variables['activityCosts'] != null){
      sampleList = (variables['activityCosts'] as List).cast();

      LogUtil.d('sampleList----$sampleList');

      for(int i=0; i < taskFormList.length; i++) {

        if (taskFormList[i]['name'] == '试吃品'){
          taskFormList.removeAt(i);
        }
        if (taskFormList[i]['name'] == '试吃品(箱)/数量'){
          taskFormList.removeAt(i);
        }
        if (taskFormList[i]['name'] == '现金(元)'){
          taskFormList.removeAt(i);
        }
        if (taskFormList[i]['name'] == '是否随货'){
          taskFormList.removeAt(i);
        }
      }
    }

    if(variables['activityCostList'] != null){
      costList = (variables['activityCostList'] as List).cast();

      LogUtil.d('costList----$costList');

      for(int i=0; i < taskFormList.length; i++) {

        if (taskFormList[i]['name'] == '费用类别'){
          taskFormList.removeAt(i);
        }
        if (taskFormList[i]['name'] == '使用描述'){
          taskFormList.removeAt(i);
        }
        if (taskFormList[i]['name'] == '现金(元)'){
          taskFormList.removeAt(i);
        }
      }
    }

    if(variables['deptId'] != null){
      for(int i=0; i < taskFormList.length; i++) {
        if (taskFormList[i]['name'] == '区域'){
          taskFormList.removeAt(i);
        }
      }
    }

    if(variables['customerId'] != null){
      for(int i=0; i < taskFormList.length; i++) {
        if (taskFormList[i]['name'] == '客户'){
          taskFormList.removeAt(i);
        }
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
                                          offstage: taskFormList[index]['name'] == '表单附件' ||
                                              taskFormList[index]['name'] == '附件' ||
                                              taskFormList[index]['name'] == '支付对象信息' ||
                                              taskFormList[index]['name'] == '系统附件' ||
                                              taskFormList[index]['name'] == '出差明细' ||
                                              taskFormList[index]['name'] == '图片' ||
                                              taskFormList[index]['name'] == '出差日程' ||
                                              taskFormList[index]['name'] == '试吃品' ||
                                              taskFormList[index]['name'] == '费用'?
                                          true : false,
                                          child: Text.rich(TextSpan(
                                              text: '${taskFormList[index]['name']}\n',
                                              style: const TextStyle(color: AppColors.FF959EB1, fontSize: 15.0),
                                              children: [
                                                TextSpan(
                                                    text: '${taskFormList[index]['value']}'.isEmpty ? '暂无' :
                                                    taskFormList[index]['name'] == '出差天数' ? '${formatNum(double.parse(taskFormList[index]['value'].toString()), 2)}' :
                                                    '${taskFormList[index]['value']}',
                                                    style: const TextStyle(fontSize: 15, color: AppColors.FF2F4058))
                                              ]
                                          ))
                                      ),
                                      Offstage(
                                          offstage: taskFormList[index]['name'] == '支付对象信息' ? false : true,
                                          child: Text(taskFormList[index]['name'], style: TextStyle(fontSize: 15, color: AppColors.FF959EB1))
                                      ),
                                      Offstage(
                                          offstage: taskFormList[index]['name'] == '支付对象信息' ? false : true,
                                          child: ExamineDetailContentForm(mapList: zhifuList, name: taskFormList[index]['name'])
                                      ),
                                      Offstage(
                                          offstage: taskFormList[index]['name'] == '出差明细' ? false : true,
                                          child: Text(taskFormList[index]['name'], style: TextStyle(fontSize: 15, color: AppColors.FF959EB1))
                                      ),
                                      Offstage(
                                          offstage: taskFormList[index]['name'] == '出差明细' ? false : true,
                                          child: ExamineDetailContentForm(mapList: chuchaiList, name: taskFormList[index]['name'])
                                      ),
                                      Offstage(
                                          offstage: taskFormList[index]['name'] == '出差日程' ? false : true,
                                          child: Text(taskFormList[index]['name'], style: TextStyle(fontSize: 15, color: AppColors.FF959EB1))
                                      ),
                                      Offstage(
                                          offstage: taskFormList[index]['name'] == '出差日程' ? false : true,
                                          child: ExamineDetailContentForm(mapList: chuchairichengList, name: taskFormList[index]['name'])
                                      ),
                                      Offstage(
                                          offstage: taskFormList[index]['name'] == '试吃品' ? false : true,
                                          child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(taskFormList[index]['name'], style: TextStyle(fontSize: 15, color: AppColors.FF959EB1)),
                                                SizedBox(width: 5),
                                                sampleList.length != 0 ?
                                                Expanded(
                                                    child: ListView.builder(
                                                        shrinkWrap:true,//范围内进行包裹（内容多高ListView就多高）
                                                        physics:NeverScrollableScrollPhysics(),//禁用滑动事件
                                                        itemCount: sampleList.length,
                                                        itemBuilder: (content, index){
                                                          return Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text.rich(TextSpan(text: '试吃品   ', children: [TextSpan(text: '${sampleList[index]['materialName']}')])),
                                                              Text.rich(TextSpan(text: '试吃品(箱)/数量   ', children: [TextSpan(text: '${sampleList[index]['sample']}')])),
                                                              Text.rich(TextSpan(text: '现金(元)   ', children: [TextSpan(text: '${sampleList[index]['costCash']}')])),
                                                              Text.rich(TextSpan(text: '是否随货   ', children: [TextSpan(text: sampleList[index]['withGoods'] == 1 ? '是' : '否')])),
                                                            ]
                                                          );
                                                        }
                                                    )
                                                ) :
                                                Text('暂无', style: TextStyle(fontSize: 15, color: AppColors.FF2F4058))
                                              ]
                                          )
                                      ),
                                      Offstage(
                                          offstage: taskFormList[index]['name'] == '费用' ? false : true,
                                          child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(taskFormList[index]['name'], style: TextStyle(fontSize: 15, color: AppColors.FF959EB1)),
                                                SizedBox(width: 5),
                                                costList.length != 0 ?
                                                Expanded(
                                                    child: ListView.builder(
                                                        shrinkWrap:true,//范围内进行包裹（内容多高ListView就多高）
                                                        physics:NeverScrollableScrollPhysics(),//禁用滑动事件
                                                        itemCount: costList.length,
                                                        itemBuilder: (content, index){
                                                          return Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text.rich(TextSpan(text: '费用类别   ', children: [TextSpan(text: '${costList[index]['costTypeName']}')])),
                                                                Text.rich(TextSpan(text: '使用描述   ', children: [TextSpan(text: '${costList[index]['costDescribe']}')])),
                                                                Text.rich(TextSpan(text: '现金(元)   ', children: [TextSpan(text: '${costList[index]['costCash']}')]))
                                                              ]
                                                          );
                                                        }
                                                    )
                                                ) :
                                                Text('暂无', style: TextStyle(fontSize: 15, color: AppColors.FF2F4058))
                                              ]
                                          )
                                      ),
                                      Offstage(
                                          offstage: (taskFormList[index]['name'] == '表单附件' || taskFormList[index]['name'] == '附件') ? false : true,
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(taskFormList[index]['name'], style: TextStyle(fontSize: 15, color: AppColors.FF959EB1)),
                                                SizedBox(width: 10),
                                                fileList.length != 0 ?
                                                Column(crossAxisAlignment: CrossAxisAlignment.start, children: _views) :
                                                Text('暂无附件', style: TextStyle(fontSize: 15, color: AppColors.FF2F4058))
                                              ]
                                          )
                                      ),
                                      Offstage(
                                          offstage: (taskFormList[index]['name'] == '图片') ? false : true,
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(taskFormList[index]['name'], style: TextStyle(fontSize: 15, color: AppColors.FF959EB1)),
                                                SizedBox(width: 10),
                                                imagesList.length != 0 ?
                                                Column(crossAxisAlignment: CrossAxisAlignment.start, children: _views2) :
                                                Text('暂无附件', style: TextStyle(fontSize: 15, color: AppColors.FF2F4058))
                                              ]
                                          )
                                      )
                                    ]
                                )
                            );
                          }
                      )
                    ]
                )
            )
        )
    );
  }
}