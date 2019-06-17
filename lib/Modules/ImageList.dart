import 'dart:convert';
import 'dart:io';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import './GalleryPhotoViewWrapper.dart';
import './UploadImage.dart';

class ImageList extends StatefulWidget {
  final void Function(List<String> imageUrlList) _onImageListChange;

  ImageList(this._onImageListChange);

  @override
  State<StatefulWidget> createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  final _imageFileMap = Map<File, String>();
  final _galleryItems = Map<String, ImageProvider>();

  @override
  Widget build(BuildContext context) {
    final _imageList = <Widget>[];

    for (var imageFile in _imageFileMap.keys) {
      final tag = hex.encode(md5
          .convert(Utf8Encoder().convert(imageFile.hashCode.toString()))
          .bytes);
      _galleryItems.addAll({tag: FileImage(imageFile)});

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
                onTap: () => GalleryPhotoViewWrapper.show(
                      context,
                      _galleryItems.keys.toList().indexOf(tag),
                      _galleryItems,
                    ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: InkWell(
                  onTap: () {
                    _galleryItems.remove(tag);
                    setState(() => _imageFileMap.remove(imageFile));
                    if (widget._onImageListChange != null)
                      widget._onImageListChange(_imageFileMap.values.toList());
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
