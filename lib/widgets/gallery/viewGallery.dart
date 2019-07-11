import 'dart:io';

import 'package:de_mobile/constants/catalog.dart';
import 'package:de_mobile/helper/Database.dart';
import 'package:de_mobile/models/photo.dart';
import 'package:de_mobile/models/placePhoto.dart';
import 'package:de_mobile/widgets/dialog/alert.dart';
import 'package:flutter/material.dart';

typedef BannerTapCallback = void Function(Photo photo);
enum GridDemoTileStyle { imageOnly, oneLine, twoLine }

const double _kMinFlingVelocity = 800.0;
// const String _kGalleryAssetsPackage = 'flutter_gallery_assets';

class GridPhotoViewer extends StatefulWidget {
  const GridPhotoViewer({Key key, this.photo}) : super(key: key);

  final Photo photo;

  @override
  _GridPhotoViewerState createState() => _GridPhotoViewerState();
}

class _GridTitleText extends StatelessWidget {
  const _GridTitleText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Text(text,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
    );
  }
}

class _GridPhotoViewerState extends State<GridPhotoViewer>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _flingAnimation;
  Offset _offset = Offset.zero;
  double _scale = 1.0;
  Offset _normalizedOffset;
  double _previousScale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this)
      ..addListener(_handleFlingAnimation);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // The maximum offset value is 0,0. If the size of this renderer's box is w,h
  // then the minimum offset value is w - _scale * w, h - _scale * h.
  Offset _clampOffset(Offset offset) {
    final Size size = context.size;
    final Offset minOffset = Offset(size.width, size.height) * (1.0 - _scale);
    return Offset(
        offset.dx.clamp(minOffset.dx, 0.0), offset.dy.clamp(minOffset.dy, 0.0));
  }

  void _handleFlingAnimation() {
    setState(() {
      _offset = _flingAnimation.value;
    });
  }

  void _handleOnScaleStart(ScaleStartDetails details) {
    setState(() {
      _previousScale = _scale;
      _normalizedOffset = (details.focalPoint - _offset) / _scale;
      // The fling animation stops if an input gesture starts.
      _controller.stop();
    });
  }

  void _handleOnScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _scale = (_previousScale * details.scale).clamp(1.0, 4.0);
      // Ensure that image location under the focal point stays in the same place despite scaling.
      _offset = _clampOffset(details.focalPoint - _normalizedOffset * _scale);
    });
  }

  void _handleOnScaleEnd(ScaleEndDetails details) {
    final double magnitude = details.velocity.pixelsPerSecond.distance;
    if (magnitude < _kMinFlingVelocity) return;
    final Offset direction = details.velocity.pixelsPerSecond / magnitude;
    final double distance = (Offset.zero & context.size).shortestSide;
    _flingAnimation = _controller.drive(Tween<Offset>(
      begin: _offset,
      end: _clampOffset(_offset + direction * distance),
    ));
    _controller
      ..value = 0.0
      ..fling(velocity: magnitude / 1000.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: _handleOnScaleStart,
      onScaleUpdate: _handleOnScaleUpdate,
      onScaleEnd: _handleOnScaleEnd,
      child: Container(
        child: ClipRect(
          child: Transform(
            transform: Matrix4.identity()
              ..translate(_offset.dx, _offset.dy)
              ..scale(_scale),
            child: Image.file(new File(widget.photo.assetName),
                // package: widget.photo.assetPackage,
                fit: BoxFit.scaleDown
                //fit: BoxFit.cover,
                ),
          ),
        ),
        color: Colors.black,
      ),
    );
  }
}

class GridDemoPhotoItem extends StatelessWidget {
  GridDemoPhotoItem({
    Key key,
    @required this.photo,
    @required this.tileStyle,
    @required this.onBannerTap,
  })  : assert(photo != null), // assert(photo != null && photo.isValid),
        assert(tileStyle != null),
        assert(onBannerTap != null),
        super(key: key);

  final Photo photo;
  final GridDemoTileStyle tileStyle;
  final BannerTapCallback
      onBannerTap; // User taps on the photo's header or footer.

