import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Menu2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Menu2State();
  }
}

class _Menu2State extends State<Menu2> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: _list == null
          ? const Center(child: const CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, mainAxisSpacing: 25.0),
              padding: const EdgeInsets.all(10.0),
              itemCount: _list.length,
              itemBuilder: (BuildContext context, int index) {
                return GridTile(
                  child: Container(
                    //height: 500.0,
                    child: GestureDetector(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            //height: 100.0,
                            width: 100.0,
                            child: Row(
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    SizedBox(
                                      child: Container(
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 40.0,
                                          child: Icon(_list[index]["icon"],
                                              size: 200,
                                              color: _list[index]["color"]),
                                        ),
                                        padding: const EdgeInsets.only(
                                            left: 10.0, right: 10.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // onTap: () {
                      //   Navigator.push(
                      //       context,
                      //       new MaterialPageRoute(
                      //           builder: (_) =>
                      //               new ArticleSourceScreen.ArticleSourceScreen(
                      //                 sourceId: categoriesList.list[index]
                      //                     ['id'],
                      //                 sourceName: categoriesList.list[index]
                      //                     ["name"],
                      //                 isCategory: true,
                      //               )));
                      // },
                    ),
                  ),
                  footer: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: SizedBox(
                            //height: 16.0,
                            //width: 100.0,
                            child: Text(
                              _list[index]["name"],
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              //overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        )
                      ]),
                );
              },
            ),
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
