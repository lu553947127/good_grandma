import 'package:flutter/material.dart';
import 'package:good_grandma/widgets/add_text_input.dart';

class TextFormFieldPage extends StatefulWidget {
  @override
  _TextFormFieldPageState createState() => _TextFormFieldPageState();
}

class _TextFormFieldPageState extends State<TextFormFieldPage> {
  final TextEditingController _controller = new TextEditingController();
  TextEditingController controller = new TextEditingController();
  TextEditingController controller2 = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = "男";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('a'),
      ),
      body: Column(
          children: [
            Container(
                color: Colors.white,
                padding: EdgeInsets.all(16),
                child: TextFormField(
                    controller: _controller,
                    readOnly: false,
                    decoration: InputDecoration(
                        labelText: "性别",
                        hintText: "请选择性别",
                        suffixIcon: Container(
                          width: 40,
                          height: 40,
                          child: IconButton(
                            icon: Icon(Icons.format_list_bulleted),
                            onPressed: (){
                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        ListTile(
                                          title: Text("男"),
                                          onTap: () {
                                            setState(() {
                                              _controller.text = "男";
                                              controller.text = '2972498374923749837';
                                              controller2.text = '中国工商银行';
                                              Navigator.pop(context);
                                            });
                                          },
                                        ),
                                        ListTile(
                                          title: Text("女"),
                                          onTap: () {
                                            setState(() {
                                              _controller.text = "女";
                                              controller.text = '67567547236547236574';
                                              controller2.text = '中国建设银行';
                                              Navigator.pop(context);
                                            });
                                          },
                                        ),
                                        ListTile(
                                          title: Text("不告诉你"),
                                          onTap: () {
                                            setState(() {
                                              _controller.text = "不告诉你";
                                              controller.text = '987627846782364823674823';
                                              controller2.text = '中国农业银行';
                                              Navigator.pop(context);
                                            });
                                          },
                                        )
                                      ],
                                    );
                                  }
                              );
                            },
                          ),
                          alignment: Alignment.centerRight,
                        )
                    )
                )
            ),
            TextInputView(
                leftTitle: '账号',
                rightPlaceholder: '请输入账号',
                sizeHeight: 1,
                rightLength: 120,
                controller: controller,
                onChanged: (tex){

                }
            ),
            TextInputView(
                leftTitle: '开户行',
                rightPlaceholder: '请输入开户行',
                sizeHeight: 1,
                rightLength: 120,
                controller: controller2,
                onChanged: (tex){

                }
            )
          ]
      ),
    );
  }
}
