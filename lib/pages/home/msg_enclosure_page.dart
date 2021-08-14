import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';
import 'package:good_grandma/models/msg_list_model.dart';
import 'package:good_grandma/pages/home/pic_swiper_route.dart';
import 'package:good_grandma/widgets/submit_btn.dart';
import 'package:provider/provider.dart';

///附件详情
class MsgEnclosurePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Body();
}

class _Body extends State<MsgEnclosurePage> {
  TextEditingController _textEditingController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final MsgListModel model = Provider.of<MsgListModel>(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('查看附件')),
        body: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: TextButton(
                    onPressed:
                        model.enclosureURL == null || model.enclosureURL.isEmpty
                            ? null
                            : () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return PicSwiperRoute(
                                      index: 0, pics: [model.enclosureURL]);
                                }));
                              },
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(15.0)),
                    child: Container(
                      color: AppColors.FFC1C8D7,
                      child: MyCacheImageView(
                        width: double.infinity,
                        height: 196,
                        imageURL: model.enclosureURL ?? '',
                        errorWidgetChild: const Center(
                            child: Text(
                          '暂无资料',
                          style: TextStyle(fontSize: 24.0),
                        )),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  color: Colors.white,
                  // height: 125,
                  width: double.infinity,
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('反馈意见',
                          style: TextStyle(
                              color: AppColors.FF2F4058, fontSize: 14.0)),
                      TextField(
                        focusNode: _focusNode,
                        controller: _textEditingController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: '备注信息',
                          // 未获得焦点下划线
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          //获得焦点下划线
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SubmitBtn(
                  title: '提  交',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController?.dispose();
    _focusNode?.dispose();
  }
}
