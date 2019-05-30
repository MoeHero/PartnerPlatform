import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';

class CloseQuestionDialog extends Dialog {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              margin: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Stack(
                      alignment: AlignmentDirectional.centerEnd,
                      children: <Widget>[
                        Center(
                          child: Text(
                            '关闭问题 - 评价',
                            style: TextStyle(fontSize: 19),
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Icon(
                              Icons.close,
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(minHeight: 180),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: CloseQuestion(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CloseQuestion extends StatefulWidget {
  @override
  _CloseQuestionState createState() => _CloseQuestionState();
}

class _CloseQuestionState extends State<CloseQuestion> {
  bool _questionIsSolve = true;
  double _processResults = 5,
      _serviceAttitude = 5,
      _professionalSkill = 5,
      _processEfficiency = 5;
  String _suggest = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('问题状态'),
              InkWell(
                onTap: () => setState(() => _questionIsSolve = true),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Radio(
                      value: true,
                      groupValue: _questionIsSolve,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (value) {
                        setState(() => _questionIsSolve = value);
                      },
                    ),
                    Text('已解决'),
                  ],
                ),
              ),
              InkWell(
                onTap: () => setState(() => _questionIsSolve = false),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Radio(
                      value: false,
                      groupValue: _questionIsSolve,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (value) {
                        setState(() => _questionIsSolve = value);
                      },
                    ),
                    Text('未解决'),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('处理结果'),
              SizedBox(width: 10),
              StarRating(
                size: 30,
                rating: _processResults,
                onRatingChanged: (double rating) {
                  setState(() => _processResults = rating);
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('服务态度'),
              SizedBox(width: 10),
              StarRating(
                size: 30,
                rating: _serviceAttitude,
                onRatingChanged: (double rating) {
                  setState(() => _serviceAttitude = rating);
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('专业技能'),
              SizedBox(width: 10),
              StarRating(
                size: 30,
                rating: _professionalSkill,
                onRatingChanged: (double rating) {
                  setState(() => _professionalSkill = rating);
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('处理效率'),
              SizedBox(width: 10),
              StarRating(
                size: 30,
                rating: _processEfficiency,
                onRatingChanged: (double rating) {
                  setState(() => _processEfficiency = rating);
                },
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              maxLines: 3,
              onChanged: (value) => _suggest = value,
              decoration: InputDecoration(
                labelText: '意见建议',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              ),
            ),
          ),
          RaisedButton(
            child: Text('提交'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: () {
              Navigator.pop(context, {
                'QuestionIsSolve': _questionIsSolve,
                'ProcessResults': _processResults,
                'ServiceAttitude': _serviceAttitude,
                'ProfessionalSkill': _professionalSkill,
                'ProcessEfficiency': _processEfficiency,
                'Suggest': _suggest,
              });
            },
          ),
        ],
      ),
    );
  }
}
