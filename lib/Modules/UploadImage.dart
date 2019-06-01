import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../Api/Dio.dart';

class UploadImage extends StatefulWidget {
  final File _imageFile;
  final void Function(String imageUrl) _onUploadFinished;

  UploadImage(this._imageFile, this._onUploadFinished);

  @override
  State<StatefulWidget> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  bool _uploadFinished = false;
  bool _isError = false;
  double _uploadingProgress = 0;

  @override
  void initState() {
    super.initState();
    _uploadImage();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        FractionallySizedBox(
          widthFactor: 1,
          heightFactor: 1,
          child: Image.file(widget._imageFile, fit: BoxFit.cover),
        ),
        _uploadFinished
            ? Container()
            : FractionallySizedBox(
                heightFactor: _uploadingProgress,
                child: Opacity(
                  opacity: .6,
                  child: Container(color: Colors.grey),
                ),
              ),
        _uploadFinished
            ? Container()
            : Opacity(opacity: .4, child: Container(color: Colors.grey)),
        _uploadFinished
            ? Container()
            : Center(
                child: Container(
                  child: Icon(Icons.file_upload, size: 50),
                ),
              ),
        _isError
            ? Container()
            : Center(
                child: Container(
                  child: Icon(Icons.error_outline, size: 50),
                ),
              ),
      ],
    );
  }

  void _uploadImage() async {
    Response<Map> response;
    try {
      response = await dio.post(
        'https://www.superbed.cn/upload',
        data: FormData.from({
          'token': 'd704d0b5c96042aa943ac223fd79908d',
          'categories': 'SixunAPP',
          'file': UploadFileInfo(
            widget._imageFile,
            _getFileName(widget._imageFile.path),
          ),
          'v': '2',
        }),
        onSendProgress: (int count, int total) {
          setState(() => _uploadingProgress = count / total);
        },
      );
    } catch (e) {
      if (mounted) setState(() => _isError = true);
    }
    if (widget._onUploadFinished != null)
      widget._onUploadFinished(response.data['url']);
    if (mounted) setState(() => _uploadFinished = true);
  }

  String _getFileName(String path) {
    return path.substring(path.lastIndexOf('/') + 1);
  }
}
