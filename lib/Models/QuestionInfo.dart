import 'package:flutter/material.dart';

class QuestionInfo {
  String title;
  String id;
  String product;
  int state;
  String creator;
  String email;
  String mobile;
  DateTime createAt;
  String phone;
  String endUser;
  String handler;
  DateTime processAt;
  DateTime closeAt;
  bool isCustomize;
  bool isChain;
  int siteNumber;
  int storeNumber;
  String questionDescription;
  var answers = <AnswerInfo>[];

  QuestionInfo({
    @required this.title,
    @required this.id,
    @required this.product,
    @required this.state,
    @required this.creator,
    this.email = '',
    this.mobile = '',
    @required this.createAt,
    this.phone = '',
    this.endUser = '',
    this.handler = '',
    this.processAt,
    this.closeAt,
    this.isCustomize = false,
    this.isChain = false,
    this.siteNumber = 0,
    this.storeNumber = 0,
    this.questionDescription = '',
  });

  static int getStateID(String state) {
    switch (state) {
      case '关闭':
      case '已评价':
        return 0;
      case '处理中':
        return 1;
      case '待处理':
        return 2;
      case '待用户确认':
        return 3;
      default:
        return -1;
    }
  }

  String getStateText() {
    switch (state) {
      case 0:
        return '已关闭';
      case 1:
        return '处理中';
      case 2:
        return '待处理';
      case 3:
        return '待确认';
      default:
        return '未知';
    }
  }

  Color getStateColor() {
    switch (state) {
      case 0:
        return Colors.grey;
      case 1:
        return Colors.red;
      case 2:
        return Colors.deepOrange;
      case 3:
        return Colors.lightBlue;
      default:
        return Colors.grey[700];
    }
  }
}

class AnswerInfo {
  String handler;
  DateTime answerAt;
  String answerDescription;

  AnswerInfo({
    @required this.handler,
    @required this.answerAt,
    @required this.answerDescription,
  });
}
