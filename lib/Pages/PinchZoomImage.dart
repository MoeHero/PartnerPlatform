import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class PinchZoomImagePage extends StatelessWidget {
  final ImageProvider _imageProvider;

  PinchZoomImagePage(this._imageProvider);

  static show(BuildContext context, ImageProvider image) {
    showDialog(context: context, builder: (_) => PinchZoomImagePage(image));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => Navigator.pop(context),
        child: ExtendedImage(
          enableLoadState: true,
          loadStateChanged: (ExtendedImageState state) {
            switch (state.extendedImageLoadState) {
              case LoadState.completed:
                return null;
              case LoadState.loading:
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Container(height: 10),
                    Text('图片加载中...'),
                  ],
                );
              case LoadState.failed:
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.broken_image,
                      size: 70,
                      color: Colors.grey,
                    ),
                    Text('加载失败'),
                  ],
                );
            }
          },
          height: double.infinity,
          width: double.infinity,
          image: _imageProvider,
          mode: ExtendedImageMode.Gesture,
          onDoubleTap: (ExtendedImageGestureState state) {
            state.gestureDetails = GestureDetails(
              totalScale: state.gestureDetails.totalScale == 1 ? 2 : 1,
              userOffset: false,
            );
          },
        ),
      ),
    );

//    return Scaffold(
//      appBar: AppBar(
//        title: Text('图片详情'),
//      ),
//      body: InkWell(
//        splashColor: Colors.transparent,
//        highlightColor: Colors.transparent,
//        onTap: () => Navigator.pop(context),
//        child: ExtendedImage(
//          height: double.infinity,
//          width: double.infinity,
//          image: _imageProvider,
//          mode: ExtendedImageMode.Gesture,
//          onDoubleTap: (ExtendedImageGestureState state) {
//            state.gestureDetails = GestureDetails(
//              totalScale: state.gestureDetails.totalScale == 1 ? 2 : 1,
//              userOffset: false,
//            );
//          },
//        ),
//      ),
//    );
  }
}
