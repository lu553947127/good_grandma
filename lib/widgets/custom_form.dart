import 'package:flutter/material.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/provider/image_provider.dart';
import 'package:good_grandma/widgets/add_content_input.dart';
import 'package:good_grandma/widgets/add_text_input.dart';
import 'package:good_grandma/widgets/add_text_select.dart';
import 'package:good_grandma/widgets/photos_cell.dart';
import 'package:good_grandma/widgets/select_form.dart';
import 'package:provider/provider.dart';

///自定义表单组件
class CustomFormView extends StatefulWidget {
  var data;
  CustomFormView({Key key, this.data}) : super(key: key);

  @override
  _CustomFormViewState createState() => _CustomFormViewState();
}

class _CustomFormViewState extends State<CustomFormView> {
  @override
  Widget build(BuildContext context) {
    ImagesProvider imagesProvider = new ImagesProvider();
    switch(widget.data['type']){
      case 'date':
        return TextSelectView(
          leftTitle: widget.data['label'],
          rightPlaceholder: '请选择${widget.data['label']}',
          sizeHeight: 0,
          onPressed: (){
            return showPickerDate(context);
          },
        );
        break;
      case 'input':
        return TextInputView(
          leftTitle: widget.data['label'],
          rightPlaceholder: '请输入${widget.data['label']}',
          sizeHeight: 1,
          onChanged: (tex){

          },
        );
        break;
      case 'select':
        return TextSelectView(
          leftTitle: widget.data['label'],
          rightPlaceholder: '请选择${widget.data['label']}',
          sizeHeight: 1,
          onPressed: (){
            return showSelect(context, widget.data['dicUrl'], '请选择${widget.data['label']}');
          },
        );
        break;
      case 'number':
        return TextInputView(
          leftTitle: widget.data['label'],
          rightPlaceholder: '请输入${widget.data['label']}',
          type: TextInputType.number,
          sizeHeight: 1,
          onChanged: (tex){

          },
        );
        break;
      case 'textarea':
        return ContentInputView(
          color: Colors.white,
          leftTitle: widget.data['label'],
          rightPlaceholder: '请输入${widget.data['label']}',
          sizeHeight: 10,
          onChanged: (tex){

          },
        );
        break;
      case 'upload':
        return ChangeNotifierProvider<ImagesProvider>.value(
            value: imagesProvider,
            child:  CustomPhotoWidget(
              title: widget.data['label'],
              length: 3,
              sizeHeight: 10,
            )
        );
        break;
      default:
        return Container(
          child: Text('无法显示此类型'),
        );
        break;
    }
  }
}
