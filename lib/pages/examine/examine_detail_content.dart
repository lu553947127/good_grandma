import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';
import 'package:good_grandma/widgets/picture_big_view.dart';

///审核详情自定义内容
class ExamineDetailContent extends StatelessWidget {
  final List taskFormList;
  final dynamic variables;
  ExamineDetailContent({Key key, this.taskFormList, this.variables}) : super(key: key);

  ///附件路径集合
  List<Map> fileList = [];
  ///显示图片组件集合
  List<Widget> _views = [];
  ///支付对象信息表单集合
  List<Map> zhifuList = [];
  ///出差明细表单集合
  List<Map> chuchaiList = [];
  ///出差日程表单集合
  List<Map> chuchairichengList = [];

  double numRowWidth = 100.0;//单个表宽
  double numRowHeight = 48.0;//表格高

  ///创建一个表单
  Widget _buildChart(List<Map> goodsList, name) {
    return Container(
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            child: Table(children: _buildTableRow(goodsList, name)),
            width: numRowWidth * 10,
          )
      ),
    );
  }

  ///创建tableRows
  List<TableRow> _buildTableRow(List<Map> goodsList, name) {
    List<TableRow> returnList = new List();
    if (name == '支付对象信息'){
      returnList.add(_buildSingleRow2(-1, goodsList));
      for (int i = 0; i < goodsList.length; i++) {
        returnList.add(_buildSingleRow2(i, goodsList));
      }
    }else if (name == '出差明细'){
      returnList.add(_buildSingleRow(-1, goodsList));
      for (int i = 0; i < goodsList.length; i++) {
        returnList.add(_buildSingleRow(i, goodsList));
      }
    }else if (name == '出差日程'){
      returnList.add(_buildSingleRow3(-1, goodsList));
      for (int i = 0; i < goodsList.length; i++) {
        returnList.add(_buildSingleRow3(i, goodsList));
      }
    }
    return returnList;
  }

  ///创建一行tableRow
  TableRow _buildSingleRow(int index, List<Map> goodsList) {
    return TableRow(
      //第一行样式 添加背景色
        children: [
          _buildSideBox(index == -1 ? '起止时间' : goodsList[index]['qizhishijian'].toString(), index == -1),
          _buildSideBox(index == -1 ? '合计天数' : goodsList[index]['days'].toString(), index == -1),
          _buildSideBox(index == -1 ? '起止地点' : goodsList[index]['qizhididian'].toString(), index == -1),
          _buildSideBox(index == -1 ? '出差目的' : goodsList[index]['chuchaimudi'].toString(), index == -1),
          _buildSideBox(index == -1 ? '交通金额' : goodsList[index]['jiaotongjine'].toString(), index == -1),
          _buildSideBox(index == -1 ? '市内交通' : goodsList[index]['shineijiaotong'].toString(), index == -1),
          _buildSideBox(index == -1 ? '住宿金额' : goodsList[index]['zhusujine'].toString(), index == -1),
          _buildSideBox(index == -1 ? '补助金额' : goodsList[index]['buzhujine'].toString(), index == -1),
          _buildSideBox(index == -1 ? '备注' : goodsList[index]['beizhu'].toString(), index == -1),
        ]);
  }

  TableRow _buildSingleRow2(int index, List<Map> goodsList) {
    return TableRow(
      //第一行样式 添加背景色
        children: [
          _buildSideBox(index == -1 ? '单位名称' : goodsList[index]['danweimingcheng'].toString(), index == -1),
          _buildSideBox(index == -1 ? '账号' : goodsList[index]['zhanghao'].toString(), index == -1),
          _buildSideBox(index == -1 ? '开户行名称' : goodsList[index]['kaihuhangmingcheng'].toString(), index == -1),
          _buildSideBox(index == -1 ? '金额' : goodsList[index]['jine'].toString(), index == -1),
          _buildSideBox(index == -1 ? '支付方式' : goodsList[index]['zhifufangshi'].toString(), index == -1),
          _buildSideBox(index == -1 ? '预计支付时间' : goodsList[index]['yujizhifushijian'].toString(), index == -1),
        ]);
  }

  TableRow _buildSingleRow3(int index, List<Map> goodsList) {
    return TableRow(
      //第一行样式 添加背景色
        children: [
          _buildSideBox(index == -1 ? '出发地' : goodsList[index]['chufadi'].toString(), index == -1),
          _buildSideBox(index == -1 ? '目的地' : goodsList[index]['mudidi'].toString(), index == -1),
          _buildSideBox(index == -1 ? '预计出差日期' : goodsList[index]['yujichuchairiqi'].toString(), index == -1),
          _buildSideBox(index == -1 ? '出差天数' : goodsList[index]['days'].toString(), index == -1),
        ]);
  }

  ///创建单个表格
  Widget _buildSideBox(String title, isTitle) {
    return SizedBox(
        height: numRowHeight,
        width: numRowWidth,
        child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 0.33, color: AppColors.FFC1C8D7))),
            child: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: isTitle ? 15 : 13, color: AppColors.FF2F4058))
        )
    );
  }

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

    if(variables['biaodanfujian'] != null){
      fileList = (variables['biaodanfujian'] as List).cast();
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

    if(variables['fujian'] != null){
      fileList = (variables['fujian'] as List).cast();
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
        if (taskFormList[i]['name'] == '预计支付时间'){
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
        if (taskFormList[i]['name'] == '出差天数'){
          taskFormList.removeAt(i);
        }
      }

      LogUtil.d('taskFormList----$taskFormList');
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
                                taskFormList[index]['name'] == '出差日程'?
                            true : false,
                            child: Text.rich(TextSpan(
                                text: '${taskFormList[index]['name']}   ',
                                style: const TextStyle(color: AppColors.FF959EB1, fontSize: 15.0),
                                children: [
                                  TextSpan(
                                      text: '${taskFormList[index]['value']}'.isEmpty ? '暂无' : '${taskFormList[index]['value']}',
                                      style: const TextStyle(fontSize: 15, color: AppColors.FF2F4058))
                                ]
                            ))
                        ),
                        Offstage(
                          offstage: taskFormList[index]['name'] == '支付对象信息' ? false : true,
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(taskFormList[index]['name'], style: TextStyle(fontSize: 15, color: AppColors.FF959EB1)),
                                SizedBox(width: 5),
                                zhifuList.length != 0 ?
                                Expanded(child: _buildChart(zhifuList, taskFormList[index]['name'])) :
                                Text('暂无', style: TextStyle(fontSize: 15, color: AppColors.FF2F4058))
                              ]
                          )
                        ),
                        Offstage(
                            offstage: taskFormList[index]['name'] == '出差明细' ? false : true,
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(taskFormList[index]['name'], style: TextStyle(fontSize: 15, color: AppColors.FF959EB1)),
                                  SizedBox(width: 5),
                                  chuchaiList.length != 0 ?
                                  Expanded(child: _buildChart(chuchaiList, taskFormList[index]['name'])) :
                                  Text('暂无', style: TextStyle(fontSize: 15, color: AppColors.FF2F4058))
                                ]
                            )
                        ),
                        Offstage(
                            offstage: taskFormList[index]['name'] == '出差日程' ? false : true,
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(taskFormList[index]['name'], style: TextStyle(fontSize: 15, color: AppColors.FF959EB1)),
                                  SizedBox(width: 5),
                                  chuchairichengList.length != 0 ?
                                  Expanded(child: _buildChart(chuchairichengList, taskFormList[index]['name'])) :
                                  Text('暂无', style: TextStyle(fontSize: 15, color: AppColors.FF2F4058))
                                ]
                            )
                        ),
                        Offstage(
                            offstage: (taskFormList[index]['name'] == '表单附件' || taskFormList[index]['name'] == '附件') ? false : true,
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
                }
              )
            ]
          )
        )
      )
    );
  }
}