import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import './Dio.dart';
import '../Const.dart';
import '../Models/QuestionFilterOption.dart';
import '../Models/QuestionInfo.dart';

Future<bool> isLogin() async {
  var responses = await Future.wait([
    dio.get('http://www2.sixun.com.cn/Account/PersonInfo/'),
    dio.get('http://www2.sixun.com.cn/webqa/SysSet/GenPwd.aspx'),
  ]);
  bool _needLogin = false;
  for (var response in responses) _needLogin |= response.isRedirect;

  return !_needLogin;
}

Future<dynamic> login(String agentID, String userID, String password) async {
  final response =
      await dio.post<Map>('http://www2.sixun.com.cn/Account/AjaxLogin', data: {
    'CustNo': agentID,
    'OperId': userID,
    'PasswordForNormal': password,
    'ValidateCodeForNormal': 'yes',
  });
  if (!response.data['Success'] && response.data['Message'] != null) {
    return response.data['Message'];
  }

  final date = DateUtil.getDateStrByDateTime(
    DateTime.now(),
    format: DateFormat.YEAR_MONTH_DAY,
  ).replaceAll('-', '');
  try {
    await dio.get(
      'http://www2.sixun.com.cn/WebQA/LoginFromKC.aspx?token=$agentID:$userID:::$date',
      options: Options(followRedirects: false),
    );
  } catch (e) {}
  return true;
}

Future<dynamic> getQuestionList({
  String viewState = '',
  String eventValidation = '',
  int page = 1,
  QuestionFilterOption filterOption,
}) async {
  const url = 'http://www2.sixun.com.cn/webqa/QA/BrowseQuestions.aspx';

  if (filterOption == null) filterOption = QuestionFilterOption();

  if (viewState.isEmpty || eventValidation.isEmpty) {
    var r = getViewStateAndEventValidation((await dio.get(url)).data);
    viewState = r['ViewState'];
    eventValidation = r['EventValidation'];
  }

  var body = {
    '__VIEWSTATE': viewState,
    '__EVENTVALIDATION': eventValidation,
    r'ctl00$Content$txtFromDate': DateUtil.getDateStrByDateTime(
      filterOption.startTime,
      format: DateFormat.YEAR_MONTH_DAY,
    ),
    r'ctl00$Content$txtToDate': DateUtil.getDateStrByDateTime(
      filterOption.endTime,
      format: DateFormat.YEAR_MONTH_DAY,
    ),
  };
  if (page == 1) {
    body.addAll({
      r'ctl00$Content$dropVersion': '', //TODO
      r'ctl00$Content$dropType': filterOption.searchType == null
          ? ''
          : (filterOption.searchType.index + 1).toString(),
      r'ctl00$Content$txtText': filterOption.searchText ?? '',
      r'ctl00$Content$btnFind': '',
    });
  } else {
    body.addAll({
      '__EVENTTARGET': r'ctl00$Content$gridQuestions',
      '__EVENTARGUMENT': 'Page\$$page',
    });
  }

  var response = await dio.post(url, data: body);

  var questionList = List<QuestionInfo>();
  var data = response.data.toString();
  if (data.indexOf('id="ctl00_Content_gridQuestions"') == -1) {
    final vsAev = getViewStateAndEventValidation(response.data);
    return {
      'HasNextPage': false,
      'QuestionList': questionList,
      'ViewState': vsAev['ViewState'],
      'EventValidation': vsAev['EventValidation'],
    };
  }
  var endIndex = data.indexOf('javascript:__doPostBack');
  data = data.substring(
    data.indexOf('id="ctl00_Content_gridQuestions"'),
    endIndex == -1 ? data.length : endIndex,
  );
  final regExp = RegExp(
      r'<td>.+?>(.+?)<(?:.|\s)+?<a.+?>(.+?)<(?:.|\s)+?<div.+?>\s+(.*?)\s+?</div>(?:.|\s)+?<font.+?>(.+?)<(?:.|\s)+?<span.+?>\s+(.+?)\s+?<(?:.|\s)+?<div.+?>\s+(.+?)\s+?</d(?:.|\s)+?<font.+?>(.+?)<.+?<font.+?>(.+?)<.+?<font.+?>(.+?)<');
  for (var match in regExp.allMatches(data)) {
    questionList.add(QuestionInfo(
      createAt: DateTime.parse(match.group(1)),
      id: match.group(2),
      title: match.group(3),
      product: match.group(4),
      state: QuestionInfo.getStateID(match.group(5)),
      endUser: match.group(6),
      creator: match.group(9),
    ));
  }

  final hasNextPage = RegExp('Page\\\$${page + 1}').hasMatch(response.data);
  final vsAev = getViewStateAndEventValidation(response.data);

  return {
    'HasNextPage': hasNextPage,
    'QuestionList': questionList,
    'ViewState': vsAev['ViewState'],
    'EventValidation': vsAev['EventValidation'],
  };
}