  void showPhoto(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute<void>(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(photo.title),
        ),
        body: SizedBox.expand(
          child: Hero(
            tag: photo.tag,
            child: GridPhotoViewer(photo: photo),
          ),
        ),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    final Widget image = GestureDetector(
      onTap: () {
        showPhoto(context);
      },
      child: Hero(
        key: Key(photo.assetName),
        tag: photo.tag,
        child: Image.file(
          File(photo.assetName),
          // package: photo.assetPackage,
          fit: BoxFit.cover,
        ),
      ),
    );

    IconData icon = photo.isFavorite ? Icons.bookmark : Icons.bookmark_border;
    switch (tileStyle) {
      case GridDemoTileStyle.imageOnly:
        return image;

      case GridDemoTileStyle.oneLine:
        return GridTile(
          header: GestureDetector(
            onTap: () {
              onBannerTap(photo);
            },
            child: GridTileBar(
              title: _GridTitleText(photo.title),
              backgroundColor: Colors.black38,
              leading: Icon(
                icon,
                color: Colors.white,
                size: 36,
              ),
            ),
          ),
          child: image,
        );

      case GridDemoTileStyle.twoLine:
        return GridTile(
          footer: GestureDetector(
            onTap: () {
              onBannerTap(photo);
            },
            child: GridTileBar(
              backgroundColor: Colors.black45,
              title: _GridTitleText(photo.title),
              subtitle: _GridTitleText(photo.caption),
              trailing: Icon(
                icon,
                color: Colors.white,
                size: 36,
              ),
            ),
          ),
          child: image,
        );
    }
    assert(tileStyle != null);
    return null;
  }
}

class ViewGallery extends StatefulWidget {
  const ViewGallery({Key key, this.first_name, this.last_name, this.lnc_no})
      : super(key: key);

  final String first_name;
  final String last_name;
  final String lnc_no;

  @override
  State<StatefulWidget> createState() {
    return _viewGalleryState();
  }
}

class _viewGalleryState extends State<ViewGallery> {
  GridDemoTileStyle _tileStyle = GridDemoTileStyle.oneLine;
  String _title;
  List<Photo> _photos;
  Alert _alert = new Alert();
  List<Photo> _selectedPhotos;


  @override
  void initState() {
    super.initState();
    DBProvider.db
        .getAllPlacePhoto(
            first_name: widget.first_name,
            last_name: widget.last_name,
            lnc_no: widget.lnc_no)
        .then((onValue) {
      _photos = new List<Photo>();
      setState(() {
        onValue.forEach((p) {
          _photos.add(new Photo(
              assetName: p.path,
              title: p.file_name,
              assetPackage: p.path,
              caption: '${p.first_name} ${p.last_name}'));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    _title = '${widget.first_name} ${widget.last_name}';
    return Scaffold(
        appBar: AppBar(
            title: Text(_title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24))),
        backgroundColor: Colors.white,
        body: Builder(
            builder: (context) => Column(
                  children: <Widget>[
                    Expanded(
                      child: SafeArea(
                        top: false,
                        bottom: false,
                        child: GridView.count(
                          crossAxisCount:
                              (orientation == Orientation.portrait) ? 2 : 3,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4.0,
                          padding: const EdgeInsets.all(5.0),
                          childAspectRatio:
                              (orientation == Orientation.portrait) ? 1 : 1,
                          children: _photos?.map<Widget>((Photo photo) {
                                return GridDemoPhotoItem(
                                  photo: photo,
                                  tileStyle: _tileStyle,
                                  onBannerTap: (Photo photo) {
                                    _selectedPhotos = new List<Photo>();
                                    setState(() {
                                      photo.isFavorite = !photo.isFavorite;
                                      print('${photo.title} was selected');
                                      _selectedPhotos = _photos
                                          .where((p) => p.isFavorite == true).toList();
                                      if (_selectedPhotos.length > 0) {
                                        _alert.message =
                                            'คุณต้องการลบ ${_selectedPhotos.length} รูปที่เลือกไว้ใช่หรือไม่?';
                                        Scaffold.of(context)
                                            .hideCurrentSnackBar();
                                        Scaffold.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                  '${_selectedPhotos.length} รูปถูกเลือก',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                duration: Duration(seconds: 60),
                                                action: SnackBarAction(
                                                    textColor: Colors.white,
                                                    label: 'ลบ',
                                                    onPressed: () {
                                                      _alert.confirmDialog(
                                                          context).then((onValue) => _deletePhotos(context));
                                                    })));
                                      }
                                    });
                                  },
                                );
                              })?.toList() ??
                              [],
                        ),
                      ),
                    ),
                  ],
                )));
  } 
  _deletePhotos(BuildContext context){
    _alert.message = '${_selectedPhotos.length} รูปถูกลบแล้ว';
    setState(() {
      _selectedPhotos.forEach((p){
        _photos.removeWhere((r) => r.assetName == p.assetName);
      });
    });
    _alert.snackBarByContext(context);
  }
}
