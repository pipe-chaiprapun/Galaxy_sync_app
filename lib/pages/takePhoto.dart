import 'dart:async';
import 'dart:io';
import 'package:de_mobile/helper/Database.dart';
import 'package:de_mobile/models/placePhoto.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/services.dart';
// import 'package:location/location.dart';
import 'package:de_mobile/widgets/photoViewerPath.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as im;

enum PhotoTypes { place, home, recieve, trace }

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;
  final String name;
  final dynamic photoTag;
  final PhotoTypes type;
  final int photoNum;
  const TakePictureScreen(
      {Key key,
      @required this.camera,
      @required this.name,
      this.photoTag,
      this.type, this.photoNum})
      : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

enum saveImgActivity { ready, save }

class TakePictureScreenState extends State<TakePictureScreen> {
  // Add two variables to the state class to store the CameraController and
  // the Future.
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  // LocationData currentLocation;
  // Location location = new Location();
  double latitude = 0.0;
  double longtitude = 0.0;
  saveImgActivity action = saveImgActivity.ready;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
        // Get a specific camera from the list of available cameras.
        widget.camera,
        // Define the resolution to use.
        ResolutionPreset.high,
        enableAudio: false);

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
    // location.onLocationChanged().listen((LocationData currentLocation) {
    //   print(currentLocation.latitude);
    //   print(currentLocation.longitude);
    //   setState(() {
    //     latitude = currentLocation.latitude;
    //     longtitude = currentLocation.longitude;
    //   });
    // });
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // location.getLocation().then((LocationData location) {
    //   print(location.latitude);
    //   print(location.longitude);
    //   setState(() {
    //     latitude = currentLocation.latitude;
    //     longtitude = currentLocation.longitude;
    //   });
    // });
    // location.onLocationChanged().listen((LocationData currentLocation) {
    //   setState(() {
    //     latitude = currentLocation.latitude;
    //     longtitude = currentLocation.longitude;
    //   });
    // });

    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return Flex(children: <Widget>[
              Container(
                  child: CameraPreview(_controller),
                  height: MediaQuery.of(context).size.height * 0.90),
              SizedBox(
                height: 30,
              ),
              Padding(
                  child: Row(
                    children: <Widget>[
                      Text('Latitude: ${latitude.toString()}',
                          style: TextStyle(color: Colors.red, fontSize: 16)),
                      Text('Longtitude: ${longtitude.toString()}',
                          style: TextStyle(color: Colors.red, fontSize: 16))
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10))
            ], direction: Axis.vertical);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
          width: 100,
          height: 100,
          child: FloatingActionButton(
            child: RotationTransition(
                child: Icon(Icons.camera_alt, size: 48),
                turns: AlwaysStoppedAnimation(90 / 360)),
            onPressed: () {
              _onSaveButtonPress(context);
            },
          )),
    );
  }

  _onSaveButtonPress(BuildContext camContext) async {
    try {
      await _initializeControllerFuture;
      final String imgName = '${widget.name}.jpg';
      final path = join(
        (await getTemporaryDirectory()).path,
        imgName,
      );
      await _controller.takePicture(path);
      Navigator.push(camContext,
          MaterialPageRoute<bool>(builder: (BuildContext context) {
        return Scaffold(
            appBar: AppBar(
              title: Text(imgName),
              actions: <Widget>[
                RaisedButton(
                  child: Text('Save', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    setState(() {
                      action = saveImgActivity.save;
                    });
                    File rawImage = new File(path);
                    //////////// compress image //////////
                    im.Image image = im.decodeImage(rawImage.readAsBytesSync());
                    var resizeImg =
                        im.copyResize(image, width: 640, height: 480);
                    //////////////////////////////////////
                    _saveImg(rawImage, resizeImg, imgName);
                    setState(() {
                      action = saveImgActivity.ready;
                    });
                    Navigator.pop(context, true);
                  },
                ),
                FlatButton(
                  child: Text('Delete', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    File image = new File(path);
                    image.delete(recursive: false);
                    Navigator.pop(context, false);
                  },
                ),
              ],
            ),
            body: SizedBox.expand(
              child: Hero(
                tag: imgName,
                child: GridPhotoViewerPath(
                  path: path,
                ),
              ),
            ));
      })).then((bool onValue){
        print('after save/delete $onValue');
        Navigator.pop(camContext, onValue);
      });
    } catch (e) {
      print(e);
    }
  }

  _saveImg(File originImg, im.Image image, String name) {
    getExternalStorageDirectory().then((onValue) {
      final String storagePath = onValue.path;
      final photoPath = '$storagePath/DE';
      Directory(photoPath).exists().then((onValue) async {
        if (onValue) {
          File('$photoPath/$name')
            ..writeAsBytes(im.encodeJpg(image, quality: 80))
                .then((onValue) async {
              switch (widget.type) {
                case PhotoTypes.place:
                  {
                    PlacePhoto place = widget.photoTag;
                    place.file_name = name;
                    place.path = '$photoPath/$name';
                    DBProvider.db.addPlacePhoto(place).then((onValue) async {
                      await DBProvider.db.updatePlacePhoto(place.lnc_no, widget.photoNum);
                    });
                  }
                  break;
                case PhotoTypes.home:
                  break;
                case PhotoTypes.recieve:
                  break;
                case PhotoTypes.trace:
                  break;
              }
              await originImg.delete(recursive: false);
            });
        } else {
          Directory(photoPath).create().then((onValue) {
            print('created directory');
            print(onValue.path);
            File('$photoPath/$name')
              ..writeAsBytes(im.encodeJpg(image, quality: 80)).then(
                  (onValue) async => await originImg.delete(recursive: false));
          });
        }
      });
    });
  }

  _buildSavingUI() {
    return Column(
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(
            height: 10,
          ),
          Text(
            'กำลังประมวลผลภาพ',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center);
  }
  // _saveImg2(File file, String name) async {
  //   getExternalStorageDirectory().then((onValue) {
  //     final String storagePath = onValue.path;
  //     final photoPath = '$storagePath/DE';
  //     Directory(photoPath).exists().then((onValue) async {
  //       if (onValue) {
  //         file.copy('$photoPath/$name');
  //         await file.delete(recursive: false);
  //       } else {
  //         Directory(photoPath).create().then((onValue) async {
  //           print('created directory');
  //           print(onValue.path);
  //           file.copy('$photoPath/$name');
  //           await file.delete(recursive: false);
  //         });
  //       }
  //     });
  //   });
  // }
}
