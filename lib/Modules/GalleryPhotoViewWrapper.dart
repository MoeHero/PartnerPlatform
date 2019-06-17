import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper(
      {this.loadingChild,
      this.backgroundDecoration,
      this.minScale,
      this.maxScale,
      this.initialIndex,
      @required this.galleryItems})
      : pageController = PageController(initialPage: initialIndex);

  final Widget loadingChild;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final Map<String, ImageProvider> galleryItems;

  @override
  State<StatefulWidget> createState() => _GalleryPhotoViewWrapperState();

  static void show(
    BuildContext context,
    final int index,
    final Map<String, ImageProvider> galleryItems,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GalleryPhotoViewWrapper(
              initialIndex: index,
              galleryItems: galleryItems,
            ),
      ),
    );
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => Navigator.pop(context),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            PhotoViewGallery.builder(
              builder: _buildItem,
              itemCount: widget.galleryItems.length,
              scrollPhysics: BouncingScrollPhysics(),
              pageController: widget.pageController,
              backgroundDecoration: widget.backgroundDecoration,
              onPageChanged: (i) => setState(() => currentIndex = i),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                '${currentIndex + 1} / ${widget.galleryItems.length}',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final tag = widget.galleryItems.keys.toList()[index];
    final imageProvider = widget.galleryItems[tag];
    return PhotoViewGalleryPageOptions(
      imageProvider: imageProvider,
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 1.1,
      heroTag: tag,
    );
  }
}