Future<QuestionInfo> getQuestionInfo(String id) async {
  Response response;
  RegExp regExp;
  Match match;
  QuestionInfo questionInfo;
  final url = 'http://www2.sixun.com.cn/webqa/QA/ShowQuestion.aspx?RecNo=$id';

  response = await dio.get(url);
  regExp = RegExp(
      r'lblTitle">(.*?)<(?:.|\s)+?lblRecNo">(.+?)<(?:.|\s)+?lblVersion">(.+?)<(?:.|\s)+?lblStatus">(.+?)<(?:.|\s)+?lblAddedBy">(.+?)<(?:.|\s)+?lblEmail">(.*?)<(?:.|\s)+?lblMobile">(.+?)<(?:.|\s)+?lblAddedDate">(.+?)<(?:.|\s)+?lblPhone">(.*?)<(?:.|\s)+?lblEndUser">(.*?)<(?:.|\s)+?lblHandler">(.*?)<(?:.|\s)+?lblStartDate">(.*?)<(?:.|\s)+?lblFinishDate">(.*?)<(?:.|\s)+?lblPoints".+?>(.+?)<(?:.|\s)+?lblVID".+?>(.+?)<(?:.|\s)+?id="Content">\s+((?:.|\s)+?)\s+?<');
  match = regExp.firstMatch(response.data);

  questionInfo = QuestionInfo(
    title: match.group(1),
    id: match.group(2),
    product: match.group(3),
    state: QuestionInfo.getStateID(match.group(4)),
    creator: match.group(5),
    email: match.group(6),
    mobile: match.group(7),
    createAt: _parseDateTime(match.group(8)),
    phone: match.group(9),
    endUser: match.group(10),
    handler: match.group(11),
    processAt: match.group(12).isEmpty ? null : DateTime.parse(match.group(12)),
    closeAt: match.group(13).isEmpty ? null : DateTime.parse(match.group(13)),
    isCustomize: RegExp('IsCustomize".+?checked=').hasMatch(response.data),
    isChain: RegExp('IsChain".+?checked=').hasMatch(response.data),
    siteNumber: int.parse(match.group(14)),
    storeNumber: int.parse(match.group(15)),
    questionDescription:
        match.group(16).replaceAll('src="/', 'src="http://www2.sixun.com.cn/'),
  );

  regExp = RegExp(
      r'<td style="width: 33%">\s+(.+?)\s+?<(?:.|\s)+?<td style="width: 33%">\s+(.+?)\s+?<(?:.|\s)+?<div style="color: Red">\s+((?:.|\s)+?)\s+?</div>');
  for (var match in regExp.allMatches(response.data)) {
    questionInfo.answers.add(AnswerInfo(
      handler: match.group(2),
      answerAt: _parseDateTime(match.group(1)),
      answerDescription:
          match.group(3).replaceAll('src="/', 'src="http://www2.sixun.com.cn/'),
    ));
  }

  return questionInfo;
}

Future<bool> postAnswer(String id, String handler, String answer) async {
  Response response;
  final url = 'http://www2.sixun.com.cn/webqa/QA/ShowQuestion.aspx?RecNo=$id';

  response = await dio.get(url);
  var r = getViewStateAndEventValidation(response.data);

  response = await dio.post(url, data: {
    '__VIEWSTATE': r['ViewState'],
    '__EVENTVALIDATION': r['EventValidation'],
    r'ctl00$Content$QuestionDetails1$btnShowFeedback': '',
  });
  r = getViewStateAndEventValidation(response.data);

  try {
    await dio.post(url, data: {
      '__VIEWSTATE': r['ViewState'],
      '__EVENTVALIDATION': r['EventValidation'],
      r'ctl00$Content$QuestionDetails1$txtAddedBy': handler,
      r'ctl00$Content$QuestionDetails1$txtBody': answer,
      r'ctl00$Content$QuestionDetails1$submit': '',
    });
  } catch (e) {}
  return true;
}

Future<bool> closeQuestion({
  @required String id,
  bool isSolve = true,
  int processResults = 5,
  int serviceAttitude = 5,
  int professionalSkill = 5,
  int processEfficiency = 5,
  String suggest = '',
}) async {
  Response response;
  final url = 'http://www2.sixun.com.cn/webqa/QA/ShowQuestion.aspx?RecNo=$id';

  response = await dio.get(url);
  var r = getViewStateAndEventValidation(response.data);

  response = await dio.post(url, data: {
    '__VIEWSTATE': r['ViewState'],
    '__EVENTVALIDATION': r['EventValidation'],
    r'ctl00$Content$QuestionDetails1$btnConfirm': '',
  });
  r = getViewStateAndEventValidation(response.data);

  try {
    await dio.post(url, data: {
      '__VIEWSTATE': r['ViewState'],
      '__EVENTVALIDATION': r['EventValidation'],
      r'ctl00$Content$QuestionDetails1$question':
          'RadioButton${isSolve ? '2' : '1'}',
      r'ctl00$Content$QuestionDetails1$radAppraise': 6 - processResults,
      r'ctl00$Content$QuestionDetails1$rb1': serviceAttitude,
      r'ctl00$Content$QuestionDetails1$rb2': professionalSkill,
      r'ctl00$Content$QuestionDetails1$rb3': processEfficiency,
      r'ctl00$Content$QuestionDetails1$TextBox1': suggest,
      r'ctl00$Content$QuestionDetails1$btnClosed': '',
    });
  } catch (e) {}
  return true;
}

