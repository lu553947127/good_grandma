import 'package:flutter/material.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/marketing_activity_model.dart';
import 'package:good_grandma/widgets/activity_add_text_cell.dart';
import 'package:good_grandma/widgets/marketing_activity_detail_title.dart';
import 'package:good_grandma/widgets/post_detail_group_title.dart';
import 'package:good_grandma/widgets/submit_btn.dart';

///编辑活动收益
class EditActivityProfitPage extends StatefulWidget {
  const EditActivityProfitPage(
      {Key key,
        @required this.model,
        @required this.state,
        @required this.stateColor})
      : super(key: key);
  final MarketingActivityModel model;
  final String state;
  final Color stateColor;

  @override
  _EditActivityProfitPageState createState() => _EditActivityProfitPageState();
}

class _EditActivityProfitPageState extends State<EditActivityProfitPage> {
  final TextEditingController _editingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => AppUtil.onWillPop(context),
      child: Scaffold(
          appBar: AppBar(title: const Text('编辑活动收益')),
          body: Scrollbar(
              child: CustomScrollView(
                slivers: [
                  MarketingActivityDetailTitle(
                      model: widget.model,
                      state: widget.state,
                      stateColor: widget.stateColor,
                      showTime: false),
                  PostDetailGroupTitle(color: null, name: '活动收益'),
                  SliverToBoxAdapter(
                    child: ActivityAddTextCell(
                      title: '活动收益',
                      hintText: '请输入金额',
                      value: widget.model.budgetCurrent,
                      trailing: Text('元'),
                      onTap: () => AppUtil.showInputDialog(
                          context: context,
                          editingController: _editingController,
                          focusNode: _focusNode,
                          text: widget.model.budgetCurrent,
                          hintText: '请输入金额',
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          callBack: (text) {

                          }),
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
