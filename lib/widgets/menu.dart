import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MenuState();
  }
}

class _MenuState extends State<Menu> {
  List _list = [
    {
      "id": "catalog",
      "name": "แคตตาล๊อก",
      "icon": Icons.image,
      "color": Colors.grey[600],
      "image": "assets/images/menu/catalog.png"
      //"color": Colors.teal
    },
    {
      "id": "payment",
      "name": "ใบรายวัน",
      "icon": Icons.playlist_add_check,
      "color": Colors.grey[600],
      "image": "assets/images/menu/payment3.jpg"
    },
    {
      "id": "cost",
      "name": "ค่าใช้จ่ายต่างๆ",
      "icon": Icons.payment,
      "color": Colors.grey[600],
      "image": "assets/images/menu/cost.jpg"
      // "color": Colors.green[600]
    },
    {
      "id": "camera",
      "name": "ถ่ายรูปเพิ่มเติม",
      "icon": Icons.camera_alt,
      "color": Colors.grey[600],
      "image": "assets/images/menu/camera2.png"
      // "color": Colors.purple
    },
    {
      "id": "sendPayment",
      "name": "ส่งใบรายวัน",
      "icon": Icons.send,
      "color": Colors.grey[600],
      "image": "assets/images/menu/upload.png"
      // "color": Colors.amber
    },
    {
      "id": "getPayment",
      "name": "รับใบรายวัน",
      "icon": Icons.get_app,
      "color": Colors.grey,
      "image": "assets/images/menu/download.jpg"
      // "color": Colors.blueGrey
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: _list == null
            ? Center(child: const CircularProgressIndicator())
            : _buildGridMenu(_list));
  }

  Widget _buildGridMenu(List<dynamic> list) {
    return GridView.count(
      crossAxisCount: 3,
      padding: EdgeInsets.all(8.0),
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 5.0,
      children: list
          .map((data) => Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Center(
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                                width: 150,
                                height: 150,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 40.0,
                                  backgroundImage: AssetImage(data['image']),
                                  foregroundColor: Colors.teal,
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            _buildTitle(data['name'])
                          ],
                        ))),
              ))
          .toList(),
    );
  }

  Widget _buildTitle(String title) {
    return Container(
        margin: EdgeInsets.only(top: 10, bottom: 1),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(title,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            ]));
  }
}
