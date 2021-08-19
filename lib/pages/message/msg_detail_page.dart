import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/models/msg_list_model.dart';
import 'package:good_grandma/widgets/msg_detail_cell_content.dart';
import 'package:provider/provider.dart';

///消息详情
class MsgDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Body();
}

class _Body extends State<MsgDetailPage> {
  @override
  void initState() {
    super.initState();
    _refresh();
  }

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
                  visible: model.enclosureName != null ||
                      model.enclosureName.isNotEmpty,
                  child: Container(
                    color: Colors.white,
                    child: ListTile(
                      leading: Image.asset('assets/images/msg_enclosure.png',
                          width: 30, height: 30),
                      title: Text(
                        model.enclosureName ?? '',
                        style: const TextStyle(
                            color: AppColors.FF2F4058, fontSize: 14.0),
                        // maxLines: 1,
                        // overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(model.enclosureSize ?? '',
                          style: const TextStyle(
                              color: AppColors.FFC1C8D7, fontSize: 11.0)),
                      trailing: Image.asset('assets/images/msg_book.png',
                          width: 24, height: 24),
                      onTap: () {},
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

  void _refresh() {}
}
