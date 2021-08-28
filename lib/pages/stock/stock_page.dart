import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';
import 'package:good_grandma/models/stock_add_model.dart';
import 'package:good_grandma/pages/stock/stock_add_page.dart';
import 'package:good_grandma/pages/stock/stock_detail_page.dart';
import 'package:good_grandma/widgets/search_text_widget.dart';
import 'package:provider/provider.dart';

///客户库存
class StockPage extends StatefulWidget {
  const StockPage({Key key}) : super(key: key);

  @override
  _StockPageState createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  FocusNode _focusNode = FocusNode();
  TextEditingController _editingController = TextEditingController();
  List<Map> _dataArray = [];
  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('客户库存')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: AppColors.FFC68D3E,
        onPressed: () async{
          final StockAddModel _model = StockAddModel();
          final result = await Navigator.push(context, MaterialPageRoute(builder: (context){
            return ChangeNotifierProvider.value(value: _model,child: StockAddPage(),);
          }));
          if(result != null){
            _refresh();
          }
        },
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Scrollbar(
          child: CustomScrollView(
            slivers: [
              //搜索区域
              SearchTextWidget(
                  hintText: '请输入客户名称',
                  editingController: _editingController,
                  focusNode: _focusNode,
                  onSearch: (text) {}),
              //列表
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                Map map = _dataArray[index];
                String avatar = map['avatar'];
                String name = map['name'];
                String number = map['number'];
                String id = map['id'];
                return _StockCell(
                  avatar: avatar,
                  name: name,
                  number: number,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => StockDetailPage(id: id))),
                );
              }, childCount: _dataArray.length)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    _dataArray.clear();
    _dataArray.addAll([
      {
        'avatar':
            'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
        'name': '荣格超市',
        'number': '2333',
        'id': ''
      },
      {
        'avatar':
            'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
        'name': '荣格超市',
        'number': '2333',
        'id': ''
      },
      {
        'avatar':
            'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
        'name': '荣格超市',
        'number': '2333',
        'id': ''
      },
      {
        'avatar':
            'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
        'name': '荣格超市',
        'number': '2333',
        'id': ''
      },
      {
        'avatar':
            'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
        'name': '荣格超市',
        'number': '2333'
      },
      {
        'avatar':
            'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
        'name': '荣格超市',
        'number': '2333'
      },
      {
        'avatar':
            'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
        'name': '荣格超市',
        'number': '2333',
        'id': ''
      },
    ]);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode?.dispose();
    _editingController?.dispose();
  }
}

class _StockCell extends StatelessWidget {
  const _StockCell({
    Key key,
    @required this.avatar,
    @required this.name,
    @required this.number,
    @required this.onTap,
  }) : super(key: key);

  final String avatar;
  final String name;
  final String number;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ClipOval(
                    child: MyCacheImageView(
                        imageURL: avatar, width: 30, height: 30)),
              ),
              Expanded(
                  child: Text(
                name,
                style:
                    const TextStyle(color: AppColors.FF2F4058, fontSize: 14.0),
              )),
              Expanded(
                child: Text.rich(
                  TextSpan(
                      text: '当月库存：',
                      style: const TextStyle(
                          color: AppColors.FF959EB1, fontSize: 12.0),
                      children: [
                        TextSpan(
                          text: number,
                          style: const TextStyle(
                              color: AppColors.FFE45C26, fontSize: 14.0),
                        ),
                        TextSpan(text: '箱'),
                      ]),
                  textAlign: TextAlign.end,
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppColors.FF959EB1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
