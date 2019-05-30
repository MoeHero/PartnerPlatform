import 'package:flutter/material.dart';

import '../Const.dart';

class TSPDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(
        width: MediaQuery.of(context).size.width * 0.7,
      ),
      child: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(Const.avatarUrl),
              ),
              accountName: Text(Const.realName),
              accountEmail: Text(Const.userID),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
//                  Container(
//                    color: _isRoute(context, '/question')
//                        ? Theme.of(context).highlightColor
//                        : Colors.transparent,
//                    child: ListTile(
//                      leading: Icon(Icons.search),
//                      title: Text('问题查询'),
//                      selected: _isRoute(context, '/question'),
//                      onTap: () => _pushNamed(context, '/question'),
//                    ),
//                  ),
//                  Container(
//                    color: _isRoute(context, '/password')
//                        ? Theme.of(context).highlightColor
//                        : Colors.transparent,
//                    child: ListTile(
//                      leading: Icon(Icons.lock_outline),
//                      title: Text('万能密码查询'),
//                      selected: _isRoute(context, '/password'),
//                      onTap: () => _pushNamed(context, '/password'),
//                    ),
//                  ),
//                  Divider(),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('设置'),
                    onTap: () {
                      Scaffold.of(context).openEndDrawer();
                      Navigator.pushNamed(context, '/setting');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

//  bool _isRoute(BuildContext context, String routeName) {
//    return ModalRoute.of(context).settings.name == routeName;
//  }
//
//  void _pushNamed(BuildContext context, String routeName) {
//    if (ModalRoute.of(context).settings.name == routeName) {
//      Scaffold.of(context).openEndDrawer();
//      return;
//    }
//    Navigator.pushReplacementNamed(context, routeName);
//  }
}
