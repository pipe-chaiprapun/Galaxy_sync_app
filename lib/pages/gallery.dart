import 'package:de_mobile/widgets/gallery/placePhoto.dart';
import 'package:flutter/material.dart';

class GalleryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                unselectedLabelColor: Colors.white54,
                tabs: [
                  Tab(icon: Icon(Icons.location_city, size: 32), child: Text('รูปสถานที่')),
                  Tab(icon: Icon(Icons.home, size: 32), text: 'รูปที่อยู่ปัจจุบัน'),
                  Tab(icon: Icon(Icons.supervised_user_circle, size: 32,), text: 'รูปรับทอง'),
                  Tab(icon: Icon(Icons.directions_car, size: 32,), text: 'รูปติดตาม')
                ],
              ),
              title: Text('ถ่ายรูปเพิ่มเติม'),
            ),
            body: TabBarView(
              children: [
                PlacePhotoPage(),
                Center(child: Text('รูปที่อยู่ปัจจุบัน')),
                Center(child: Text('รูปรับทอง')),
                Center(child: Text('รูปติดตาม'))
              ],
            )));
  }
}