Future<bool> createQuestion({
  @required String title,
  @required String endUser,
  @required String email,
  @required String mobile,
  @required String phone,
  @required String version,
  String serialNumber = '',
  @required String siteNumber,
  @required String storeNumber,
  @required String questionDescription,
  @required String creatorName,
  @required Product product,
  @required String typeID,
  bool isCustomize = false,
  bool isChain = false,
}) async {
  RegExp regExp;
  Match match;
  Response response;
  final url = 'http://www2.sixun.com.cn/webqa/QA/AddEditQuestion.aspx';
  var svAev;

  response = await dio.get(url);
  svAev = getViewStateAndEventValidation(response.data);

  response = await dio.post(url, data: {
    '__EVENTTARGET': r'ctl00$Content$Wizard1$rbl_category$' + product.eventID,
    '__VIEWSTATE': svAev['ViewState'],
    '__EVENTVALIDATION': svAev['EventValidation'],
    r'ctl00$Content$Wizard1$rbl_category': product.typeID,
    r'ctl00$Content$Wizard1$drop_version': '',
  });
  svAev = getViewStateAndEventValidation(response.data);

  response = await dio.post(url, data: {
    '__VIEWSTATE': svAev['ViewState'],
    '__EVENTVALIDATION': svAev['EventValidation'],
//        r'ctl00$Content$Wizard1$rbl_category': _product.split('_')[0],
    r'ctl00$Content$Wizard1$drop_version': product.id,
    r'ctl00$Content$Wizard1$StartNavigationTemplateContainerID$StartNextButton':
        '',
  });
  svAev = getViewStateAndEventValidation(response.data);

  response = await dio.post(url, data: {
    '__VIEWSTATE': svAev['ViewState'],
    '__EVENTVALIDATION': svAev['EventValidation'],
    '__EVENTTARGET': r'ctl00$Content$Wizard1$rblor$0',
    r'ctl00$Content$Wizard1$rblor': '1',
  });
  svAev = getViewStateAndEventValidation(response.data);

  response = await dio.post(url, data: {
    '__VIEWSTATE': svAev['ViewState'],
    '__EVENTVALIDATION': svAev['EventValidation'],
    r'ctl00$Content$Wizard1$rblor': '1',
    r'ctl00$Content$Wizard1$rbl_question': typeID,
    r'ctl00$Content$Wizard1$StepNavigationTemplateContainerID$StepNextButton':
        '',
  });
  svAev = getViewStateAndEventValidation(response.data);

  regExp = RegExp('option.+?value="(.+?)">$creatorName<');
  match = regExp.firstMatch(response.data);
  if (match == null) return false;

  try {
    await dio.post(url, data: {
      '__VIEWSTATE': svAev['ViewState'],
      '__EVENTVALIDATION': svAev['EventValidation'],
      r'ctl00$Content$Wizard1$txtTitle': title,
      r'ctl00$Content$Wizard1$txtBb': version,
      r'ctl00$Content$Wizard1$txtEndUser': endUser,
      r'ctl00$Content$Wizard1$txtSerialNo': serialNumber,
      r'ctl00$Content$Wizard1$dropContact': match.group(1),
      r'ctl00$Content$Wizard1$txtMobile': mobile,
      r'ctl00$Content$Wizard1$txtPhone': phone,
      r'ctl00$Content$Wizard1$txtEmail': email,
      r'ctl00$Content$Wizard1$txtPoints': siteNumber,
      r'ctl00$Content$Wizard1$txtVID': storeNumber,
      r'ctl00$Content$Wizard1$txtContent': questionDescription,
      r'ctl00$Content$Wizard1$FinishNavigationTemplateContainerID$FinishButton':
          '',
    }); //TODO isCustomize
  } catch (e) {}
  return true;
}

dynamic getViewStateAndEventValidation(String content) {
  final regExp = RegExp(
      r'__VIEWSTATE" value="(.+?)"(?:.|\s)+?__EVENTVALIDATION" value="(.+?)"');
  final match = regExp.firstMatch(content);
  if (match == null || match.groupCount != 2)
    throw Error.safeToString('尝试获取ViewState和EventValidation时出错');
  return {
    'ViewState': match.group(1),
    'EventValidation': match.group(2),
  };
}

DateTime _parseDateTime(String datetimeString) {
  RegExp regExp = new RegExp(r'(\d{4})/(\d+)/(\d+) (\d+):(\d+):(\d+)');
  Match match = regExp.firstMatch(datetimeString);
  return DateTime(
    int.parse(match.group(1)),
    int.parse(match.group(2)),
    int.parse(match.group(3)),
    int.parse(match.group(4)),
    int.parse(match.group(5)),
    int.parse(match.group(6)),
  );
}
