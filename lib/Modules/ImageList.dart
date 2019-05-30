import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import './UploadImage.dart';
import '../Pages/PinchZoomImage.dart';

class ImageList extends StatefulWidget {
  final void Function(List<String> imageUrlList) _onImageListChange;

  ImageList(this._onImageListChange);

  @override
  State<StatefulWidget> createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  var _imageFileMap = Map<File, String>();

  @override
  Widget build(BuildContext context) {
    final _imageList = <Widget>[];

    for (var imageFile in _imageFileMap.keys) {
      _imageList.add(FractionallySizedBox(
        widthFactor: 0.33,
        child: AspectRatio(
          aspectRatio: 1,
          child: Stack(
            children: <Widget>[
              InkWell(
                child: UploadImage(
                  imageFile,
                  (String url) {
                    _imageFileMap[imageFile] = url;
                    if (widget._onImageListChange == null) return;
                    widget._onImageListChange(_imageFileMap.values.toList());
                  },
                ),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () =>
                    PinchZoomImagePage.show(context, FileImage(imageFile)),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: InkWell(
                  onTap: () {
                    setState(() => _imageFileMap.remove(imageFile));
                    if (widget._onImageListChange != null) {
                      widget._onImageListChange(_imageFileMap.values.toList());
                    }
                  },
                  child: Opacity(
                    opacity: .7,
                    child: Container(
                      color: Colors.grey,
                      child: Icon(Icons.close),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
    }

    _imageList.add(FractionallySizedBox(
      widthFactor: 0.33,
      child: AspectRatio(
        aspectRatio: 1,
        child: FlatButton(
          color: Theme.of(context).highlightColor,
          child: Icon(Icons.add),
          onPressed: () async {
            final imageFile = await showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.photo_camera),
                      title: Text('相机'),
                      onTap: () async {
                        Navigator.pop(
                          context,
                          await ImagePicker.pickImage(
                            source: ImageSource.camera,
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('图库'),
                      onTap: () async {
                        Navigator.pop(
                          context,
                          await ImagePicker.pickImage(
                            source: ImageSource.gallery,
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
            if (imageFile == null) return;
            setState(() => _imageFileMap.addAll({imageFile: ''}));
          },
        ),
      ),
    ));
    return Container(
      width: double.infinity,
      child: Wrap(children: _imageList),
    );
  }
}
