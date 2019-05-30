import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';

import '../Api/Dio.dart';
import '../Api/TSP.dart';
import '../Const.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    await initDio();
    await SpUtil.getInstance();
    if (Const.themeColorIndex != -1) {
      DynamicTheme.of(context).setThemeData(
        ThemeData(
          primaryColor: Const
              .colorMap[Const.colorMap.keys.toList()[Const.themeColorIndex]],
        ),
      );
    }

    var needLogin = !await isLogin();
    if (needLogin && Const.password.isNotEmpty) {
      needLogin =
          await login(Const.agentID, Const.userID, Const.password) != true;
    }
    if (!needLogin) await Const.initConst();
    if (needLogin)
      Navigator.pushReplacementNamed(context, '/login');
    else
      Navigator.pushReplacementNamed(context, '/main');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('思迅技术支持平台', style: TextStyle(fontSize: 30)),
      ),
    );
  }
}
