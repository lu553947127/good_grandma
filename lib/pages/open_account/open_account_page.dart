import 'package:flutter/material.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/models/add_dealer_model.dart';
import 'package:good_grandma/pages/open_account/open_dealer_page.dart';
import 'package:provider/provider.dart';

///开通账号
class OpenAccountPage extends StatelessWidget {
  const OpenAccountPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('开通账号')),
      body: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SizedBox(
          height: 276,
          width: double.infinity,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                    onPressed: () {
                      AddDealerModel _model = AddDealerModel();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ChangeNotifierProvider.value(
                                  value: _model, child: OpenDealerPage())));
                    },
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16))),
                    child: const Text('   开通经销商   ',
                        style: TextStyle(
                            color: AppColors.FF2F4058, fontSize: 14.0))),
                SizedBox(height: 20),
                OutlinedButton(
                    onPressed: () {
                      AddDealerModel _model = AddDealerModel();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ChangeNotifierProvider.value(
                                  value: _model, child: OpenDealerPage(isSpecial: true))));
                    },
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16))),
                    child: const Text('开通特约经销商',
                        style: TextStyle(
                            color: AppColors.FF2F4058, fontSize: 14.0))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
