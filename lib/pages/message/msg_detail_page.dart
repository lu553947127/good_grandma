import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/http.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/msg_list_model.dart';
import 'package:good_grandma/widgets/msg_detail_cell_content.dart';
import 'package:good_grandma/widgets/submit_btn.dart';
import 'package:provider/provider.dart';

///消息详情
class MsgDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Body();
}

class _Body extends State<MsgDetailPage> {

  @override
  Widget build(BuildContext context) {
    final MsgListModel model = Provider.of<MsgListModel>(context);
    return Scaffold(
      appBar: AppBar(title: Text('消息详情')),
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
                  visible: model.haveEnclosure,
                  child: Container(
                    color: Colors.white,
                    child: ListTile(
                      leading: Image.asset('assets/images/msg_enclosure.png',
                          width: 30, height: 30),
                      title: Text(
                          model.enclosureName.isEmpty
                              ? '附件'
                              : model.enclosureName,
                          style: const TextStyle(
                              color: AppColors.FF2F4058, fontSize: 14.0)),
                      subtitle: Text(
                          (model.enclosureSize.isNotEmpty
                                  ? double.parse(model.enclosureSize).toStringAsFixed(2)
                                  : '0') +
                              ' MB',
                          style: const TextStyle(
                              color: AppColors.FFC1C8D7, fontSize: 11.0)),
                      trailing: Image.asset('assets/images/msg_book.png',
                          width: 24, height: 24),
                      onTap: () {
                        if (model.enclosureViewURL.isNotEmpty)
                          AppUtil.launchURL(model.enclosureViewURL);
                        else
                          AppUtil.showToastCenter('预览地址为空');
                      }
                    )
                  )
                ),
                Visibility(
                  visible: !model.read,
                  child: SubmitBtn(
                      title: '立即签收',
                      onPressed: () {
                        _setReadRequest(context, model);
                      }
                  )
                )
              ]
            )
          )
        )
      )
    );
  }

  ///公告已读
  _setReadRequest(BuildContext context, MsgListModel model){
    if(model.read) return;
    requestGet(Api.settingRead + '/' + model.id).then((value) {
      LogUtil.d('settingRead value = $value');
      model.setRead(true);
      Navigator.pop(context, true);
      showToast('签收完成');
    });
  }
}
