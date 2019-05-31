import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_version/get_version.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Api/Dio.dart';

class UpdateChecker {
  static check(context) async {
    final Response<Map> response = await dio.get(
      'http://api.fir.im/apps/latest/5cebc3fcca87a8382db0a625',
      queryParameters: {
        'api_token': '468c0c5fd2fda856967d9a9916bd7885',
      },
    );

    if (int.parse(response.data['build']) <=
        int.parse(await GetVersion.projectCode)) return;
    _showDialog(
      context,
      response.data['install_url'],
      response.data['changelog'],
    );
  }

  static void _showDialog(context, installUrl, changelog) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('发现新版本'),
          content: Text(changelog),
          actions: <Widget>[
            FlatButton(
              child: Text(
                '暂不更新',
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
              child: Text('立即更新'),
              onPressed: () => _update(context, installUrl),
            )
          ],
        );
      },
    );
  }

  static void _update(context, installUrl) async {
    if ((await PermissionHandler().requestPermissions(
            [PermissionGroup.storage]))[PermissionGroup.storage] !=
        PermissionStatus.granted) return;
    final taskID = await FlutterDownloader.enqueue(
      url: installUrl,
      savedDir: (await getExternalStorageDirectory()).path,
      showNotification: false,
    );
    Navigator.of(context).pop();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('下载新版本'),
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
