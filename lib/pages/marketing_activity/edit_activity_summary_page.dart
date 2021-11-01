import 'package:flutter/material.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/marketing_activity_model.dart';
import 'package:good_grandma/provider/image_provider.dart';
import 'package:good_grandma/widgets/add_content_input.dart';
import 'package:good_grandma/widgets/marketing_activity_detail_title.dart';
import 'package:good_grandma/widgets/photos_cell.dart';
import 'package:good_grandma/widgets/post_detail_group_title.dart';
import 'package:good_grandma/widgets/submit_btn.dart';
import 'package:provider/provider.dart';

///编辑总结描述
class EditActivitySummaryPage extends StatefulWidget {
  const EditActivitySummaryPage(
      {Key key,
      @required this.model,
      @required this.state,
      @required this.stateColor})
      : super(key: key);
  final MarketingActivityModel model;
  final String state;
  final Color stateColor;

  @override
  _EditActivitySummaryPageState createState() =>
      _EditActivitySummaryPageState();
}

class _EditActivitySummaryPageState extends State<EditActivitySummaryPage> {
  final TextEditingController _editingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    ImagesProvider imagesProvider = new ImagesProvider();
    return WillPopScope(
      onWillPop: () => AppUtil.onWillPop(context),
      child: Scaffold(
          appBar: AppBar(title: const Text('编辑总结描述')),
          body: Scrollbar(
              child: CustomScrollView(
            slivers: [
              MarketingActivityDetailTitle(
                  model: widget.model,
                  state: widget.state,
                  stateColor: widget.stateColor,
                  showTime: false),
              PostDetailGroupTitle(color: null, name: '总结描述'),
              // SliverToBoxAdapter(
              //   child: SizedBox(
              //     child: ChangeNotifierProvider<ImagesProvider>.value(
              //       value: imagesProvider,
              //       child: CustomPhotoWidget(
              //         title: '上传照片',
              //         length: 3,
              //         sizeHeight: 10,
              //       ),
              //     ),
              //   ),
              // ),
              SliverToBoxAdapter(
                child: ContentInputView(
                  sizeHeight: 10,
                  color: Colors.white,
                  leftTitle: '活动总结',
                  rightPlaceholder: '请输入活动总结',
                  onChanged: (tex) {},
                ),
              ),
              SliverToBoxAdapter(
                child: SubmitBtn(
                  title: '提  交',
                  onPressed: () {},
                ),
              )
            ],
          ))),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _editingController.dispose();
  }
}
