import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_utils/common_utils.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as Dom;
import 'package:oktoast/oktoast.dart';

import '../Api/TSP.dart';
import '../Const.dart';
import '../Models/QuestionInfo.dart';
import '../Modules/CloseQuestion.dart';
import '../Modules/ImageList.dart';
import '../Pages/PinchZoomImage.dart';

class QuestionDetailsPage extends StatefulWidget {
  final String _id;

  QuestionDetailsPage(this._id);

  static show(BuildContext context, String id) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (BuildContext context) {
        return QuestionDetailsPage(id);
      }),
    );
  }

  @override
  _QuestionDetailsPageState createState() => _QuestionDetailsPageState();
}

class _QuestionDetailsPageState extends State<QuestionDetailsPage> {
  String _answer = '', _handler = '';
  bool _isLoading = true;
  QuestionInfo _questionInfo;
  var _imageList = <String>[];
  final _formKey = GlobalKey<FormState>();
  final _headerKey = GlobalKey<RefreshHeaderState>();
  final _answerFocusNode = FocusNode();

  final TextEditingController _controller = TextEditingController();
  final GlobalKey _textFieldKey = GlobalKey();
  var _textFieldMaxLines = 3;

  @override
  void initState() {
    super.initState();
    _getQuestionInfo();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    //TODO 等待移除

    if (_controller.text.isEmpty) return;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(text: _controller.text),
    );
    textPainter.layout();

    var maxLines = _textFieldMaxLines;
    var textHeight = textPainter.height;

    textPainter.maxLines = maxLines;
    textPainter.layout();

    var inputHeight = textPainter.height;

    if (inputHeight >= textHeight) {
      while (inputHeight >= textHeight && maxLines > 1) {
        maxLines -= 1;
        textPainter.maxLines = maxLines;
        textPainter.layout();
        inputHeight = textPainter.height;
      }
      maxLines++;
    } else if (inputHeight < textHeight) {
      while (inputHeight < textHeight) {
        maxLines += 1;
        textPainter.maxLines = maxLines;
        textPainter.layout();
        inputHeight = textPainter.height;
      }
    }

