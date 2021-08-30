import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/pages/contract/signature_page.dart';
import 'package:good_grandma/widgets/contract_content_title.dart';
import 'package:good_grandma/widgets/submit_btn.dart';

class ContractSignPage extends StatefulWidget {
  const ContractSignPage({
    Key key,
    @required this.title,
    @required this.id,
  }) : super(key: key);
  final String title;
  final String id;
  @override
  State<StatefulWidget> createState() => _Body();
}

class _Body extends State<ContractSignPage> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();
  Uint8List _imageData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('签署合同'),
        ),
        body: Scrollbar(
          child: CustomScrollView(
            slivers: [
              ContractContentTitle(title: widget.title),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: const Text(
                    '签署意见',
                    style: TextStyle(color: AppColors.FF2F4058, fontSize: 12.0),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      focusNode: _focusNode,
                      controller: _textEditingController,
                      maxLines: 10,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        hintText: '请填写签署意见',
                        hintStyle: const TextStyle(
                            color: AppColors.FFC1C8D7, fontSize: 12.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30 / 2),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(15.0),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: const Text(
                          '签名',
                          style: TextStyle(
                              color: AppColors.FF2F4058, fontSize: 12.0)
                        ),
                      ),
                      _imageData != null
                          ?Image.memory(_imageData,height: 35,fit: BoxFit.fitHeight)
                      : Container(),
                      Spacer(),
                      TextButton(
                          onPressed: () async{
                            Uint8List imageData = await Navigator.push(context, MaterialPageRoute(builder: (_) => SignaturePage()));
                            if(imageData != null){
                              setState(() => _imageData = imageData);
                            }
                          },
                          style: TextButton.styleFrom(backgroundColor: AppColors.FFC08A3F),
                          child: const Text(
                            '签名',
                            style: TextStyle(
                                color: Colors.white, fontSize: 12.0),
                          )),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SubmitBtn(title: '确定', onPressed: (){}),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode?.dispose();
    _textEditingController?.dispose();
    _imageData = null;
  }
}
