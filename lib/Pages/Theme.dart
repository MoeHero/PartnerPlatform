import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';

import '../Const.dart';

class ThemePage extends StatefulWidget {
  @override
  _ThemePageState createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  var _selectIndex;

  @override
  void initState() {
    super.initState();
    _selectIndex = Const.themeColorIndex;
  }

  @override
  Widget build(BuildContext context) {
    var colorOption = <Widget>[
      ListTile(
        title: Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          children: <Widget>[
            Container(width: 20, height: 20, color: Colors.black),
            Container(width: 10),
            Text('夜间模式'),
          ],
        ),
        trailing: Theme.of(context).brightness == Brightness.dark
            ? Icon(Icons.check)
            : OutlineButton(
                child: Text('切换'),
                onPressed: () {
                  Const.themeColorIndex = -1;
                  setState(() => _selectIndex = -1);
                  DynamicTheme.of(context).setBrightness(Brightness.dark);
                },
              ),
      ),
      Divider(height: 1),
    ];
    colorOption.addAll(_buildColorOption());

    return Scaffold(
      appBar: AppBar(
        title: Text('主题选择'),
      ),
      body: ListView(children: colorOption),
    );
  }

  List<Widget> _buildColorOption() {
    var _colorOptionList = <Widget>[];
    for (var i = 0; i < Const.colorMap.length; i++) {
      final key = Const.colorMap.keys.toList()[i];
      final color = Const.colorMap[key];
      _colorOptionList.addAll([
        ListTile(
          title: Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            children: <Widget>[
              Container(width: 20, height: 20, color: color),
              Container(width: 10),
              Text(key),
            ],
          ),
          trailing: i == _selectIndex
              ? Icon(Icons.check)
              : OutlineButton(
                  child: Text('切换'),
                  onPressed: () {
                    DynamicTheme.of(context).setThemeData(
                      ThemeData(
                        primaryColor: color,
                        accentColor: color,
                        //TODO COLOR
                      ),
                    );
                    Const.themeColorIndex = i;
                    setState(() => _selectIndex = i);
                  },
                ),
        ),
        Divider(height: 1),
      ]);
    }
    return _colorOptionList;
  }
}
