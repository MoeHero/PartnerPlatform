import 'package:flutter/material.dart';

class PartnerPlatformTheme {
  String themeName;
  ThemeData themeData;
  Color themeColor;
  bool isDefault;

  PartnerPlatformTheme({
    @required this.themeName,
    @required this.themeData,
    this.themeColor,
    this.isDefault = false,
  }) {
    themeColor ??= themeData.primaryColor;
  }

  static PartnerPlatformTheme getDefaultTheme() {
    for (var theme in themeMap) {
      if (theme.isDefault) return theme;
    }
    return themeMap[0];
  }

  static final themeMap = <PartnerPlatformTheme>[
    PartnerPlatformTheme(
      themeName: '夜间模式',
      themeData: ThemeData(brightness: Brightness.dark),
    ),
    PartnerPlatformTheme(
      themeName: 'OLED模式(WIP)',
      themeData: ThemeData(
        primaryColor: Colors.grey[900],
        accentColor: Colors.grey,
        cardColor: Colors.grey[900],
        bottomAppBarColor: Colors.grey[900],
        dialogBackgroundColor: Colors.black,
        canvasColor: Colors.black,
        brightness: Brightness.dark,
      ),
    ),
    PartnerPlatformTheme(
      themeName: '胖次蓝',
      themeData: ThemeData(primaryColor: Colors.blue),
      isDefault: true,
    ),
    PartnerPlatformTheme(
      themeName: '简洁白(WIP)',
      themeData: ThemeData(primaryColor: Colors.grey[100]),
    ),
    PartnerPlatformTheme(
      themeName: '少女粉',
      themeData: ThemeData(primaryColor: Colors.pink[300]),
    ),
    PartnerPlatformTheme(
      themeName: '姨妈红',
      themeData: ThemeData(primaryColor: Colors.red),
    ),
    PartnerPlatformTheme(
      themeName: '活力橘',
      themeData: ThemeData(primaryColor: Colors.orangeAccent[700]),
    ),
    PartnerPlatformTheme(
      themeName: '咸蛋黄',
      themeData: ThemeData(primaryColor: Colors.yellow),
    ),
    PartnerPlatformTheme(
      themeName: '早苗绿',
      themeData: ThemeData(primaryColor: Colors.green[600]),
    ),
    PartnerPlatformTheme(
      themeName: '基佬紫',
      themeData: ThemeData(primaryColor: Colors.purple),
    ),
    PartnerPlatformTheme(
      themeName: '咖啡棕',
      themeData: ThemeData(primaryColor: Colors.brown),
    ),
  ];
}
