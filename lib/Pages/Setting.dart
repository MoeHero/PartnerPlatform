import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('隐藏&分类(WIP)'),
            trailing: Icon(Icons.navigate_next, color: Colors.grey),
            onTap: () {
              Navigator.pushNamed(context, '/software_hide');
            },
          ),
          Divider(height: 1),
          ListTile(
            title: Text('排序(WIP)'),
            trailing: Icon(Icons.navigate_next, color: Colors.grey),
            onTap: () {},
          ),
          Divider(height: 1),
          ListTile(
            title: Text('主题颜色'),
            trailing: Icon(Icons.navigate_next, color: Colors.grey),
            onTap: () {
              Navigator.pushNamed(context, '/theme');
            },
          ),
          Divider(height: 1),
        ],
      ),
    );
  }
}
