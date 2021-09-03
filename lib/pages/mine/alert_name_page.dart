import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/widgets/submit_btn.dart';

///姓名
class AlertNamePage extends StatefulWidget {
  const AlertNamePage({Key key,@required this.name}) : super(key: key);
  final String name;

  @override
  _AlertNamePageState createState() => _AlertNamePageState();
}

class _AlertNamePageState extends State<AlertNamePage> {
  FocusNode _focusNode = FocusNode();
  TextEditingController _editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _editingController.text = widget.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('姓名')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                      '修改姓名',
                      style: const TextStyle(color: AppColors.FF959EB1, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ))
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: TextField(
              controller: _editingController,
              focusNode: _focusNode,
              maxLines: 1,
              textInputAction: TextInputAction.done,
              autofocus: true,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(),
                hintText: '请输入姓名',
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                hintStyle: const TextStyle(
                    color: AppColors.FF959EB1, fontSize: 14),
              ),
            ),
          ),
          SubmitBtn(title: '确认', onPressed: () {
            Navigator.pop(context,_editingController.text);
          }),
        ],
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
    _editingController?.dispose();
    _focusNode?.dispose();
  }
}
