import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:good_grandma/widgets/submit_btn.dart';
import 'package:signature/signature.dart';
///签名页面
class SignaturePage extends StatefulWidget {
  const SignaturePage({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _Body();
}
class _Body extends State<SignaturePage>{

  final SignatureController _controller = SignatureController(
    penStrokeWidth: 1,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
    onDrawStart: () => print('onDrawStart called!'),
    onDrawEnd: () => print('onDrawEnd called!'),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('签名'),
        actions: [
          TextButton(onPressed: () => setState(() => _controller.clear()), child: const Text('清除',style: TextStyle(color: Colors.black),)),
        ],
      ),
      body: ListView(
        children: [
          Signature(
            controller: _controller,
            height: 300,
            backgroundColor: Colors.white,
          ),
          SubmitBtn(title: '确定', onPressed: () async{
            if (_controller.isNotEmpty) {
              final Uint8List data =
                  await _controller.toPngBytes();
              if (data != null) {
                Navigator.pop(context,data);
              }
            }
          }),
        ],
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }
}
