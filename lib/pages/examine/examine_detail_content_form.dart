import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/utils.dart';

///oa审批详情子表单数据显示
class ExamineDetailContentForm extends StatefulWidget {
  final List<Map> mapList;
  final String name;
  const ExamineDetailContentForm({Key key, this.mapList, this.name}) : super(key: key);

  @override
  State<ExamineDetailContentForm> createState() => _ExamineDetailContentFormState();
}

class _ExamineDetailContentFormState extends State<ExamineDetailContentForm> {

  List<Map> selectList = [];
  String title = '';

  @override
  void initState() {
    super.initState();
    selectList.addAll(widget.mapList);
  }

  @override
  Widget build(BuildContext context) {
    return widget.mapList.length != 0 ?
    ListView.builder(
        shrinkWrap:true,//范围内进行包裹（内容多高ListView就多高）
        physics:NeverScrollableScrollPhysics(),//禁用滑动事件
        itemCount: widget.mapList.length,
        itemBuilder: (content, index){
          List<String> timeList = [];
          if (widget.name == '出差明细'){
            timeList = (widget.mapList[index]['qizhishijian'] as List).cast();
            title = listToStringTime(timeList);
          }else if (widget.name == '出差日程'){
            timeList = (widget.mapList[index]['yujichuchairiqi'] as List).cast();
            title = listToStringTime(timeList);
          }else {
            title = widget.mapList[index]['danweimingcheng'];
          }
          return Container(
            margin: EdgeInsets.only(top: 5.0),
              decoration: new BoxDecoration(
                  border: new Border.all(color: Color(0xFF2F4058), width: 0.6),
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular((5.0))
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Color(0xFFFaFaFa),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(margin: EdgeInsets.only(left: 5.0), child: Text(title, style: TextStyle(fontSize: 12))),
                          IconButton(
                              onPressed: () {
                                Map map = new Map();
                                if (selectList[index]['opened'] == 'true'){
                                  map['opened'] = 'false';
                                  selectList.setAll(index, [map]);
                                }else {
                                  map['opened'] = 'true';
                                  selectList.setAll(index, [map]);
                                }
                                setState(() {});
                              },
                              icon: Icon(selectList[index]['opened'] == 'true'
                                  ? Icons.keyboard_arrow_up_outlined
                                  : Icons.keyboard_arrow_down_outlined))
                        ],
                      )
                    ),
                    Visibility(
                      visible: selectList[index]['opened'] == 'true',
                      child: Container(
                        margin: EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            Visibility(
                              visible: widget.name == '支付对象信息',
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text.rich(TextSpan(text: '单位名称   ', children: [TextSpan(text: '${widget.mapList[index]['danweimingcheng']}')])),
                                  Text.rich(TextSpan(text: '账号   ', children: [TextSpan(text: '${widget.mapList[index]['zhanghao']}')])),
                                  Text.rich(TextSpan(text: '开户行名称   ', children: [TextSpan(text: '${widget.mapList[index]['kaihuhangmingcheng']}')])),
                                  Text.rich(TextSpan(text: '金额   ', children: [TextSpan(text: '${widget.mapList[index]['jine']}')])),
                                  Text.rich(TextSpan(text: '支付方式   ', children: [TextSpan(text: '${widget.mapList[index]['zhifufangshi']}')])),
                                  Text.rich(TextSpan(text: '备注   ', children: [TextSpan(text: '${widget.mapList[index]['beizhu']}')]))
                                ]
                              )
                            ),
                            Visibility(
                              visible: widget.name == '出差明细',
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text.rich(TextSpan(text: '起止时间   ', children: [TextSpan(text: '${listToStringTime(timeList)}')])),
                                  Text.rich(TextSpan(text: '合计天数   ', children: [TextSpan(text: '${widget.mapList[index]['days']}')])),
                                  Text.rich(TextSpan(text: '起止地点   ', children: [TextSpan(text: '${widget.mapList[index]['qizhididian']}')])),
                                  Text.rich(TextSpan(text: '出差目的   ', children: [TextSpan(text: '${widget.mapList[index]['chuchaimudi']}')])),
                                  Text.rich(TextSpan(text: '交通金额   ', children: [TextSpan(text: '${widget.mapList[index]['jiaotongjine']}')])),
                                  Text.rich(TextSpan(text: '市内交通   ', children: [TextSpan(text: '${widget.mapList[index]['shineijiaotong']}')])),
                                  Text.rich(TextSpan(text: '住宿金额   ', children: [TextSpan(text: '${widget.mapList[index]['zhusujine']}')])),
                                  Text.rich(TextSpan(text: '补助金额   ', children: [TextSpan(text: '${widget.mapList[index]['buzhujine']}')])),
                                  Text.rich(TextSpan(text: '其他金额   ', children: [TextSpan(text: '${widget.mapList[index]['qitajine']}')])),
                                  Text.rich(TextSpan(text: '备注   ', children: [TextSpan(text: '${widget.mapList[index]['beizhu']}')]))
                                ]
                              )
                            ),
                            Visibility(
                              visible: widget.name == '出差日程',
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text.rich(TextSpan(text: '出发地   ', children: [TextSpan(text: '${widget.mapList[index]['chufadi']}')])),
                                  Text.rich(TextSpan(text: '目的地   ', children: [TextSpan(text: '${widget.mapList[index]['mudidi']}')])),
                                  Text.rich(TextSpan(text: '预计出差日期   ', children: [TextSpan(text: '${listToStringTime(timeList)}')]))
                                ]
                              )
                            )
                          ]
                        )
                      )
                    )
                  ]
              )
          );
        }
    ) :
    Text('暂无', style: TextStyle(fontSize: 15, color: AppColors.FF2F4058));
  }
}
