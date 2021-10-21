import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';
import 'package:good_grandma/pages/login/switch_account.dart';
import 'package:good_grandma/widgets/select_form.dart';

///我的页面顶部用户信息视图
class MineHeaderView extends StatelessWidget {
  const MineHeaderView({
    Key key,
    @required this.avatar,
    @required this.userName,
    @required this.local,
    @required this.type,
    @required this.phone,
    @required this.setBtnOnTap,
    @required this.functionBtnOnTap,
  }) : super(key: key);

  final String avatar;
  final String userName;
  final String local;
  final String type;
  final String phone;
  final VoidCallback setBtnOnTap;
  final VoidCallback functionBtnOnTap;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Stack(
      children: [
        Image.asset('assets/images/mine_head_bg.png'),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //标题
                const Text(
                  '我的',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                //用户信息
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          //头像
                          Stack(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.FFD9B887, width: 4),
                                          shape: BoxShape.circle),
                                      child: ClipOval(
                                          child: Container(
                                              child: MyCacheImageView(
                                                imageURL: avatar,
                                                width: 65,
                                                height: 65,
                                                errorWidgetChild: Image.asset('assets/images/icon_empty_user.png', width: 65.0, height: 65.0),
                                              )
                                          )
                                      )
                                  )
                              ),
                              Positioned(
                                right: 10,
                                bottom: 5,
                                child: InkWell(
                                    child: Image.asset('assets/images/icon_switch_account.png', width: 20, height: 20),
                                    onTap: () async {
                                      Map select = await showSelectList(context, Api.allPost, '请切换身份', 'postName');
                                      _switchAccount(context, select);
                                    }
                                )
                              )
                            ]
                          ),
                          //信息
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  //用户名
                                  Container(
                                    child: Text(
                                      userName ?? '',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 20.0),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    constraints: BoxConstraints(maxWidth: 120.0),
                                  ),
                                  //省份
                                  Visibility(
                                    visible: local != null && local.isNotEmpty,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Container(
                                        height: 24,
                                        constraints: BoxConstraints(maxWidth: 100),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 24 / 2),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(24 / 2),
                                            border: Border.all(
                                                color: Colors.white, width: 1)),
                                        child: Text(local ?? '',
                                          style: const TextStyle(
                                              color: Colors.white, fontSize: 14.0),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Visibility(
                                visible: type != null && type.isNotEmpty,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: 200),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/mine_user.png',
                                        width: 14,
                                        height: 14,
                                      ),
                                      //身份
                                      Expanded(
                                        child: Text(' ' + (type ?? '') + '  ',
                                          style: const TextStyle(
                                              color: Colors.white, fontSize: 14.0),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: phone != null && phone.isNotEmpty,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: 200),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/mine_phone.png',
                                        width: 14,
                                        height: 14,
                                      ),
                                      //电话
                                      Expanded(
                                        child: Text(' ' + (phone ?? ''),
                                          style: const TextStyle(
                                              color: Colors.white, fontSize: 14.0),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ]
                      ),
                      // //设置按钮
                      Positioned(
                        right: 0,
                        child: TextButton(
                          onPressed: setBtnOnTap,
                          child: Image.asset('assets/images/mine_set.png',
                              width: 24, height: 24),
                        )
                      )
                    ]
                  )
                ),
                //开通账号功能
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                  child: TextButton(
                    onPressed: functionBtnOnTap,
                    child: Row(
                      children: [
                        Image.asset('assets/images/mine_function.png',
                            width: 30, height: 30.0),
                        Expanded(
                            child: const Text(
                          '  开通账号功能',
                          style: TextStyle(
                              fontSize: 16.0, color: AppColors.FF070E28),
                        )),
                        Icon(Icons.chevron_right,
                            size: 24, color: AppColors.FFC1C8D7),
                      ]
                    )
                  )
                )
              ]
            )
          )
        )
      ]
    ));
  }

  ///切换身份
  void _switchAccount(BuildContext context, Map model) async{
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            title: Text('温馨提示'),
            content: Text('确认要切换身份吗？'),
            actions: <Widget>[
              TextButton(child: Text('取消',style: TextStyle(color: Color(0xFF999999))),onPressed: (){
                Navigator.of(context).pop('cancel');
              }),
              TextButton(child: Text('确认',style: TextStyle(color: Color(0xFFC08A3F))),onPressed: () async {
                Navigator.of(context).pop('ok');
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context)=> SwitchAccountPage(postId: model['postId'])), (route) => false);
                // Navigator.pushReplacement(context,
                //     MaterialPageRoute(builder: (_) => SwitchAccountPage(postId: model['postId'])));
              })
            ]
          );
        });
  }
}
