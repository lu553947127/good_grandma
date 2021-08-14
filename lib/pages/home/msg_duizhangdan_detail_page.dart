import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/models/msg_list_model.dart';
import 'package:good_grandma/pages/home/msg_enclosure_page.dart';
import 'package:good_grandma/widgets/msg_detail_cell_content.dart';
import 'package:good_grandma/widgets/smscode_dialog.dart';
import 'package:provider/provider.dart';

///对账单详细
class MsgDuiZhangDanDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Body();
}

class _Body extends State<MsgDuiZhangDanDetailPage> {
  TextEditingController _textEditingController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  TextEditingController _textEditingController2 = TextEditingController();
  FocusNode _focusNode2 = FocusNode();

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final MsgListModel model = Provider.of<MsgListModel>(context);
    return Scaffold(
      appBar: AppBar(title: Text('对账单详细')),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                //顶部信息
                MsgDetailCellContent(model: model),
                SizedBox(height: 10.0),
                //附件信息
                Visibility(
                  visible: model.enclosureName != null ||
                      model.enclosureName.isNotEmpty,
                  child: Container(
                    color: Colors.white,
                    child: ListTile(
                      leading: Image.asset('assets/images/msg_enclosure.png',
                          width: 30, height: 30),
                      title: Text(model.enclosureName ?? '',
                          style: const TextStyle(
                              color: AppColors.FF2F4058, fontSize: 14.0)),
                      subtitle: Text(model.enclosureSize ?? '',
                          style: const TextStyle(
                              color: AppColors.FFC1C8D7, fontSize: 11.0)),
                      trailing: SizedBox(
                        width: 73,
                        height: 40,
                        child: TextButton(
                            onPressed: () {
                              _showDialog(context);
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  model.sign
                                      ? 'assets/images/msg_sign.png'
                                      : 'assets/images/msg_unsign.png',
                                  width: 12,
                                  height: 12,
                                ),
                                Text(
                                  model.sign ? '  已签署  ' : '  未签署  ',
                                  style: TextStyle(
                                      color: model.sign
                                          ? AppColors.FFC08A3F
                                          : AppColors.FF2F4058,
                                      fontSize: 11),
                                ),
                              ],
                            )),
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ChangeNotifierProvider<MsgListModel>.value(
                            value: model,
                            child: MsgEnclosurePage(),
                          );
                        }));
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return SMSCodeDialog(
            focusNode: _focusNode,
            editingController: _textEditingController,
            focusNode2: _focusNode2,
            editingController2: _textEditingController2,
            submitBtnOnTap: (){
              Navigator.pop(context);
            },
          );
        });
  }

  void _refresh() {}

  @override
  void dispose() {
    super.dispose();
    _textEditingController?.dispose();
    _focusNode?.dispose();
    _textEditingController2?.dispose();
    _focusNode2?.dispose();
  }
}
