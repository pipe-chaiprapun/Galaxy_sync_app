import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ViewPhotoPage extends StatelessWidget{
  final String path;
  final String imgName;
  ViewPhotoPage(this.path, this.imgName);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    File image = new File(this.path);
    print(this.path);
    _buildSaveImg(image, this.imgName);
    // i mage.copy('/data/user/0/com.example.de_mobile/app_flutter/plachado/'+this.imgName);
    return Scaffold(
      appBar: AppBar(title: Text('Take a picture')),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: Image.file(File(path))
      );
  }
  _buildSaveImg(File file, String name) async {
    final String newPath = (await getApplicationDocumentsDirectory()).path;
    final File newImage = await file.copy('$newPath/img1.png');
    print(newImage.path);
  }
}