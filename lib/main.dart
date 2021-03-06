import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/pages/learning/learning_page_view.dart';
import 'package:flutter_demo/pages/mine/mine_page_veiw.dart';
import 'package:flutter_demo/provide/global_provide.dart';
import 'package:flutter_demo/route.dart';
import 'package:flutter_demo/service/api_service.dart';
import 'package:flutter_demo/utils/route_observer_util.dart';
import 'package:flutter_demo/utils/style_util.dart';
import 'package:flutter_demo/utils/toast_util.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil.getInstance();
  ApiService.initialize();
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      //设置状态栏透明
      statusBarColor: Colors.transparent,
    ));
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GlobalProvide(),
      child: MaterialApp(
        builder: BotToastInit(),
        navigatorObservers: [
          BotToastNavigatorObserver(),
          RouteObserverUtil.routeObserver,
        ],
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // 路由配置
        onGenerateRoute: onGenerateRoute,
        // 全局状态配置
        home: Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const List<Map<String, dynamic>> tabItems = [
    {
      'icon': Icons.menu_book_rounded,
      'label': '学习',
    },
    {
      'icon': Icons.explore,
      'label': '发现',
    },
    {
      'icon': Icons.account_circle_rounded,
      'label': '我的',
    },
  ];

  int _curIndex = 0;
  Widget _curBody = LearningPageView();

  DateTime _lastQuitTime;

  void _onBarTap(int index) {
    if (_curIndex == index) return;
    switch (index) {
      case 0:
        _curBody = LearningPageView();
        break;
      case 1:
        break;
      case 2:
        _curBody = MinePageView();
        break;
    }
    setState(() {
      _curIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    getGlobalProvide(context).tryAutoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        // 退出确认
        onWillPop: () async {
          if (_lastQuitTime == null ||
              DateTime.now().difference(_lastQuitTime).inSeconds > 1) {
            ToastUtil.showText(text: '再按一次退出');
            _lastQuitTime = DateTime.now();
            return false;
          } else {
            await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            return true;
          }
        },
        child: _curBody,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onBarTap,
        currentIndex: _curIndex,
        fixedColor: ColorM.G2,
        items: tabItems
            .map((e) => BottomNavigationBarItem(
                icon: Icon(e['icon']), label: e['label']))
            .toList(),
      ),
    );
  }
}
