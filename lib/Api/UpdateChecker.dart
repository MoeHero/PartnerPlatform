import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Api/Dio.dart';

class UpdateChecker {
  static check(context) async {
    final packageInfo = await PackageInfo.fromPlatform();

    var currentBuildNumber = int.parse(packageInfo.buildNumber);
    var newBuildNumber;
    var assetID;

    final Response<Map> response = await dio.get(
      'https://api.github.com/repos/MoeHero/PartnerPlatform/releases/latest',
      queryParameters: {
        'access_token': '21edbad558a768edb9186b828e1f5048eed55c39',
      },
    );

    for (var asset in response.data['assets']) {
      RegExp regExp = new RegExp(r'PartnerPlatform-.+?-(\d+?)\.apk');
      newBuildNumber = int.parse(regExp.firstMatch(asset['name']).group(1));
      assetID = asset['id'];
    }
    if (newBuildNumber <= currentBuildNumber) return;
    _showDialog(
      context,
      response.data['name'],
      response.data['body'],
      assetID,
    );
  }

  static void _showDialog(context, version, body, assetID) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('合作伙伴平台更新 ' + version),
          content: Text(body),
          actions: <Widget>[
            FlatButton(
              child: Text(
                '推迟',
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
              child: Text('立即更新'),
              onPressed: () => _update(context, version, assetID),
            )
          ],
        );
      },
    );
  }

  static void _update(context, version, assetID) async {
    if ((await PermissionHandler().requestPermissions(
            [PermissionGroup.storage]))[PermissionGroup.storage] !=
        PermissionStatus.granted) return;
    final taskID = await FlutterDownloader.enqueue(
      url:
          'https://api.github.com/repos/MoeHero/PartnerPlatform/releases/assets/$assetID?access_token=21edbad558a768edb9186b828e1f5048eed55c39',
      savedDir: (await getExternalStorageDirectory()).path,
      headers: {'Accept': 'application/octet-stream'},
      showNotification: false,
    );
    Navigator.of(context).pop();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('合作伙伴平台更新 ' + version),
          content: _Download(taskID),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                FlutterDownloader.cancel(taskId: taskID);
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}

class _Download extends StatefulWidget {
  var taskID;

  _Download(this.taskID);

  @override
  _DownloadState createState() => _DownloadState();
}

class _DownloadState extends State<_Download> {
  var downloadProgress = 0;

  @override
  void initState() {
    super.initState();
    FlutterDownloader.registerCallback((id, status, progress) {
      setState(() => downloadProgress = progress);
      if (widget.taskID == id && status == DownloadTaskStatus.complete) {
        FlutterDownloader.open(taskId: widget.taskID);
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        LinearProgressIndicator(value: downloadProgress / 100),
        Container(height: 10),
        Row(
          children: <Widget>[
            Expanded(child: Text('下载中, 请稍候...')),
            Text('$downloadProgress%'),
          ],
        ),
      ],
    );
  }
}
