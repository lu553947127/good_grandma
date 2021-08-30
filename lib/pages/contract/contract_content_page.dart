import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/pages/contract/contract_sign_page.dart';
import 'package:good_grandma/widgets/contract_content_title.dart';
import 'package:good_grandma/widgets/smscode_dialog.dart';
import 'package:good_grandma/widgets/submit_btn.dart';

///合同内容
class ContractContentPage extends StatefulWidget {
  const ContractContentPage({Key key, @required this.id}) : super(key: key);
  final String id;

  @override
  _ContractContentPageState createState() => _ContractContentPageState();
}

class _ContractContentPageState extends State<ContractContentPage> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode2 = FocusNode();
  final TextEditingController _textEditingController2 = TextEditingController();
  String _title = '';
  bool _signed = false;
  String _content = '';

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('合同内容')),
      body: Scrollbar(
        child: CustomScrollView(
          slivers: [
            ContractContentTitle(title: _title),
            SliverSafeArea(
              sliver: SliverToBoxAdapter(
                child: ListTile(
                  title: Text(_content * 10,style: const TextStyle(color: AppColors.FF2F4058,fontSize: 14.0),),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: !_signed,
        child: SafeArea(
          child: SubmitBtn(title: '签署', onPressed: () {
            _showDialog(context);
          }),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) async {
    bool result = await showDialog(
        context: context,
        builder: (context) {
          return SMSCodeDialog(
            focusNode: _focusNode,
            editingController: _textEditingController,
            focusNode2: _focusNode2,
            editingController2: _textEditingController2,
            submitBtnOnTap: () {
              ///网络请求后
              Navigator.pop(context, true);
            },
          );
        });
    if (result != null && result) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ContractSignPage(title: _title, id: widget.id)));
    }
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    _title = '合同名称合同名称合同名称合合同名称合同名称合同名称合合同名称合同名称合同名称合';
    _signed = false;
    _content =
        '合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容合同内容';
    if (mounted) setState(() {});
  }
  @override
  void dispose() {
    super.dispose();
    _focusNode?.dispose();
    _textEditingController?.dispose();
    _focusNode2?.dispose();
    _textEditingController2?.dispose();
  }
}

