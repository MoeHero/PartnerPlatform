import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class UniversalPasswordPage extends StatefulWidget {
  @override
  _UniversalPasswordPageState createState() => _UniversalPasswordPageState();
}

class _UniversalPasswordPageState extends State<UniversalPasswordPage> {
  String _password = '';
  var _headerKey = GlobalKey<RefreshHeaderState>();

  @override
  void initState() {
    super.initState();
    _password = _getPassword();
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(80, 50, 80, 0),
            width: double.infinity,
            child: FittedBox(
              child: Center(
                child: AutoSizeText(
                  _password,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),
          ),
        ],
      ),
      refreshHeader: ClassicsHeader(
        key: _headerKey,
        refreshText: '下拉刷新',
        refreshReadyText: '释放立即刷新',
        refreshingText: '正在刷新...',
        refreshedText: '刷新成功',
        moreInfo: '上次刷新 %T',
        showMore: true,
        bgColor: Theme.of(context).primaryColor,
        textColor: Theme.of(context).primaryTextTheme.title.color,
        moreInfoColor: Theme.of(context).primaryTextTheme.title.color,
      ),
      onRefresh: () {
        setState(() => _password = _getPassword());
      },
    );
  }

  String _getPassword() {
    var date = DateTime.now().add(Duration(days: 35));
    var year = ((date.year + 168) * 2).toString();
    var month = (date.month * 12).toString();
    month = month.substring(month.length - 2);
    var day = (date.day * 168).toString().substring(1, 3);
    return year + month + day;
  }
}
