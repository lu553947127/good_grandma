import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/pages/examine/model/time_select_provider.dart';
import 'package:good_grandma/widgets/add_text_input.dart';
import 'package:good_grandma/widgets/time_select.dart';

///出差日程子表单
class TravelScheduleFrom extends StatefulWidget {
  final dynamic data;
  final TimeSelectProvider timeSelectProvider;
  const TravelScheduleFrom({Key key, this.data, this.timeSelectProvider}) : super(key: key);

  @override
  _TravelScheduleFromState createState() => _TravelScheduleFromState();
}

class _TravelScheduleFromState extends State<TravelScheduleFrom> {
  @override
  Widget build(BuildContext context) {
    List<Map> listDynamic = (widget.data['children']['column'] as List).cast();

    _childWidget(data, index){
      TravelModel travelModel = widget.timeSelectProvider.travelScheduleList[index];

      switch(data['type']){
        case 'input':
          return TextInputView(
              leftTitle: data['label'],
              rightPlaceholder: '请输入${data['label']}',
              sizeHeight: 1,
              rightLength: 120,
              onChanged: (tex){
                if (data['prop'] == 'chufadi'){
                  travelModel.chufadi = tex;
                } else if (data['prop'] == 'mudidi'){
                  travelModel.mudidi = tex;
                }
                widget.timeSelectProvider.editFormWith(index, travelModel);
              }
          );
          break;
        case 'datetimerange':
          return TimeSelectView(
              leftTitle: data['label'],
              rightPlaceholder: '请选择${data['label']}',
              value: (travelModel.startTime.isNotEmpty && travelModel.endTime.isNotEmpty)
                  ? '${travelModel.startTime + '\n' + travelModel.endTime}'
                  : '',
              dayNumber: travelModel.days,
              sizeHeight: 1,
              isDays: false,
              onPressed: (param) {
                travelModel.startTime = param['startTime'];
                travelModel.endTime = param['endTime'];
                travelModel.days = param['days'];
                widget.timeSelectProvider.editFormWith(index, travelModel);
              }
          );
          break;
        default:
          return Container();
          break;
      }
    }

    return Container(
        margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
        color: Colors.white,
        child: Column(
            children: [
              ListTile(
                title: Text(widget.data['label'], style: const TextStyle(color: AppColors.FF070E28, fontSize: 15.0)),
                trailing: IconButton(
                    onPressed: () {
                      widget.timeSelectProvider.addForm(TravelModel());
                    },
                    icon: Icon(Icons.add_circle, color: AppColors.FFC68D3E)),
              ),
              ListView.builder(
                  shrinkWrap:true,//范围内进行包裹（内容多高ListView就多高）
                  physics:NeverScrollableScrollPhysics(),//禁用滑动事件
                  itemCount: widget.timeSelectProvider.travelScheduleList.length,
                  itemBuilder: (context, index){
                    return Container(
                        margin: EdgeInsets.all(15),
                        decoration: new BoxDecoration(
                            border: new Border.all(color: Color(0xFF2F4058), width: 0.6),
                            color: Color(0xFF2F4058),
                            borderRadius: new BorderRadius.circular((5.0))
                        ),
                        child: Column(
                            children: [
                              ListView.builder(
                                shrinkWrap:true,//范围内进行包裹（内容多高ListView就多高）
                                physics:NeverScrollableScrollPhysics(),//禁用滑动事件
                                itemCount: listDynamic.length,
                                itemBuilder: (context, indexChild){
                                  return _childWidget(listDynamic[indexChild], index);
                                },
                              ),
                              Container(
                                  width: double.infinity,
                                  color: Colors.white,
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                      onPressed: (){
                                        widget.timeSelectProvider.deleteFormWith(index);
                                      },
                                      icon: Icon(Icons.delete, color: AppColors.FFDD0000)
                                  )
                              )
                            ]
                        )
                    );
                  }
              )
            ]
        )
    );
  }
}
