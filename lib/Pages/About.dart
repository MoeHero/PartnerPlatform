import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../Const.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('关于 合作伙伴平台'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(60, 40, 60, 0),
            width: double.infinity,
            child: FittedBox(
              child: Center(
                child: AutoSizeText('合作伙伴平台'),
              ),
            ),
          ),
          Container(
            child: Center(
              child: Text(
                'V ' + Const.version + ' (Build ' + Const.buildNumber + ')',
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
