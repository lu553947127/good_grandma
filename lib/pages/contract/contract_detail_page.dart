import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/pages/contract/contract_content_page.dart';
import 'package:good_grandma/pages/contract/contract_sign_page.dart';
import 'package:good_grandma/widgets/contract_detail_progress_cell.dart';
import 'package:good_grandma/widgets/smscode_dialog.dart';
import 'package:good_grandma/widgets/submit_btn.dart';

///合同详细
class ContractDetailPage extends StatefulWidget {
  const ContractDetailPage({Key key, @required this.id}) : super(key: key);
  final String id;

  @override
  _ContractDetailPageState createState() => _ContractDetailPageState();
}

class _ContractDetailPageState extends State<ContractDetailPage> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode2 = FocusNode();
  final TextEditingController _textEditingController2 = TextEditingController();
  String _title = '';
  bool _signed = false;
  String _type = '';
  String _signUser = '';
  String _signTime = '';
  String _endSignTime = '';
  List<Map> _dataArray = [];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('合同详细')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Scrollbar(
          child: CustomScrollView(
            slivers: [
              //标题
              _ContractDetailTitle(
                title: _title,
                signed: _signed,
                signUser: _signUser,
                signTime: _signTime,
                endSignTime: _endSignTime,
                type: _type,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ContractContentPage(id: widget.id))),
              ),
              //流程
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: const Text('审核流程',
                      style:
                          TextStyle(color: AppColors.FF2F4058, fontSize: 12)),
                ),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                Map map = _dataArray[index];
                String avatar = map['avatar'];
                String userName = map['userName'];
                String position = map['position'];
                String time = map['time'];
                String content = map['content'];
                bool isLast = index == _dataArray.length - 1;
                Color stateColor =
                    isLast ? AppColors.FFC08A3F : AppColors.FF12BD95;
                String stateName = isLast ? '发起申请' : '已审核';
                return ContractDetailProgressCell(
                    isLast: isLast,
                    stateColor: stateColor,
                    stateName: stateName,
                    time: time,
                    content: content,
                    avatar: avatar,
                    userName: userName,
                    position: position);
              }, childCount: _dataArray.length))
            ],
          ),
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: !_signed,
        child: SafeArea(
          child: SubmitBtn(
              title: '签署',
              onPressed: () {
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
    _title = '合同名称合同名称合同名称合';
    _signed = false;
    _type = '销售合同';
    _signUser = '张三';
    _signTime = '2021-07-01';
    _endSignTime = '2021-07-01';
    _dataArray.clear();
    _dataArray.addAll([
      {
        'avatar':
            'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
        'userName': '王五',
        'position': '大区经理',
        'time': '2021-07-26 15:00:00',
        'content': '审核意见审核意见审核意见审核意见审核意见审核意见审核意见审核意见审核意见'
      },
      {
        'avatar':
            'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
        'userName': '李四',
        'position': '城市经理',
        'time': '2021-07-26 15:00:00',
        'content': '审核意见审核意见审核意见审核意见审核意见审核意见审核意见审核意见审核意见'
      },
      {
        'avatar':
            'https://c-ssl.duitang.com/uploads/item/201707/28/20170728212204_zcyWe.thumb.1000_0.jpeg',
        'userName': '王五',
        'position': '业务经理',
        'time': '2021-07-26 15:00:00',
        'content': '审核意见审核意见审核意见审核意见审核意见审核意见审核意见审核意见审核意见'
      },
    ]);
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

///标题
class _ContractDetailTitle extends StatelessWidget {
  const _ContractDetailTitle({
    Key key,
    @required String title,
    @required bool signed,
    @required String type,
    @required String signUser,
    @required String signTime,
    @required String endSignTime,
    @required this.onTap,
  })  : _title = title ?? '',
        _type = type ?? '',
        _signed = signed ?? false,
        _signUser = signUser ?? '',
        _signTime = signTime ?? '',
        _endSignTime = endSignTime ?? '',
        super(key: key);

  final String _title;
  final bool _signed;
  final String _type;
  final String _signUser;
  final String _signTime;
  final String _endSignTime;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    List<Widget> views = [];
    List<Map> values = [
      {
        'image': 'assets/images/icon_freezer_model.png',
        'title': '合同类型：',
        'value': _type
      },
      {
        'image': 'assets/images/icon_visit_statistics_name.png',
        'title': '签  署  人：',
        'value': _signUser
      },
      {
        'image': 'assets/images/icon_visit_statistics_time.png',
        'title': '签署时间：',
        'value': _signTime
      },
    ];
    int max = 1;
    if (_signed) max = values.length;
    for (int i = 0; i < max; i++) {
      Map map = values[i];
      String image = map['image'];
      String title = map['title'];
      String value = map['value'];
      views.add(_ContractTitle1(image: image, title: title, value: value));
    }
    return SliverToBoxAdapter(
      child: Column(
        children: [
          ListTile(
            onTap: onTap,
            title: Row(
              children: [
                Image.asset('assets/images/contract_icon.png',
                    width: 30, height: 30),
                Expanded(
                    child: Text('  ' + _title,
                        style: const TextStyle(
                            color: AppColors.FF2F4058, fontSize: 14.0),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis)),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.FF2F4058,
                ),
                Card(
                  color: !_signed
                      ? AppColors.FFE45C26.withOpacity(0.1)
                      : AppColors.FF959EB1.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7.5, vertical: 5),
                    child: !_signed
                        ? const Text('未签署',
                            style: TextStyle(
                                color: AppColors.FFE45C26, fontSize: 11.0))
                        : Text('已签署',
                            style: TextStyle(
                                color: AppColors.FF959EB1, fontSize: 11.0)),
                  ),
                )
              ],
            ),
          ),
          const Divider(color: AppColors.FFEFEFF4, thickness: 1, height: 1),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(10.0))),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                      visible: !_signed,
                      child: Row(
                        children: [
                          Image.asset('assets/images/contract_wait.png',
                              width: 10, height: 12),
                          Expanded(
                              child: Text(
                            ' 等待' + _signUser + '审批',
                            style: const TextStyle(
                                color: AppColors.FFE45C26, fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )),
                          Text(
                            '签署截止时间：' + _endSignTime,
                            style: const TextStyle(
                                color: AppColors.FFDD0000, fontSize: 12),
                          ),
                        ],
                      )),
                  Visibility(
                      visible: !_signed,
                      child: const Divider(
                          color: AppColors.FFEFEFF4, thickness: 1, height: 20)),
                  Column(
                    children: views,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _ContractTitle1 extends StatelessWidget {
  const _ContractTitle1({
    Key key,
    @required String image,
    @required String title,
    @required String value,
  })  : _image = image,
        _title = title,
        _value = value,
        super(key: key);
  final String _image;
  final String _title;
  final String _value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(_image, width: 12, height: 12),
        Text.rich(
          TextSpan(
              text: '  ' + _title,
              style: const TextStyle(color: AppColors.FF959EB1, fontSize: 11),
              children: [
                TextSpan(
                    text: _value,
                    style: const TextStyle(color: AppColors.FF2F4058))
              ]),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
