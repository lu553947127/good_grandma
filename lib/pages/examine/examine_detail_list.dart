import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';

///审核流程列表
class ExamineDetailList extends StatelessWidget {
  var flow;
  final bool isLast;

  ExamineDetailList({Key key, this.flow, this.isLast}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    _setTextColor(status, String endTime){
      switch(status){
        case 'startEvent'://发起申请
          return Color(0xFFC08A3F);
          break;
        default:
          if (endTime.isEmpty){
            //未审核
            return Color(0xFF2F4058);
          } else{
            //已审核
            return Color(0xFF12BD95);
          }
          break;
      }
    }

    _setLeftIcon(status, String endTime){
      switch(status){
        case 'startEvent'://发起申请
          return 'assets/images/icon_examine_status2.png';
          break;
        default:
          if (endTime.isEmpty){
            //未审核
            return 'assets/images/icon_examine_status3.png';
          } else{
            //已审核
            return 'assets/images/icon_examine_status1.png';
          }
          break;
      }
    }

    _setStatusText(status, String endTime){
      switch(status){
        case 'startEvent'://发起申请
          return '发起申请';
          break;
        default:
          if (endTime.isEmpty){
            //未审核
            return '未审核';
          } else{
            //已审核
            return '已审核';
          }
          break;
      }
    }

    _setTypeText(type){
      switch(type){
        case 'assigneeComment':
          return '变更审核人';
          break;
        case 'dispatchComment':
          return '调度';
          break;
        case 'transferComment':
          return '转办';
          break;
        case 'delegateComment':
          return '委托';
          break;
        case 'rollbackComment':
          return '驳回意见';
          break;
        case 'terminateComment':
          return '终止意见';
          break;
        case 'addMultiInstanceComment':
          return '加签';
          break;
        case 'deleteMultiInstanceComment':
          return '减签';
          break;
        case 'comment':
          return '审批意见';
          break;
      }
    }

    ///获取审批流程评论列表数据
    List<Map> commentsList = (flow['comments'] as List).cast();
    // LogUtil.d('commentsList----$commentsList');

    String endTime = flow['endTime'];

    double avatarWH = 35.0;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Stack(
            children: [
              Container(
                  padding: EdgeInsets.only(left: avatarWH / 2),
                  child: Container(
                      padding: EdgeInsets.only(left: 20, top: avatarWH),
                      decoration: BoxDecoration(
                          border: Border(
                              left: BorderSide(
                                  color: isLast ? Color(0x00000000) : Color(0XFFE3E3E7),
                                  width: 1))),
                      child: Card(
                          child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(_setLeftIcon(flow['historyActivityType'], endTime), width: 12, height: 12),
                                              SizedBox(width: 3),
                                              Text(_setStatusText(flow['historyActivityType'], endTime)
                                                  , style: TextStyle(fontSize: 13, color: _setTextColor(flow['historyActivityType'], endTime)))
                                            ],
                                          ),
                                          Visibility(
                                            visible: endTime.isEmpty ? false : true,
                                            child: Text(endTime, style: TextStyle(fontSize: 12, color: Color(0XFFC1C8D7))),
                                          )
                                        ]
                                    ),
                                    Visibility(
                                        visible: flow['historyActivityType'] != 'startEvent' && endTime.isNotEmpty ? true : false,
                                        child: ListView.builder(
                                            shrinkWrap:true,//范围内进行包裹（内容多高ListView就多高）
                                            physics:NeverScrollableScrollPhysics(),//禁止滚动
                                            itemCount: commentsList.length,
                                            itemBuilder: (context, index){
                                              return Container(
                                                  margin: EdgeInsets.only(top: 10),
                                                  child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text.rich(TextSpan(text: '${_setTypeText(commentsList[index]['type'])}: ',style: TextStyle(fontSize: 14, color: Color(0xFFC68D3E)),
                                                            children: <TextSpan>[
                                                              TextSpan(text: commentsList[index]['message'],style: TextStyle(fontSize: 14,color: Color(0xFF2F4058)))
                                                            ])),
                                                        SizedBox(height: 5),
                                                        Text(commentsList[index]['time'], style: TextStyle(fontSize: 12, color: Color(0XFFC1C8D7)))
                                                      ]
                                                  )
                                              );
                                            }
                                        )
                                    )
                                  ]
                              )
                          )
                      )
                  )
              ),
              Positioned(
                  left: 0,
                  top: 0,
                  child: Row(
                      children: [
                        ClipOval(
                            child: MyCacheImageView(
                                imageURL: flow['user']['avatar'], width: avatarWH, height: avatarWH,
                              errorWidgetChild: Image.asset('assets/images/icon_empty_user.png', width: avatarWH, height: avatarWH),)),
                        Text(
                          '  ${flow['user']['realName']}',
                          style: const TextStyle(
                              color: AppColors.FF2F4058, fontSize: 14.0),
                        ),
                        Card(
                            color: AppColors.FFE45C26.withOpacity(0.1),
                            shadowColor: AppColors.FFE45C26.withOpacity(0.1),
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.5, vertical: 2.5),
                                child: Text(
                                  '${flow['user']['name']}',
                                  style: const TextStyle(
                                      color: AppColors.FFE45C26, fontSize: 11.0),
                                )
                            )
                        )
                      ]
                  )
              )
            ]
        )
    );
  }
}
