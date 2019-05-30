import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import './TSP.dart';
import '../Const.dart';

final dio = Dio();

Future<void> initDio() async {
  dio.options.contentType =
      ContentType.parse('application/x-www-form-urlencoded');
  dio.interceptors.add(InterceptorsWrapper(
    onResponse: (Response response) async {
      if (response.data.toString().contains('本登录窗口已关闭') &&
          !response.request.path.endsWith('/GenPwd.aspx')) {
        var _isLogin = await isLogin();
        if (!_isLogin && Const.password.isNotEmpty) {
          _isLogin =
              await login(Const.agentID, Const.userID, Const.password) == true;
        }
        if (!_isLogin) return DioError(message: '需要重新登录');
        return await dio.request(
          response.request.path,
          data: response.request.data,
          queryParameters: response.request.queryParameters,
        );
        //TODO 完善未登录逻辑
        //TODO 修复刷新两次才可以
//        Navigator.pushNamed(context, routeName)
//        return DioError(message: '需要重新登录');
      }
      return response;
    },
    onError: (DioError err) {
      // 修复冒号报错问题 过滤Cookie
      if (err.response == null || err.response.headers['set-cookie'] == null)
        return err;
      DioHttpHeaders headers =
          DioHttpHeaders(initialHeaders: err.response.headers);
      headers.removeAll('set-cookie');
      for (var cookie in err.response.headers['set-cookie']) {
        if (!cookie.substring(0, cookie.indexOf('=')).contains(':'))
          headers.add('set-cookie', cookie);
      }
      err.response.headers = headers;
      return err;
    },
  ));
  dio.interceptors.add(
    CookieManager(
      PersistCookieJar(
        dir: (await getApplicationDocumentsDirectory()).path + '/cookies/',
      ),
    ),
  );
}
