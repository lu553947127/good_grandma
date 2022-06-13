import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio_log/dio_log.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/store.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/provider/image_provider.dart';
import 'package:good_grandma/widgets/photos_cell.dart';
import 'package:good_grandma/widgets/post_add_input_cell.dart';
import 'package:good_grandma/widgets/post_detail_group_title.dart';
import 'package:good_grandma/widgets/submit_btn.dart';
import 'package:provider/provider.dart';

///意见反馈
class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key key}) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  FocusNode _focusNode = FocusNode();
  TextEditingController _editingController = TextEditingController();
  ImagesProvider _imagesProvider = new ImagesProvider();
  Map _type = {};
  List<Map> _types = [];

  @override
  void initState() {
    super.initState();
    _getTypes();
  }

  _getTypes()async{
    requestGet(Api.feedbackType).then((value) {
      LogUtil.d('value = $value');
      var data = jsonDecode(value.toString());
      final List<dynamic> list = data['data'];
      list.forEach((element) {
        String dictKey = element['dictKey'];
        String dictValue = element['dictValue'];
        _types.add({'dictKey':dictKey,'dictValue':dictValue});
      });
      if(_types.isNotEmpty) setState(() => _type = _types.first);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(title: const Text('意见反馈')),
        body: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 13.0),
              sliver: SliverToBoxAdapter(
                child: Card(
                  child: PostAddInputCell(
                      title: '反馈类别',
                      value: _type.isNotEmpty?_type['dictValue']:'',
                      hintText: '请选择反馈类别',
                      endWidget: Icon(Icons.chevron_right, color: AppColors.FF2F4058),
                      onTap: () async{
                        List<String> typeNames = _types.map((e) => e['dictValue'].toString()).toList();
                        String result = await showPicker(typeNames, context);
                        if(result != null && result.isNotEmpty){
                          List<Map> list = _types.where((element) => element['dictValue'] == result).toList();
                          if(list.isNotEmpty)
                            setState(() => _type = list.first);
                        }
                  }),
                ),
              ),
            ),
            PostDetailGroupTitle(color: null, name: '意见反馈'),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 13.0),
              sliver: SliverToBoxAdapter(
                child: Card(
                  child: Container(
                    height: 150,
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: _editingController,
                      focusNode: _focusNode,
                      maxLines: 7,
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      autofocus: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(),
                        hintText: '',
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 13.0),
                sliver: SliverToBoxAdapter(
                  child: Card(
                    child: ChangeNotifierProvider<ImagesProvider>.value(
                        value: _imagesProvider,
                        child:  CustomPhotoWidget(
                            title: '上传图片',
                            length: 3,
                            sizeHeight: 10,
                            // bgColor: Colors.transparent,
                            url: Api.putFile
                        )
                    ),
                  ),
                )),
            SliverToBoxAdapter(
              child: SubmitBtn(
                title: '提  交',
                onPressed: () => _feedbackRequest(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _feedbackRequest(BuildContext context){
    if(_editingController.text == '6655887799'){
      LogUtil.d('监测到6655887799,出现日志弹框');
      if (debugBtnIsShow()) {
        //关闭日志显示
        dismissDebugBtn();
      } else {
        //打开日志显示
        showDebugBtn(context);
      }
      return;
    }
    if(_editingController.text == '909'){
      showDialog(
          context: context,
          builder: (context1) {
            return AlertDialog(
              title: const Text('提醒'),
              content: Text('您的手机品牌为：${Store.readBrand()}'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('取消', style: TextStyle(color: Color(0xFF999999)))),
                TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('确定', style: TextStyle(color: Color(0xFFC08A3F)))),
              ],
            );
          });
      return;
    }
    if(_type.isEmpty){
      AppUtil.showToastCenter('请选择反馈类别');
      return;
    }
    if(_editingController.text.isEmpty){
      AppUtil.showToastCenter('请填写反馈信息');
      return;
    }
    String images = '';
    if(_imagesProvider.urlList.isNotEmpty) {
      int  i = 0;
      _imagesProvider.urlList.forEach((imageURL) {
        images += imageURL;
        if(i < _imagesProvider.urlList.length - 1)
          images += ',';
        i++;
      });
    }
    Map param = {'content':_editingController.text,'imgs':images,'type':_type['dictKey']};
    requestPost(Api.feedback,json: jsonEncode(param)).then((value) {
      var data = jsonDecode(value.toString());
      if (data['code'] == 200) {
        AppUtil.showToastCenter('提交成功');
        Navigator.pop(context, true);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _editingController?.dispose();
    _focusNode?.dispose();
  }
}
