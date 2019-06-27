import 'dart:io';

import 'package:de_mobile/pages/viewPhoto.dart';
import 'package:de_mobile/widgets/photoViewerPath.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;
  final String name;

  const TakePictureScreen({
    Key key,
    @required this.camera,
    @required this.name
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  // Add two variables to the state class to store the CameraController and
  // the Future.
  CameraController _controller;
  Future<void> _initializeControllerFuture;

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
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
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

        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Construct the path where the image should be saved using the path
            // package.
            final String imgName = '${widget.name}.png';
            final path = join(
              (await getTemporaryDirectory()).path,
              imgName,
            );
            // Attempt to take a picture and log where it's been saved.
            await _controller.takePicture(path);
            Navigator.push(context,
                MaterialPageRoute<void>(builder: (BuildContext context) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(imgName),
                  actions: <Widget>[
                    FlatButton(
                      child:
                          Text('Save', style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        File image = new File(path);
                        _buildSaveImg(image, imgName);
                        Navigator.pop(context, (bool res){
                          print(res);
                        });
                      },
                    ),
                    FlatButton(
                      child:
                          Text('Delete', style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        File image = new File(path);
                        image.delete(recursive: false);
                        Navigator.pop(context, (bool res){
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
                ),
                // floatingActionButton: FloatingActionButton(
                //   child: Icon(Icons.settings),
                // ),
              );
            }));
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      )),
    );
  }
  _buildSaveImg(File file, String name) async {
    final String newPath = (await getApplicationDocumentsDirectory()).path;
    final File newImage = await file.copy('$newPath/$name');
    print(newImage.path);
    file.delete(recursive: false);
  }
}