    setState(() => _textFieldMaxLines = max(maxLines, 3));
  }

  Future<void> _getQuestionInfo() async {
    var questionInfo = await getQuestionInfo(widget._id);
    setState(() {
      _questionInfo = questionInfo;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var _body = _isLoading
        ? Center(child: CircularProgressIndicator())
        : EasyRefresh(
            child: _build(),
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
            onRefresh: () async {
              var questionInfo = await getQuestionInfo(widget._id);
              setState(() => _questionInfo = questionInfo);
            },
          );

    return Scaffold(
      body: _body,
      appBar: AppBar(
        title: Text('问题详情'),
      ),
    );
  }

  Widget _build() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTitleLine(),
              _buildProductLine(),
              _buildEndUserLine(),
              _buildCloseDate(),
              Container(
                width: double.infinity,
                child: ExpandableNotifier(
                  controller: ExpandableController(false),
                  child: ExpandablePanel(
                    header: Builder(builder: (context) {
                      return Center(
                        child: Icon(
                          ExpandableController.of(context).expanded
                              ? Icons.expand_less
                              : Icons.expand_more,
                          color: Colors.grey,
                          size: 22,
                        ),
                      );
                    }),
                    expanded: _buildMore(),
                    tapHeaderToExpand: true,
                    hasIcon: false,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(),
        _buildQuestionDescription(),
        Divider(),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text('问题回复', style: Theme.of(context).textTheme.subhead),
        ),
        Container(height: 5),
        _buildAnswers(),
        _buildAnswerBox(),
      ],
    );
  }

  Widget _buildTitleLine() {
    return Row(
      children: <Widget>[
        Container(
          width: 50,
          child: Text(
            _questionInfo.getStateText(),
            style: TextStyle(color: _questionInfo.getStateColor()),
          ),
        ),
        Expanded(
          child: Text(
            _questionInfo.title,
            style: Theme.of(context).textTheme.subhead,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        Container(
          width: 100,
          child: Text(
            _questionInfo.id,
            style: Theme.of(context).textTheme.caption,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildProductLine() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            _questionInfo.product,
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        Container(
          width: 120,
          child: Text(
            DateUtil.getDateStrByDateTime(_questionInfo.createAt),
            style: Theme.of(context).textTheme.caption,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildEndUserLine() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(_questionInfo.endUser,
              style: Theme.of(context).textTheme.caption),
        ),
        Container(
          width: 40,
          child: Text(
            _questionInfo.creator,
            style: Theme.of(context).textTheme.caption,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildCloseDate() {
    return _questionInfo.closeAt == null
        ? Container()
        : Text(
            '确认时间: ${DateUtil.getDateStrByDateTime(_questionInfo.createAt)}',
            style: Theme.of(context).textTheme.caption,
            textAlign: TextAlign.right,
          );
  }

  Widget _buildMore() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (_questionInfo.handler.isEmpty || _questionInfo.processAt == null)
            ? Container()
            : Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '处理人: ${_questionInfo.handler}',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                  Container(
                    width: 180,
                    child: Text(
                      '处理时间: ${DateUtil.getDateStrByDateTime(_questionInfo.processAt)}',
                      style: Theme.of(context).textTheme.caption,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
        Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Text(
                '站点数: ${_questionInfo.siteNumber}',
                style: Theme.of(context).textTheme.caption,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '门店数: ${_questionInfo.storeNumber}',
                style: Theme.of(context).textTheme.caption,
                textAlign: TextAlign.right,
              ),
            ),
            _questionInfo.isCustomize
                ? Expanded(
                    child: Text(
                      '客户化',
                      style: Theme.of(context).textTheme.caption,
                      textAlign: TextAlign.right,
                    ),
                  )
                : Text(''),
            _questionInfo.isChain
                ? Expanded(
                    child: Text(
                      '连锁店',
                      style: Theme.of(context).textTheme.caption,
                      textAlign: TextAlign.right,
                    ),
                  )
                : Text(''),
          ],
        ),
        Text(
          '邮箱: ${_questionInfo.email}',
          style: Theme.of(context).textTheme.caption,
        ),
        Text(
          '手机: ${_questionInfo.mobile}',
          style: Theme.of(context).textTheme.caption,
        ),
        Text(
          '电话: ${_questionInfo.phone}',
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }

  Widget _buildQuestionDescription() {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text('问题描述', style: Theme.of(context).textTheme.subhead),
          ),
          _buildHtml(_questionInfo.questionDescription),
        ],
      ),
    );
  }

  Widget _buildAnswers() {
    var answerList = <Widget>[];

    for (int i = 0; i < _questionInfo.answers.length; i++) {
      answerList.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: <Widget>[
                Container(
                  width: 40,
                  child: Text(
                    '${i + 1}楼',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
                Expanded(child: Text(_questionInfo.answers[i].handler)),
                Container(
                  width: 120,
                  child: Text(
                    DateUtil.getDateStrByDateTime(
                        _questionInfo.answers[i].answerAt),
                    style: Theme.of(context).textTheme.caption,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          _buildHtml(_questionInfo.answers[i].answerDescription),
          Divider(),
        ],
      ));
    }
    if (_questionInfo.answers.length == 0) {
      answerList.add(Container(
        child: Center(
          child: Text(
            '暂无数据',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      ));
    }

    return Column(children: answerList);
  }

  Widget _buildAnswerBox() {
    if (_questionInfo.state < 2) return Container();

    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 15),
      child: ExpandableNotifier(
        controller: ExpandableController(false),
        child: ExpandablePanel(
          header: Center(
            child: Builder(builder: (context) {
              var isExpanded = ExpandableController.of(context).expanded;
              return Row(
                children: <Widget>[
                  Text(
                    '提交回复',
                    style: TextStyle(fontSize: 17),
                  ),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey,
                    size: 22,
                  ),
                ],
              );
            }),
          ),
          expanded: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  initialValue: Const.realName,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: '回复人',
                    contentPadding: EdgeInsets.only(top: 10, bottom: 5),
                  ),
                  onSaved: (value) => _handler = value,
                  onFieldSubmitted: (value) =>
                      FocusScope.of(context).requestFocus(_answerFocusNode),
                  validator: (String value) =>
                      value.isEmpty ? '请输入回复人姓名' : null,
                ),
                Container(height: 10),
                TextFormField(
                  key: _textFieldKey,
                  controller: _controller,
                  focusNode: _answerFocusNode,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    border: InputBorder.none,
                    filled: true,
                  ),
                  maxLines: _textFieldMaxLines,
                  onSaved: (value) => _answer = value,
                ),
                Text(
                  '上传图片',
                  style: TextStyle(fontSize: 17),
                ),
                ImageList((urlList) => _imageList = urlList),
                Align(
                  alignment: Alignment.centerRight,
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    child: Text(
                      '提交回复',
                      style: Theme.of(context).primaryTextTheme.button,
                    ),
                    onPressed: () async {
                      if (!_formKey.currentState.validate()) return;
                      _formKey.currentState.save();
                      if (_answer.isEmpty && _imageList.length == 0) {
                        showToast('请输入回复或者提交图片!');
                        return;
                      }

                      var html = '';
                      for (var imageUrl in _imageList) {
                        html += '<img src="$imageUrl" />';
                      }
                      if (_answer.isNotEmpty) {
                        for (var line in _answer.split('\n')) {
                          html += '<p>$line</p>';
                        }
                      }
                      setState(() => _isLoading = true);
                      await postAnswer(widget._id, _handler, html);
                      showToast('提交成功!');
                      await _getQuestionInfo();
                    },
                  ),
                ),
              ],
            ),
          ),
          collapsed: Align(
            alignment: Alignment.centerLeft,
            child: RaisedButton(
              color: Colors.red,
              textColor: Colors.white,
              child: Text('关闭问题'),
              onPressed: () async {
                final evaluation = await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) => CloseQuestionDialog(),
                );
                if (evaluation == null) return;
                setState(() => _isLoading = true);
                await closeQuestion(
                  id: widget._id,
                  isSolve: evaluation['QuestionIsSolve'],
                  processResults: evaluation['ProcessResults'].toInt(),
                  serviceAttitude: evaluation['ServiceAttitude'].toInt(),
                  professionalSkill: evaluation['ProfessionalSkill'].toInt(),
                  processEfficiency: evaluation['ProcessEfficiency'].toInt(),
                  suggest: evaluation['Suggest'],
                );
                showToast('关闭成功!');
                await _getQuestionInfo();
              },
            ),
          ),
          tapHeaderToExpand: true,
          hasIcon: false,
        ),
      ),
    );
  }

  Widget _buildHtml(String htmlData) {
    return Html(
      blockSpacing: 0,
      data: htmlData,
      padding: EdgeInsets.symmetric(horizontal: 10),
      linkStyle: TextStyle(color: Colors.blueAccent),
      customRender: _htmlImageRender,
    );
  }

  Widget _htmlImageRender(Dom.Node node, List<Widget> children) {
    if (node is Dom.Element && node.localName == 'img') {
      Widget image;
      ImageProvider imageProvider;
      final src = node.attributes['src'];

      if (src == null) return Container();
      if (src.startsWith('data:image') && src.contains('base64,')) {
        imageProvider = MemoryImage(base64.decode(
          src.split('base64,')[1].trim(),
        ));
        image = Image(image: imageProvider);
      } else {
        imageProvider = NetworkImage(src);
        image = CachedNetworkImage(
          imageUrl: src,
          placeholder: (context, url) {
            return Center(
              child: Column(
                children: <Widget>[
                  Container(height: 10),
                  CircularProgressIndicator(),
                  Container(height: 10),
                  Text('图片加载中...'),
                ],
              ),
            );
          },
          errorWidget: (context, url, error) {
            return Center(
              child: Column(
                children: <Widget>[
                  Icon(Icons.broken_image, size: 70, color: Colors.grey),
                  Text('图片加载失败'),
                ],
              ),
            );
          },
        );
      }

      return Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: InkWell(
          child: Hero(
            tag: hex.encode(md5.convert(Utf8Encoder().convert(src)).bytes),
            child: image,
          ),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () => PinchZoomImagePage.show(context, imageProvider),
        ),
      );
    }
    return null;
  }
}
