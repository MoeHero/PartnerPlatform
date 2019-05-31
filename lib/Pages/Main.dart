import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';

import './Question.dart';
import './UniversalPassword.dart';
import '../Api/UpdateChecker.dart';
import '../Modules/QuestionFilter.dart';
import '../Modules/TSPDrawer.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _pageIndex = 0, _lastClickTime = 0;
  var _pageController = PageController(initialPage: 0);
  var _pageList = <Page>[];

  @override
  void initState() {
    super.initState();
    UpdateChecker.check(context);
    _pageList.addAll(
      <Page>[
        Page(
          name: '问题查询',
          page: QuestionPage(),
          icon: Icons.search,
        ),
        Page(
          name: '万能密码查询',
          page: UniversalPasswordPage(),
          icon: Icons.lock_outline,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        child: PageView.builder(
          itemCount: _pageList.length,
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, int index) => _pageList[index].page,
        ),
        onWillPop: () {
          int nowTime = DateTime.now().microsecondsSinceEpoch;
          if (_lastClickTime != 0 && nowTime - _lastClickTime > 2300) {
            SystemNavigator.pop();
          } else {
            _lastClickTime = nowTime;
            Future.delayed(
              Duration(milliseconds: 2300),
              () => _lastClickTime = 0,
            );
            showToast('再按一次退出');
            return Future.value(false);
          }
        },
      ),
      drawer: TSPDrawer(),
      appBar: AppBar(
        title: Text(_pageIndex == 0 ? '问题查询' : '万能密码查询'),
        actions: _pageIndex == 0
            ? <Widget>[
                IconButton(
                  icon: Icon(Icons.tune),
                  onPressed: () async {
                    QuestionPage page = _pageList[_pageIndex].page;
                    final filterOption = await showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          QuestionFilterDialog(page.state.filterOption),
                    );
                    if (filterOption == null) return;
                    page.state.filterOption = filterOption;
                    page.state.refreshKey.currentState.callRefresh();
                  },
                ),
              ]
            : [],
      ),
      floatingActionButton: _pageIndex == 0
          ? FloatingActionButton(
              tooltip: '创建问题',
              child: Icon(
                Icons.add,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () async {
                var result =
                    await Navigator.pushNamed(context, '/create_question');
                if (result != true) return;
                QuestionPage page = _pageList[_pageIndex].page;
                page.state.refreshKey.currentState.callRefresh();
              },
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BubbleBottomBar(
        opacity: .3,
        hasInk: true,
        backgroundColor: Theme.of(context).bottomAppBarColor,
        fabLocation: BubbleBottomBarFabLocation.end,
        currentIndex: _pageIndex,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 1500),
            curve: ElasticOutCurve(1),
          );
          setState(() => _pageIndex = index);
        },
        items: _pageList.map((page) {
          return BubbleBottomBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(
              page.name,
              style: Theme.of(context).textTheme.subhead,
            ),
            icon: Icon(
              page.icon,
              color: Theme.of(context).iconTheme.color,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class Page {
  String name;
  Widget page;
  IconData icon;

  Page({
    @required this.name,
    @required this.page,
    @required this.icon,
  });
}
