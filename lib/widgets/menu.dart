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
      // "icon": Icons.image,
      // "color": Colors.grey[600],
      "image": "assets/images/menu/catalog.png",
      //"color": Colors.teal
      "url": "/catalog"
    },
    {
      "id": "payment",
      "name": "ใบรายวัน",
      // "icon": Icons.playlist_add_check,
      // "color": Colors.grey[600],
      "image": "assets/images/menu/payment3.jpg",
      'url': '/payment'
    },
    {
      "id": "cost",
      "name": "ค่าใช้จ่ายต่างๆ",
      // "icon": Icons.payment,
      // "color": Colors.grey[600],
      "image": "assets/images/menu/cost.jpg",
      // "color": Colors.green[600]
      "url": "/cost"
    },
    {
      "id": "camera",
      "name": "ถ่ายรูปเพิ่มเติม",
      // "icon": Icons.camera_alt,
      // "color": Colors.grey[600],
      "image": "assets/images/menu/camera2.png"
      // "color": Colors.purple
    },
    {
      "id": "sendPayment",
      "name": "ส่งใบรายวัน",
      // "icon": Icons.send,
      // "color": Colors.grey[600],
      "image": "assets/images/menu/upload.png",
      'url': '/sendPayment'
      // "color": Colors.amber
    },
    {
      "id": "getPayment",
      "name": "รับใบรายวัน",
      // "icon": Icons.get_app,
      // "color": Colors.grey,
      "image": "assets/images/menu/download.jpg",
      // "color": Colors.blueGrey
      'url': '/getPayment'
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _list == null ? Center(child: CircularProgressIndicator()) : _buildGridMenu(_list);
    // return Scaffold(
    //     backgroundColor: Colors.grey[200],
    //     body: _list == null
    //         ? Center(child: const CircularProgressIndicator())
    //         : _buildGridMenu(_list));
  }

  Widget _buildGridMenu(List<dynamic> list) {
    final double deviceWidth = MediaQuery.of(context).size.width;

    final double logoSize = deviceWidth * 0.25;
    final double paddingMenu = deviceWidth * 0.05;
    

    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.all(paddingMenu),
      crossAxisSpacing: 15.0,
      mainAxisSpacing: 15.0,
      children: list
          .map((data) => Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Center(
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: GestureDetector(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                  width: logoSize,
                                  height: logoSize,
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
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, data['url'] == null ? '/catalog' : data['url']);
                          },
                        ))),
              ))
          .toList(),
    );
  }

  Widget _buildTitle(String title) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double titleSize = deviceWidth * 0.03;
    return Container(
        margin: EdgeInsets.only(top: 10, bottom: 1),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(title,
                  style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.bold)),
            ]));
  }
}
