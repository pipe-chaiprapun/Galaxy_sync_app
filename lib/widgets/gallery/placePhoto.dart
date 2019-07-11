import 'dart:async';
import 'package:camera/camera.dart';
import 'package:de_mobile/helper/Database.dart';
import 'package:de_mobile/models/payment2.dart';
import 'package:de_mobile/models/placePhoto.dart';
import 'package:de_mobile/pages/takePhoto.dart';
import 'package:de_mobile/widgets/dialog/alert.dart';
import 'package:de_mobile/widgets/gallery/viewGallery.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';

class PlacePhotoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _placePhoto();
}

class _placePhoto extends State<PlacePhotoPage> {
  Future<List<Payment2>> _payments;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _payments = DBProvider.db.getPaymentsWithPlacePhoto();
  }

  @override
  Widget build(BuildContext context) {
    return _buildListPhoto() == null
        ? Center(child: CircularProgressIndicator())
        : _buildListPhoto();
  }

  Widget _buildListPhoto() {
    print('on build');
    return FutureBuilder(
        future: _payments,
        builder:
            (BuildContext context, AsyncSnapshot<List<Payment2>> snapshot) {
          if (snapshot.hasData) {
            var placePhotos = ListView.builder(
              padding: EdgeInsets.all(15),
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  margin: EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    onTap: () {
                      print('on press photo');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewGallery(
                                  first_name: snapshot.data[index].first_name,
                                  last_name: snapshot.data[index].last_name,
                                  lnc_no: snapshot.data[index].lnc_no)));
                    },
                    enabled: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    leading: _buildPhotoButton(
                        context: context,
                        count: snapshot.data[index].placeImage,
                        payment: snapshot.data[index]),
                    title: Container(
                        margin: EdgeInsets.only(left: 30),
                        child: Text(
                            '${snapshot.data[index].first_name} ${snapshot.data[index].last_name}',
                            style: TextStyle(fontSize: 28))),
                    subtitle: Container(
                        margin: EdgeInsets.only(left: 30),
                        child: snapshot.data[index].cust_no != null
                            ? Text('${snapshot.data[index].lnc_no}',
                                style: TextStyle(fontSize: 18))
                            : Text(
                                'ลูกค้าใหม่',
                                style: TextStyle(fontSize: 18),
                              )),
                    trailing: _buildDeleteButton('${snapshot.data[index].first_name} ${snapshot.data[index].last_name}'),
                  ),
                );
              },
              itemCount: snapshot.data.length,
            );
            return placePhotos;
          } else if (snapshot.hasError) {
            print(snapshot.hasError);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _buildDeleteButton(String name){
    Alert alert = new Alert();
    alert.message = 'คุณต้องการลบรูปของคุณ [$name] ใช่หรือไม่?';
    return IconButton(
                      icon: Icon(Icons.delete),
                      iconSize: 36,
                      color: Colors.red[300],
                      onPressed: () {
                        alert.confirmDialog(context).then((onValue){
                          if(onValue){
                            alert.message = 'รูปของคุณ $name ถูกลบออกจากเครื่องแล้ว!';
                            alert.snackBarByContext(context);
                          }
                        });
                      },
                    );
  }

  Future<int> _deleteImage(){

  }

  Widget _buildPhotoButton(
      {BuildContext context, int count, Payment2 payment}) {
    return count < 3
        ? Badge(
            badgeContent: Text(
              count.toString(),
              style: TextStyle(color: Colors.white),
            ),
            child: IconButton(
                icon: Icon(
                  Icons.camera_alt,
                  color: Colors.green,
                ),
                iconSize: 36,
                onPressed: () {
                  print('on camera press');
                  var filename = '${payment.lnc_no}-${payment.placeImage + 1}';
                  PlacePhoto tag = new PlacePhoto(
                      lnc_no: payment.lnc_no,
                      cust_no: payment.cust_no,
                      first_name: payment.first_name,
                      last_name: payment.last_name,
                      file_name: filename,
                      photo_date: DateTime.now());
                  _takePhoto(
                      context: context,
                      name: filename,
                      photoTag: tag,
                      photoNumb: payment.placeImage + 1);
                }))
        : Badge(
            badgeContent: Text(
              count.toString(),
              style: TextStyle(color: Colors.white),
            ),
            child: IconButton(
              icon: Icon(Icons.camera_alt),
              iconSize: 36,
              onPressed: () {},
            ));
  }

  Future _takePhoto(
      {BuildContext context,
      String name,
      PlacePhoto photoTag,
      int photoNumb}) async {
    final cameras = await availableCameras();
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => TakePictureScreen(
                camera: cameras.first,
                name: name,
                photoTag: photoTag,
                type: PhotoTypes.place,
                photoNum: photoNumb,
              ),
        )).then((onValue) {
      print('after camera page $onValue');
      if (onValue) {
        print('refresh');
        Timer(const Duration(seconds: 3), () {
          setState(() {
            _payments = DBProvider.db.getPaymentsWithPlacePhoto();
          });
        });
      }
    });
  }
}
