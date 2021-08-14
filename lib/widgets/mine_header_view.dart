import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/my_cache_image_view.dart';

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
                  child: Row(
                    children: [
                      //头像
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
                                errorWidgetChild: const Icon(
                                    Icons.supervised_user_circle_rounded,
                                    size: 65,
                                    color: AppColors.FF2F4058),
                              ),
                            ),
                          ),
                        ),
                      ),
                      //信息
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              //用户名
                              Text(
                                userName ?? '',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20.0),
                                // maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              //省份
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Container(
                                  height: 24,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24 / 2),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(24 / 2),
                                      border: Border.all(
                                          color: Colors.white, width: 1)),
                                  child: Text(local ?? '',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 14.0)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/mine_user.png',
                                width: 14,
                                height: 14,
                              ),
                              //身份
                              Text(' ' + (type ?? '') + '  ',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14.0)),
                              Image.asset(
                                'assets/images/mine_phone.png',
                                width: 14,
                                height: 14,
                              ),
                              //电话
                              Text(' ' + (phone ?? ''),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14.0)),
                            ],
                          ),
                        ],
                      ),
                      Spacer(),
                      //设置按钮
                      TextButton(
                        onPressed: setBtnOnTap,
                        child: Image.asset('assets/images/mine_set.png',
                            width: 24, height: 24),
                      )
                    ],
                  ),
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
