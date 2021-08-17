import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/models/msg_list_model.dart';
import 'package:good_grandma/pages/home/msg_enclosure_page.dart';
import 'package:good_grandma/widgets/msg_detail_cell_content.dart';
import 'package:provider/provider.dart';

///规章详情
class RegularDocDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Body();
}

class _Body extends State<RegularDocDetailPage> {
  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final MsgListModel model = Provider.of<MsgListModel>(context);
    return Scaffold(
      appBar: AppBar(title: Text('规章详情')),
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
                      trailing: TextButton(
                        onPressed: () {
                          AppUtil.saveImage(context: context,imageUrl: model.enclosureURL);
                        },
                        child: Image.asset('assets/images/download_image.png',
                            width: 24, height: 24),
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

  void _refresh() {}
}
