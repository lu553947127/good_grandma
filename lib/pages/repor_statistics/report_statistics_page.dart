import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';
import 'package:good_grandma/pages/repor_statistics/report_statistics_detail_page.dart';
import 'package:good_grandma/widgets/search_text_widget.dart';

///报告统计
class ReportStatisticsPage extends StatefulWidget {
  const ReportStatisticsPage({Key key}) : super(key: key);

  @override
  _ReportStatisticsPageState createState() => _ReportStatisticsPageState();
}

class _ReportStatisticsPageState extends State<ReportStatisticsPage> {
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
      appBar: AppBar(title: const Text('报告统计')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Scrollbar(
          child: CustomScrollView(
            slivers: [
              //搜索区域
              SearchTextWidget(
                  hintText: '请输入员工姓名',
                  editingController: _editingController,
                  focusNode: _focusNode,
                  onSearch: (text) {}),
              //列表
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                Map map = _dataArray[index];
                String avatar = map['avatar'];
                String name = map['name'];
                String day = map['day'];
                String week = map['week'];
                String month = map['month'];
                String id = map['id'];
                return _ReportStatisticsCell(
                  avatar: avatar,
                  name: name,
                  day: day,
                  week: week,
                  month: month,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ReportStatisticsDetailPage(id: id,name: name,))),
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
        'name': '张三丰',
        'day': '2333',
        'week': '2333',
        'month': '2333',
        'id': ''
      },
      {
        'avatar':
            'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
        'name': '张三丰',
        'day': '2333',
        'week': '2333',
        'month': '2333',
        'id': ''
      },
      {
        'avatar':
            'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
        'name': '张三丰',
        'day': '2333',
        'week': '2333',
        'month': '2333',
        'id': ''
      },
      {
        'avatar':
            'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
        'name': '荣格超市',
        'day': '2333',
        'week': '2333',
        'month': '2333',
        'id': ''
      },
      {
        'avatar':
            'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
        'name': '荣格超市',
        'day': '2333',
        'week': '2333',
        'month': '2333',
        'id': ''
      },
      {
        'avatar':
            'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
        'name': '荣格超市',
        'day': '2333',
        'week': '2333',
        'month': '2333',
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

class _ReportStatisticsCell extends StatelessWidget {
  const _ReportStatisticsCell({
    Key key,
    @required this.avatar,
    @required this.name,
    @required this.day,
    @required this.week,
    @required this.month,
    @required this.onTap,
  }) : super(key: key);

  final String avatar;
  final String name;
  final String day;
  final String week;
  final String month;
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
                  flex: 1,
                  child: Text(
                    name,
                    style: const TextStyle(
                        color: AppColors.FF2F4058, fontSize: 14.0),
                  )),
              Expanded(
                flex: 3,
                child: Text('日报:$day    周报:$week    月报:$month',
                    style: const TextStyle(
                        color: AppColors.FF959EB1, fontSize: 12.0)),
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
