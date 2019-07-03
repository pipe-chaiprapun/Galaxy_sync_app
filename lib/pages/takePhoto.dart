import 'dart:async';
import 'dart:io';
import 'package:location/location.dart';
import 'package:de_mobile/pages/viewPhoto.dart';
import 'package:de_mobile/widgets/photoViewerPath.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;
  final String name;

  const TakePictureScreen({Key key, @required this.camera, @required this.name})
      : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  // Add two variables to the state class to store the CameraController and
  // the Future.
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  LocationData currentLocation;
  Location location = new Location();
  double latitude = 0.0;
  double longtitude = 0.0;

  @override
  void initState() {
    super.initState();
    // To display the current output from the camera,
    // create a CameraController.
    _controller = CameraController(
        // Get a specific camera from the list of available cameras.
        widget.camera,
        // Define the resolution to use.
        ResolutionPreset.medium,
        enableAudio: false);

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    location.hasPermission().then((onValue) {
      print(onValue);
    });
    location.getLocation().then((LocationData location) {
      print(location.latitude);
      print(location.longitude);
      setState(() {
        latitude = currentLocation.latitude;
        longtitude = currentLocation.longitude;
      });
    });
    location.onLocationChanged().listen((LocationData currentLocation) {
      setState(() {
        latitude = currentLocation.latitude;
        longtitude = currentLocation.longitude;
      });
    });

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
            child: Icon(Icons.camera_alt, size: 48),
            onPressed: () async {
              try {
                await _initializeControllerFuture;
                final String imgName = '${widget.name}.png';
                final path = join(
                  (await getTemporaryDirectory()).path,
                  imgName,
                );
                await _controller.takePicture(path);
                Navigator.push(context,
                    MaterialPageRoute<void>(builder: (BuildContext context) {
                  return Scaffold(
                      appBar: AppBar(
                        title: Text(imgName),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Save',
                                style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              File image = new File(path);
                              _buildSaveImg(image, imgName);
                              Navigator.pop(context, (bool res) {
                                print(res);
                              });
                            },
                          ),
                          FlatButton(
                            child: Text('Delete',
                                style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              File image = new File(path);
                              image.delete(recursive: false);
                              Navigator.pop(context, (bool res) {
                                print(res);
                              });
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
                }));
              } catch (e) {
                print(e);
              }
            },
          )),
    );
  }

  _buildSaveImg(File file, String name) async {
    getExternalStorageDirectory().then((onValue) {
      final String storagePath = onValue.path;
      final photoPath = '$storagePath/DE';
      Directory(photoPath).exists().then((onValue) async {
        if (onValue) {
          file.copy('$photoPath/$name');
          await file.delete(recursive: false);
        } else {
          Directory(photoPath).create().then((onValue) async {
            print('created directory');
            print(onValue.path);
            file.copy('$photoPath/$name');
            await file.delete(recursive: false);
          });
        }
      });
    });
  }
}
