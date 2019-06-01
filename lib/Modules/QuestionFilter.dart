import 'package:common_utils/common_utils.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:flutter/material.dart';

import '../Models/QuestionFilterOption.dart';

class QuestionFilterDialog extends Dialog {
  final QuestionFilterOption _filterOption;

  QuestionFilterDialog(this._filterOption);

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
                color: Theme.of(context).dialogBackgroundColor,
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
                            '问题过滤',
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
                      child: QuestionFilter(_filterOption),
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

class QuestionFilter extends StatefulWidget {
  final QuestionFilterOption _filterOption;

  QuestionFilter(this._filterOption);

  @override
  _QuestionFilterState createState() => _QuestionFilterState();
}

class _QuestionFilterState extends State<QuestionFilter> {
  final _textKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Center(
            child: Text('日期范围', style: Theme.of(context).textTheme.subhead),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                child: Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      Text(
                        DateUtil.getDateStrByDateTime(
                          widget._filterOption.startTime,
                          format: DateFormat.YEAR_MONTH_DAY,
                        ),
                        style: Theme.of(context).textTheme.subhead,
                      ),
                      Text(' 到 ', style: Theme.of(context).textTheme.subhead),
                      Text(
                        DateUtil.getDateStrByDateTime(
                          widget._filterOption.endTime,
                          format: DateFormat.YEAR_MONTH_DAY,
                        ),
                        style: Theme.of(context).textTheme.subhead,
                      ),
                      Icon(Icons.navigate_next, color: Colors.grey),
                    ],
                  ),
                ),
                onTap: () async {
                  final dateTime = await DateRagePicker.showDatePicker(
                    context: context,
                    initialFirstDate: widget._filterOption.startTime,
                    initialLastDate: widget._filterOption.endTime,
                    firstDate: DateTime(1970),
                    lastDate: DateTime.now(),
                  );
                  if (dateTime == null) return;
                  setState(() {
                    widget._filterOption.startTime = dateTime[0];
                    widget._filterOption.endTime = dateTime[1];
                  });
                },
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Flexible(
                child: DropdownButton(
                  value: widget._filterOption.searchType,
                  items: [
                    DropdownMenuItem(
                      child: Text('问题编号'),
                      value: SearchType.ID,
                    ),
                    DropdownMenuItem(
                      child: Text('问题标题'),
                      value: SearchType.Title,
                    ),
                    DropdownMenuItem(
                      child: Text('创建人'),
                      value: SearchType.Creator,
                    ),
                    DropdownMenuItem(
                      child: Text('最终用户'),
                      value: SearchType.EndUser,
                    ),
                    DropdownMenuItem(
                      child: Text('问题描述'),
                      value: SearchType.Content,
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => widget._filterOption.searchType = value);
                  },
                ),
              ),
              Flexible(
                flex: 2,
                child: TextFormField(
                  key: _textKey,
                  initialValue: widget._filterOption.searchText,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 10, bottom: 2),
                  ),
                  onSaved: (value) {
                    widget._filterOption.searchText = value;
                  },
                ),
              ),
            ],
          ),
          Container(height: 20),
          RaisedButton(
            child: Text('确定'),
            color: Theme.of(context).primaryColor,
            textColor: Theme.of(context).primaryTextTheme.button.color,
            onPressed: () {
              _textKey.currentState.save();

              Navigator.pop(context, widget._filterOption);
            },
          ),
        ],
      ),
    );
  }
}
