import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/provider/image_provider.dart';
import 'package:good_grandma/widgets/photos_cell.dart';
import 'package:good_grandma/widgets/post_detail_group_title.dart';
import 'package:good_grandma/widgets/submit_btn.dart';
import 'package:provider/provider.dart';

///意见反馈
class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key key}) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  FocusNode _focusNode = FocusNode();
  TextEditingController _editingController = TextEditingController();
  ImagesProvider _imagesProvider = new ImagesProvider();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(title: const Text('意见反馈')),
        body: CustomScrollView(
          slivers: [
            PostDetailGroupTitle(color: null, name: '意见反馈'),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 13.0),
              sliver: SliverToBoxAdapter(
                child: Card(
                  child: Container(
                    height: 150,
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: _editingController,
                      focusNode: _focusNode,
                      maxLines: 7,
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      autofocus: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(),
                        hintText: '',
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 13.0),
                sliver: SliverToBoxAdapter(
                  child: Card(
                    child: ChangeNotifierProvider<ImagesProvider>.value(
                        value: _imagesProvider,
                        child:  CustomPhotoWidget(
                            title: '',
                            length: 3,
                            sizeHeight: 10,
                            // bgColor: Colors.transparent,
                            url: Api.putFile
                        )
                    ),
                  ),
                )),
            SliverToBoxAdapter(
              child: SubmitBtn(
                title: '提  交',
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _editingController?.dispose();
    _focusNode?.dispose();
  }
}
