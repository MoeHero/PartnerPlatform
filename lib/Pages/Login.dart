import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:oktoast/oktoast.dart';

import '../Api/TSP.dart';
import '../Const.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  int _lastClickTime = 0;
  String _agentID, _userID, _password;
  var _agentIDController = TextEditingController(),
      _userIDController = TextEditingController(),
      _passwordController = TextEditingController();
  var _userIDFocusNode = FocusNode(), _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _agentIDController.value = TextEditingValue(text: Const.agentID);
    _userIDController.value = TextEditingValue(text: Const.userID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            children: <Widget>[
              SizedBox(height: kToolbarHeight),
              _buildTitle1(),
              _buildTitle2(),
              SizedBox(height: 30),
              _buildAgentID(),
              _buildUserID(),
              _buildPassword(context),
              SizedBox(height: 40),
              _buildLoginButton(context),
              SizedBox(height: 30),
            ],
          ),
          onWillPop: () {
            int nowTime = DateTime.now().microsecondsSinceEpoch;
            if (_lastClickTime != 0 && nowTime - _lastClickTime > 2300) {
              SystemNavigator.pop();
            } else {
              _lastClickTime = nowTime;
              Future.delayed(Duration(milliseconds: 2300), () {
                _lastClickTime = 0;
              });
              showToast('再按一次退出');
              return Future.value(false);
            }
          },
        ),
        inAsyncCall: _isLoading,
      ),
    );
  }

  Widget _buildTitle1() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Text('思迅技术支持平台', style: TextStyle(fontSize: 30)),
    );
  }

  Widget _buildTitle2() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Text('合作伙伴登录', style: TextStyle(fontSize: 20)),
    );
  }

  Widget _buildAgentID() {
    return TextFormField(
      maxLength: 6,
      autofocus: true,
      controller: _agentIDController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      inputFormatters: [WhitelistingTextInputFormatter(RegExp('[0-9]'))],
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.group),
        labelText: '合作伙伴编号',
        contentPadding: EdgeInsets.only(top: 6),
      ),
      onSaved: (String value) => _agentID = value,
      onFieldSubmitted: (value) =>
          FocusScope.of(context).requestFocus(_userIDFocusNode),
      validator: (String value) =>
          (value.isEmpty || value.length != 6) ? '请输入6位合作伙伴编号' : null,
    );
  }

  Widget _buildUserID() {
    return TextFormField(
      maxLength: 6,
      focusNode: _userIDFocusNode,
      controller: _userIDController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      inputFormatters: [WhitelistingTextInputFormatter(RegExp('[0-9]'))],
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person),
        labelText: '用户编号',
        contentPadding: EdgeInsets.only(top: 6),
      ),
      onSaved: (String value) => _userID = value,
      onFieldSubmitted: (value) =>
          FocusScope.of(context).requestFocus(_passwordFocusNode),
      validator: (String value) =>
          (value.isEmpty || value.length != 6) ? '请输入6位用户编号' : null,
    );
  }

  Widget _buildPassword(BuildContext context) {
    return TextFormField(
      obscureText: true,
      focusNode: _passwordFocusNode,
      controller: _passwordController,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock),
        labelText: '密码',
        contentPadding: EdgeInsets.only(top: 6),
      ),
      onSaved: (String value) => _password = value,
      validator: (String value) => value.isEmpty ? '请输入密码' : null,
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45,
        width: 270,
        child: RaisedButton(
          child: Text('登 录', style: Theme.of(context).primaryTextTheme.subhead),
          shape: StadiumBorder(),
          color: Theme.of(context).primaryColor,
          onPressed: _login,
        ),
      ),
    );
  }

  void _login() async {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();

    setState(() => _isLoading = true);
    Const.agentID = _agentID;
    Const.userID = _userID;
    var result = await login(_agentID, _userID, _password);
    Const.password = _password;
    setState(() => _isLoading = false);
    if (result == true) {
      if (!Const.isConstInit) await Const.initConst();
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      showToast(result);
    }
  }
}
