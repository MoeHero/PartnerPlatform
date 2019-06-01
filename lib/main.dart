import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';

import './Pages/CreateQuestion.dart';
import './Pages/Login.dart';
import './Pages/Main.dart';
import './Pages/Question.dart';
import './Pages/Setting.dart';
import './Pages/SoftwareHide.dart';
import './Pages/Splash.dart';
import './Pages/Theme.dart';
import './Pages/UniversalPassword.dart';

void main() {
  runApp(OKToast(
    backgroundColor: Colors.grey[600],
    position: ToastPosition.bottom,
    child: DynamicTheme(
      data: (brightness) => ThemeData(brightness: brightness),
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          title: '合作伙伴平台',
          theme: theme,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [Locale('zh', 'CN')],
          routes: {
            '/': (_) => SplashPage(),
            '/main': (_) => MainPage(),
            '/login': (_) => LoginPage(),
            '/question': (_) => QuestionPage(),
            '/create_question': (_) => CreateQuestionPage(),
            '/password': (_) => UniversalPasswordPage(),
            '/setting': (_) => SettingPage(),
            '/software_hide': (_) => SoftwareHidePage(),
            '/theme': (_) => ThemePage(),
          },
        );
      },
    ),
  ));

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
}
