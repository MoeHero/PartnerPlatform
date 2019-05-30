import 'package:auto_size_text/auto_size_text.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:oktoast/oktoast.dart';

import '../Api/TSP.dart';
import '../Const.dart';
import '../Modules/ImageList.dart';

class CreateQuestionPage extends StatefulWidget {
  @override
  _CreateQuestionPageState createState() => _CreateQuestionPageState();
}

class _CreateQuestionPageState extends State<CreateQuestionPage> {
  int _currentSteps = 0;

  final _formKey = GlobalKey<FormState>();
  String _title,
      _endUser,
      _email = '',
      _mobile = '',
      _phone = '',
      _version,
      _serialNumber,
      _siteNumber,
      _storeNumber,
      _questionDescription;
  int _typeIndex = 0, _creatorIndex = 0, _productTypeIndex, _productIndex;
  bool _isCustomize = false, _isChain = false;
  var _imageUrlList = <String>[];
  var _mobileController = TextEditingController(),
      _phoneController = TextEditingController(),
      _emailController = TextEditingController(),
      _endUserController = TextEditingController();
  Map<int, List<Product>> _productMap;

  final _questionTypeList = [
    QuestionType('1', '故障申报'),
    QuestionType('3', '问题咨询'),
    QuestionType('4', '数据处理'),
    QuestionType('5', '修复数据库'),
    QuestionType('6', '转换数据'),
  ];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < Const.contactsList.length; i++) {
      if (Const.contactsList[i].name != Const.realName) continue;
      _creatorIndex = i;
      _mobileController = TextEditingController(
        text: Const.contactsList[i].mobile,
      );
      _phoneController = TextEditingController(
        text: Const.contactsList[i].phone,
      );
      _emailController = TextEditingController(
        text: Const.contactsList[i].email,
      );
      break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          height: double.infinity,
          child: Stepper(
            currentStep: _currentSteps,
            onStepCancel: () {
              setState(() => _currentSteps--);
            },
            onStepContinue: () async {
              if (_currentSteps != 2) {
                setState(() => _currentSteps++);
                return;
              }
              if (!_formKey.currentState.validate()) return;
              _formKey.currentState.save();

              if (_creatorIndex == null) {
                showToast('请选择联系人!');
                return;
              }
              if (_productIndex == null) {
                showToast('请选择产品!');
                return;
              }

              var html = '';
              for (var imageUrl in _imageUrlList) {
                html += '<img src="$imageUrl" />';
              }
              if (_questionDescription.isNotEmpty) {
                for (var line in _questionDescription.split('\n')) {
                  html += '<p>$line</p>';
                }
              }

              //TODO 加载中提示
              var result = await createQuestion(
                title: _title,
                endUser: _endUser,
                email: _email,
                mobile: _mobile,
                phone: _phone,
                version: _version,
                serialNumber: _serialNumber,
                siteNumber: _siteNumber,
                storeNumber: _storeNumber,
                questionDescription: html,
                creatorName: Const.contactsList[_creatorIndex].name,
                product: _productMap[_productTypeIndex][_productIndex],
                typeID: _questionTypeList[_typeIndex].id,
                isCustomize: _isCustomize,
                isChain: _isChain,
              );
              if (!result) {
                showToast('请选择正确的联系人!');
                return;
              }

              if (!Const.endUserList.contains(_endUser)) {
                var endUserList = <String>[];
                endUserList.addAll(Const.endUserList);
                endUserList.add(_endUser);
                Const.endUserList = endUserList;
              }
              showToast('提交成功!');
              Navigator.pop(context, true);
            },
            onStepTapped: (index) {
              setState(() => _currentSteps = index);
            },
            steps: <Step>[
              Step(
                state: _getStepState(0),
                isActive: _currentSteps >= 0,
                title: Text(
                  '基本信息',
                  style: Theme.of(context).textTheme.subhead,
                ),
                content: Wrap(
                  children: <Widget>[
                    _buildBasicInfo1(),
                    _buildBasicInfo2(),
                  ],
                ),
              ),
              Step(
                state: _getStepState(1),
                isActive: _currentSteps >= 1,
                title: Text(
                  '产品信息',
                  style: Theme.of(context).textTheme.subhead,
                ),
                content: _buildProductInfo(),
              ),
              Step(
                state: _getStepState(2),
                isActive: _currentSteps >= 2,
                title: Text(
                  '问题描述',
                  style: Theme.of(context).textTheme.subhead,
                ),
                content: _buildQuestionDescription(),
              ),
            ],
            controlsBuilder: (
              BuildContext context, {
              VoidCallback onStepContinue,
              VoidCallback onStepCancel,
            }) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _currentSteps != 0
                      ? FlatButton(
                          child: Text('上一步'),
                          onPressed: onStepCancel,
                          textColor: Theme.of(context).accentColor,
                        )
                      : Container(),
                  Container(width: 10),
                  RaisedButton(
                    child: Text(_currentSteps != 2 ? '下一步' : '提 交'),
                    onPressed: onStepContinue,
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                ],
              );
            },
          ),
        ),
        onWillPop: () async {
          var result = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('你确定要退出吗?'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      '取消',
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                  ),
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(
                      '确定',
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                  ),
                ],
              );
            },
          );
          return result == null ? false : result;
        },
      ),
      appBar: AppBar(
        title: Text('创建问题'),
      ),
    );
  }

  StepState _getStepState(int index) {
    if (index == _currentSteps) {
      return StepState.editing;
    } else if (index > _currentSteps) {
      return StepState.indexed;
    } else {
      return StepState.complete;
    }
  }

  Widget _buildBasicInfo1() {
    return Wrap(
      children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.only(left: 5),
          leading: Text(
            '问题标题',
            style: TextStyle(fontSize: 18),
          ),
          title: TextFormField(
            maxLength: 20,
            autofocus: true,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: '请输入问题标题',
              counterText: '',
              border: InputBorder.none,
            ),
//            onSaved: (String value) => _title = value,
            onSaved: (value) {
              _title = value;
              print(value);
            },
            validator: (String value) {
              if (value.isEmpty) showToast('请输入问题标题!');
            },
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.only(left: 5),
          leading: Text(
            '问题类型',
            style: TextStyle(fontSize: 18),
          ),
          title: Wrap(
            alignment: WrapAlignment.end,
            children: <Widget>[
              Text(
                _typeIndex == null
                    ? '点击选择问题类型'
                    : _questionTypeList[_typeIndex].name,
                style: TextStyle(
                  color: _typeIndex == null
                      ? Theme.of(context).hintColor
                      : Theme.of(context).textTheme.subtitle.color,
                ),
              ),
              Icon(Icons.navigate_next, color: Colors.grey),
            ],
          ),
          onTap: () {
            Picker(
              selecteds: [_typeIndex],
              hideHeader: true,
              cancelText: '取消',
              confirmText: '确定',
              title: Text('选择问题类型'),
              textStyle: Theme.of(context).textTheme.title,
              backgroundColor: Theme.of(context).dialogBackgroundColor,
              adapter: PickerDataAdapter(pickerdata: _questionTypeList),
              onConfirm: (Picker picker, List value) {
                setState(() => _typeIndex = value[0]);
              },
            ).showDialog(context);
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.only(left: 5),
          leading: Text(
            '最终用户',
            style: TextStyle(fontSize: 18),
          ),
          title: TypeAheadFormField(
            hideOnEmpty: true,
            getImmediateSuggestions: true,
            animationDuration: Duration(seconds: 0),
            textFieldConfiguration: TextFieldConfiguration(
              textAlign: TextAlign.right,
              controller: _endUserController,
              decoration: InputDecoration(
                hintText: '请输入最终用户',
                counterText: '',
                border: InputBorder.none,
              ),
            ),
            onSuggestionSelected: (suggestion) {
              _endUserController.value = TextEditingValue(text: suggestion);
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion),
                trailing: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    var endUserList = Const.endUserList;
                    endUserList.remove(suggestion);
                    Const.endUserList = endUserList;
                  },
                ),
              );
            },
            suggestionsCallback: (pattern) {
              return Const.endUserList.where((value) {
                return value.contains(pattern);
              }).toList();
            },
            onSaved: (String value) => _endUser = value,
            validator: (String value) {
              if (value.isEmpty) showToast('请输入最终用户!');
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfo2() {
    return Wrap(
      children: <Widget>[
        Divider(height: 1),
        ListTile(
          contentPadding: EdgeInsets.only(left: 5),
          leading: Text(
            '联系人',
            style: TextStyle(fontSize: 18),
          ),
          title: Wrap(
            alignment: WrapAlignment.end,
            children: <Widget>[
              Text(
                _creatorIndex == null
                    ? '点击选择联系人'
                    : Const.contactsList[_creatorIndex].name,
                style: TextStyle(
                  color: _creatorIndex == null
                      ? Theme.of(context).hintColor
                      : Theme.of(context).textTheme.subtitle.color,
                ),
              ),
              Icon(Icons.navigate_next, color: Colors.grey),
            ],
          ),
          onTap: () {
            Picker(
              selecteds: [_creatorIndex],
              hideHeader: true,
              cancelText: '取消',
              confirmText: '确定',
              title: Text('选择联系人'),
              textStyle: Theme.of(context).textTheme.title,
              backgroundColor: Theme.of(context).dialogBackgroundColor,
              adapter: PickerDataAdapter(pickerdata: Const.contactsList),
              onConfirm: (Picker picker, List value) {
                setState(() => _creatorIndex = value[0]);
                final contacts = Const.contactsList[value[0]];
                _emailController.value = TextEditingValue(text: contacts.email);
                _mobileController.value =
                    TextEditingValue(text: contacts.mobile);
                _phoneController.value = TextEditingValue(text: contacts.phone);
              },
            ).showDialog(context);
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.only(left: 5),
          leading: Text(
            '邮箱',
            style: TextStyle(fontSize: 18),
          ),
          title: TextFormField(
            controller: _emailController,
            textAlign: TextAlign.right,
            keyboardType: TextInputType.emailAddress,
            inputFormatters: [
              WhitelistingTextInputFormatter(RegExp('[0-9a-z@.]'))
            ],
            decoration: InputDecoration(
              hintText: '请输入邮箱',
              counterText: '',
              border: InputBorder.none,
            ),
            onSaved: (String value) => _email = value,
            validator: (String value) {
              if (value.isEmpty) showToast('请输入邮箱!');
            },
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.only(left: 5),
          leading: Text(
            '手机号码',
            style: TextStyle(fontSize: 18),
          ),
          title: TextFormField(
            maxLength: 11,
            controller: _mobileController,
            textAlign: TextAlign.right,
            keyboardType: TextInputType.phone,
            inputFormatters: [WhitelistingTextInputFormatter(RegExp('[0-9]'))],
            decoration: InputDecoration(
              hintText: '请输入手机号码',
              counterText: '',
              border: InputBorder.none,
            ),
            onSaved: (String value) => _mobile = value,
            validator: (String value) {
              if (value.isEmpty) showToast('请输入手机号码!');
            },
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.only(left: 5),
          leading: Text(
            '电话号码',
            style: TextStyle(fontSize: 18),
          ),
          title: TextFormField(
            maxLength: 13,
            controller: _phoneController,
            textAlign: TextAlign.right,
            keyboardType: TextInputType.phone,
            inputFormatters: [WhitelistingTextInputFormatter(RegExp('[0-9-]'))],
            decoration: InputDecoration(
              hintText: '请输入电话号码',
              counterText: '',
              border: InputBorder.none,
            ),
            onSaved: (String value) => _phone = value,
            validator: (String value) {
              if (value.isEmpty) showToast('请输入电话号码!');
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductInfo() {
    return Wrap(
      children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.only(left: 5),
          leading: Text(
            '产品',
            style: TextStyle(fontSize: 18),
          ),
          title: Wrap(
            alignment: WrapAlignment.end,
            children: <Widget>[
              Text(
                _productIndex == null
                    ? '点击选择产品'
                    : _productMap[_productTypeIndex][_productIndex].name,
                style: TextStyle(
                  color: _productIndex == null
                      ? Theme.of(context).hintColor
                      : Theme.of(context).textTheme.subtitle.color,
                ),
              ),
              Icon(Icons.navigate_next, color: Colors.grey),
            ],
          ),
          onTap: () {
            Picker(
              adapter: PickerDataAdapter(data: _getPickerData()),
              selecteds: _productTypeIndex == null
                  ? [0, 0]
                  : [_productTypeIndex, _productIndex],
              textAlign: TextAlign.center,
              columnFlex: [2, 3],
              hideHeader: true,
              changeToFirst: true,
              cancelText: '取消',
              confirmText: '确定',
              title: Text('选择产品'),
              textStyle: Theme.of(context).textTheme.title,
              backgroundColor: Theme.of(context).dialogBackgroundColor,
              onConfirm: (Picker picker, List value) {
                _productTypeIndex = value[0];
                setState(() => _productIndex = value[1]);
              },
            ).showDialog(context);
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.only(left: 5),
          leading: Text(
            '版本',
            style: TextStyle(fontSize: 18),
          ),
          title: TextFormField(
            maxLength: 8,
            textAlign: TextAlign.right,
            keyboardType: TextInputType.number,
            inputFormatters: [WhitelistingTextInputFormatter(RegExp('[0-9]'))],
            initialValue: DateUtil.getDateStrByDateTime(
              DateTime.now(),
              format: DateFormat.YEAR_MONTH_DAY,
            ).replaceAll('-', ''),
            decoration: InputDecoration(
              hintText: '请输入版本',
              counterText: '',
              border: InputBorder.none,
            ),
            onSaved: (String value) => _version = value,
            validator: (String value) {
              if (value.isEmpty) showToast('请输入版本!');
            },
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.only(left: 5),
          leading: Text(
            '加密狗号',
            style: TextStyle(fontSize: 18),
          ),
          title: TextFormField(
            maxLength: 8,
            textAlign: TextAlign.right,
            keyboardType: TextInputType.number,
            inputFormatters: [
              WhitelistingTextInputFormatter(RegExp('[0-9A-Z]'))
            ],
            decoration: InputDecoration(
              hintText: '请输入加密狗号',
              counterText: '',
              border: InputBorder.none,
            ),
            onSaved: (String value) => _serialNumber = value,
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.only(left: 5),
          leading: Text(
            '站点数',
            style: TextStyle(fontSize: 18),
          ),
          title: TextFormField(
            maxLength: 3,
            initialValue: '10',
            textAlign: TextAlign.right,
            keyboardType: TextInputType.number,
            inputFormatters: [WhitelistingTextInputFormatter(RegExp('[0-9]'))],
            decoration: InputDecoration(
              hintText: '请输入站点数',
              counterText: '',
              border: InputBorder.none,
            ),
            onSaved: (String value) => _siteNumber = value,
            validator: (String value) {
              if (value.isEmpty) showToast('请输入站点数!');
            },
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.only(left: 5),
          leading: Text(
            '门店数',
            style: TextStyle(fontSize: 17),
          ),
          title: TextFormField(
            maxLength: 3,
            initialValue: '10',
            textAlign: TextAlign.right,
            keyboardType: TextInputType.number,
            inputFormatters: [WhitelistingTextInputFormatter(RegExp('[0-9]'))],
            decoration: InputDecoration(
              hintText: '请输入门店数',
              counterText: '',
              border: InputBorder.none,
            ),
            onSaved: (String value) => _storeNumber = value,
            validator: (String value) {
              if (value.isEmpty) showToast('请输入门店数!');
            },
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.only(left: 5),
          title: Text('是否做过客户化'),
          trailing: Switch(
            value: _isCustomize,
            onChanged: (value) => setState(() => _isCustomize = value),
            activeColor: Theme.of(context).accentColor,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onTap: () {
            setState(() => _isCustomize = !_isCustomize);
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.only(left: 5),
          title: Text('是否是连锁店'),
          trailing: Switch(
            value: _isChain,
            onChanged: (value) => setState(() => _isChain = value),
            activeColor: Theme.of(context).accentColor,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onTap: () {
            setState(() => _isChain = !_isChain);
          },
        ),
      ],
    );
  }

  Widget _buildQuestionDescription() {
    return Wrap(
      children: <Widget>[
        TextField(
          maxLines: 10,
          decoration: InputDecoration(
            filled: true,
            border: InputBorder.none,
            hintText: '请输入问题描述',
            contentPadding: EdgeInsets.all(8),
          ),
          onChanged: (value) {
            _questionDescription = value;
          },
        ),
        Container(
          width: double.infinity,
          child: Text('上传图片'),
        ),
        ImageList((urlList) => _imageUrlList = urlList),
      ],
    );
  }

  List<PickerItem> _getPickerData() {
    const productIDMap = {
      0: ['1u', '1w', '18'], // 商超系列
      1: ['3u', '3z', '3j'], // 新零售系列
      2: ['3t', '3v', '3o', '3p', '3s', '3i', '2m', '2c'], // 专卖系列 //, '3q'
      3: ['2u', '2o', '2r', '2v', '1c', '2q', '2s', '2t'], // 餐饮系列
      4: ['69', '68', '65', '66', '67', '6a'], // eShop系列
      5: [
        '4a',
        '4b',
        '4c',
//        '4e',
        '4f',
        '4g',
        '4h',
        '4j',
        '4k',
        '4l',
        '4m',
        '4n',
        '4o',
        '4p',
        '4q',
        '4r',
        '4s',
        '4t',
      ], // 天店系列
      6: ['1P', '3n', '2l', '2w', '3w', '9j', '1v', '3x'], // O2O&其他
    };
    const productTypeMap = {
      0: '商超系列',
      1: '新零售系列',
      2: '专卖系列',
      3: '餐饮系列',
      4: 'eShop系列',
      5: '天店系列',
      6: 'O2O&其他',
    };
    var pickerItemList = <PickerItem>[];
    _productMap = <int, List<Product>>{};
    for (var i = 0; i < productIDMap.length; i++) {
      var products = <Product>[];
      var pickerItems = <PickerItem>[];
      for (var productID in productIDMap[i]) {
        var product = Const.productMap[productID];
        products.add(product);
        pickerItems.add(PickerItem(
          text: Center(child: AutoSizeText(product.name)),
          value: product.id,
        ));
      }
      _productMap.addAll({i: products});
      pickerItemList.add(PickerItem(
        text: Center(child: AutoSizeText(productTypeMap[i])),
        value: i,
        children: pickerItems,
      ));
    }
    return pickerItemList;
  }
}

class QuestionType {
  String id;
  String name;

  QuestionType(this.id, this.name);

  @override
  String toString() => name;
}
