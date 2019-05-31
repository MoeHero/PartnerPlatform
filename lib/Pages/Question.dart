import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../Api/TSP.dart';
import '../Models/QuestionFilterOption.dart';
import '../Models/QuestionInfo.dart';
import '../Pages/QuestionDetails.dart';

class QuestionPage extends StatefulWidget {
  _QuestionPageState state;

  @override
  _QuestionPageState createState() {
    state = _QuestionPageState();
    return state;
  }
}

class _QuestionPageState extends State<QuestionPage>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  int _page = 1;
  bool _isLoading = true, _hasNextPage = false;
  String _viewState, _eventValidation;
  var _questionList = <QuestionInfo>[];
  var filterOption = QuestionFilterOption();

  var refreshKey = GlobalKey<EasyRefreshState>();
  var _headerKey = GlobalKey<RefreshHeaderState>();
  var _footerKey = GlobalKey<RefreshFooterState>();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _init();
  }

  void _init() async {
    var r = await getQuestionList(filterOption: filterOption);
    _viewState = r['ViewState'];
    _eventValidation = r['EventValidation'];
    setState(() {
      _hasNextPage = r['HasNextPage'];
      _questionList = r['QuestionList'];
      _isLoading = false;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    refreshKey.currentState.callRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : EasyRefresh(
            key: refreshKey,
            autoLoad: true,
            child: _questionList.length == 0
                ? Container(
                    height: 60,
                    child: Center(
                      child: Text(
                        '暂无数据',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    itemCount: _questionList.length,
                    itemBuilder: (_, i) => _buildRow(_questionList[i]),
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
            refreshFooter: ClassicsFooter(
              key: _footerKey,
              loadText: '加载下页',
              loadReadyText: '释放加载下页',
              loadingText: '正在加载...',
              loadedText: '加载完成',
              noMoreText: '没有更多问题',
              bgColor: Colors.transparent,
              textColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
            ),
            onRefresh: () async {
              _page = 1;
              var r = await getQuestionList(filterOption: filterOption);
              _viewState = r['ViewState'];
              _eventValidation = r['EventValidation'];
              setState(() {
                _hasNextPage = r['HasNextPage'];
                _questionList = r['QuestionList'];
              });
            },
            loadMore: () async {
              if (!_hasNextPage) return false;
              _page++;
              var r = await getQuestionList(
                page: _page,
                viewState: _viewState,
                eventValidation: _eventValidation,
                filterOption: filterOption,
              );
              _viewState = r['ViewState'];
              _eventValidation = r['EventValidation'];
              setState(() {
                _hasNextPage = r['HasNextPage'];
                _questionList.addAll(r['QuestionList']);
              });
            },
          );
  }

  Widget _buildRow(QuestionInfo info) {
    return Card(
      child: InkWell(
        onTap: () {
          QuestionDetailsPage.show(context, info.id);
        },
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(7, 5, 0, 5),
                child: Column(
                  children: <Widget>[
                    _buildTitleLine(info),
                    _buildProductLine(info),
                    _buildEndUserLine(info),
                  ],
                ),
              ),
            ),
            Container(
              width: 23,
              child: Center(
                child: Icon(Icons.navigate_next, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleLine(QuestionInfo info) {
    return Row(
      children: <Widget>[
        Container(
          width: 50,
          child: Text(
            info.getStateText(),
            style: TextStyle(color: info.getStateColor()),
          ),
        ),
        Expanded(
          child: Text(
            info.title,
            style: Theme.of(context).textTheme.subhead,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        Container(
          width: 95,
          child: Text(
            info.id,
            style: Theme.of(context).textTheme.caption,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildProductLine(QuestionInfo info) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(info.product, style: Theme.of(context).textTheme.caption),
        ),
        Container(
          width: 70,
          child: Text(
            DateUtil.getDateStrByDateTime(info.createAt,
                format: DateFormat.YEAR_MONTH_DAY),
            style: Theme.of(context).textTheme.caption,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildEndUserLine(QuestionInfo info) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(info.endUser, style: Theme.of(context).textTheme.caption),
        ),
        Container(
          width: 40,
          child: Text(
            info.creator,
            style: Theme.of(context).textTheme.caption,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
