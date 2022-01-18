import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/application.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/pages/login/loginBtn.dart';
import 'package:good_grandma/provider/image_provider.dart';
import 'package:good_grandma/widgets/add_content_input.dart';
import 'package:good_grandma/widgets/photos_cell.dart';
import 'package:good_grandma/widgets/post_add_input_cell.dart';
import 'package:provider/provider.dart';

///客户拜访编辑
class CustomerVisitEdit extends StatefulWidget {
  final dynamic data;
  CustomerVisitEdit({Key key, this.data}) : super(key: key);

  @override
  _CustomerVisitEditState createState() => _CustomerVisitEditState();
}

class _CustomerVisitEditState extends State<CustomerVisitEdit> {
  ImagesProvider imagesProvider = new ImagesProvider();
  TextEditingController controller = new TextEditingController();
  String visitContent = '';
  String images = '';
  String address = '';

  ///编辑
  _customerVisitEdit(){

    if (visitContent == ''){
      showToast('行动过程不能为空');
      return;
    }

    if (imagesProvider.urlList.length != 0){
      images = listToString(imagesProvider.urlList);
    }

    if (images == ''){
      showToast('拜访图片不能为空');
      return;
    }

    Map<String, dynamic> map = {
      'id': widget.data['id'],
      'status': '2',
      'visitContent': visitContent,
      'ipicture': images
    };

    LogUtil.d('请求结果---customerVisitAdd----$map');

    requestPost(Api.customerVisitEdit, json: map).then((val) async{
      var data = json.decode(val.toString());
      LogUtil.d('请求结果---customerVisitEdit----$data');
      if (data['code'] == 200){
        showToast("拜访结束");
        Navigator.pop(context, true);
      }else {
        showToast(data['msg']);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    controller.text = widget.data['visitContent'];
    visitContent = widget.data['visitContent'];
    address = widget.data['address'];
    List<String> ipictures = (widget.data['ipictures'] as List).cast();
    ipictures.forEach((element) {
      imagesProvider.fileList(element, 'png', '');
      imagesProvider.addImageData(element, '');
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('客户拜访编辑')),
        body: SingleChildScrollView(
            child: Column(
                children: [
                  PostAddInputCell(
                      title: '客户名称',
                      value: widget.data['customerName'],
                      hintText: '',
                      endWidget: null,
                      onTap: null
                  ),
                  PostAddInputCell(
                      title: '客户类型',
                      value: widget.data['customerTypeName'],
                      hintText: '',
                      endWidget: null,
                      onTap: null
                  ),
                  ContentInputView(
                      controller: controller,
                      sizeHeight: 10,
                      color: Colors.white,
                      leftTitle: '行动过程',
                      rightPlaceholder: '行动过程',
                      onChanged: (tex){
                        visitContent = tex;
                      }
                  ),
                  ChangeNotifierProvider<ImagesProvider>.value(
                      value: imagesProvider,
                      child:  CustomPhotoWidget(
                          title: '拜访图片',
                          length: 3,
                          sizeHeight: 10,
                          url: Api.putFile,
                          address: address
                      )
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 10, top: 10),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset('assets/images/icon_address.png', width: 12, height: 12),
                            SizedBox(width: 3),
                            Container(
                              width: 300,
                              child: Text(widget.data['address'], style: TextStyle(fontSize: 12, color: Color(0XFF2F4058))),
                            )
                          ]
                      )
                  ),
                  Padding(
                      padding: EdgeInsets.all(20),
                      child: LoginBtn(
                          title: '提交',
                          onPressed: _customerVisitEdit
                      )
                  )
                ]
            )
        )
    );
  }
}
