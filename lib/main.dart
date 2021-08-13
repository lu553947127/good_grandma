import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:good_grandma/common/colors.dart';
import 'package:good_grandma/common/store.dart';
import 'package:good_grandma/pages/home/index_page.dart';
import 'package:good_grandma/pages/login/login.dart';
import 'package:good_grandma/provider/indexProvider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() async {
  await Store.init();
  // runApp(MyApp());
  initializeDateFormatting().then((_) => runApp(MyApp()));
  setupStatusBar();
}

class MyApp extends StatelessWidget  {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<IndexProvider>(create: (_) => IndexProvider()),
      ],
      child: MaterialApp(
        title: '好阿婆',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.FFF4F5F8,
          brightness: Brightness.light,
          appBarTheme: AppBarTheme(
            brightness: Brightness.light,
            color: Colors.white,
            centerTitle: true,
            shadowColor: Colors.black26,
            iconTheme: IconThemeData(color: Colors.black87),
            actionsIconTheme: IconThemeData(color: Colors.black87),
            textTheme: TextTheme(
              headline6: TextStyle(color: Colors.black87, fontSize: 18),
            ),
          ),
          cardTheme: CardTheme(
            shadowColor: Colors.black26,
            elevation: 3,
          ),
        ),
        home: (Store.readToken() == null || Store.readToken().isEmpty) ? LoginPage() : IndexPage(),
      ),
    );
  }
}

///配置状态栏和文字颜色
void setupStatusBar() {
  SystemUiOverlayStyle dark = SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0xFF000000),
    systemNavigationBarDividerColor: null,
    statusBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  );
  SystemChrome.setSystemUIOverlayStyle(dark);
}
