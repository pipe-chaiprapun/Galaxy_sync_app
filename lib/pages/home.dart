import 'package:de_mobile/helper/Database.dart';
import 'package:de_mobile/widgets/menu.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

enum WhyFarther { PayAmtArea, OrderProduct, PaymentCal, Preference, About }

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Domestic Mobile', style: TextStyle(fontSize: 36)),
        centerTitle: true,
      ),
      body: Menu(),
      drawer: _buildSideDrawer(context),
      floatingActionButton: Container(
        child: FloatingActionButton(
          child: Icon(
            Icons.clear_all,
            size: 48,
          ),
          onPressed: () async {
            await DBProvider.db.clearPayments();
          },
        ),
        width: 100,
        height: 100,
      ),
    );
  }

  Widget _buildSideDrawer(BuildContext context) {
    const List _drawerMenu = [
      {
        'id': 'แสดงยอดรวมแต่ละพื้นที่',
        "image": "assets/images/drawer/earning.jpg",
        "url": "/catalog"
      },
      {
        'id': 'บันทึกการสั่งสินค้า',
        "image": "assets/images/drawer/order.jpeg",
        "url": "/catalog"
      },
      {
        'id': 'ตารางค่างวด',
        "image": "assets/images/drawer/installment.png",
        "url": "/catalog"
      },
      {
        'id': 'ปรับแต่ง',
        "image": "assets/images/drawer/preference.png",
        "url": "/catalog"
      },
      {
        'id': 'เกี่ยวกับ',
        "image": "assets/images/drawer/about.png",
        "url": "/catalog"
      }
    ];
    // AnimationController _controller;
    // _controller = AnimationController(
    //   duration: const Duration(milliseconds: 200),
    // );
    // Animation<double> _drawerContentsOpacity;
    // _drawerContentsOpacity = CurvedAnimation(
    //   parent: ReverseAnimation(_controller),
    //   curve: Curves.fastOutSlowIn,
    // );
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: const Text('สาย ณัฏฐพัชร'),
            accountEmail: const Text('สาขา 12'),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage(
                'assets/images/profile/48.jpg',
                // package: _kGalleryAssetsPackage,
              ),
            ),
            otherAccountsPictures: <Widget>[
              GestureDetector(
                dragStartBehavior: DragStartBehavior.down,
                onTap: () {
                  // _onOtherAccountsTap(context);
                },
                child: Semantics(
                  label: 'Switch to Account B',
                  child: const CircleAvatar(
                    backgroundImage: AssetImage(
                      'assets/images/profile/48.jpg',
                      // package: _kGalleryAssetsPackage,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                dragStartBehavior: DragStartBehavior.down,
                onTap: () {
                  // _onOtherAccountsTap(context);
                },
                child: Semantics(
                  label: 'Switch to Account C',
                  child: const CircleAvatar(
                    backgroundImage: AssetImage(
                      'assets/images/profile/48.jpg',
                      // package: _kGalleryAssetsPackage,
                    ),
                  ),
                ),
              ),
            ],
            margin: EdgeInsets.zero,
            onDetailsPressed: () {
              // _showDrawerContents = !_showDrawerContents;
              // if (_showDrawerContents)
              //   _controller.reverse();
              // else
              //   _controller.forward();
            },
          ),
          MediaQuery.removePadding(
            context: context,
            // DrawerHeader consumes top MediaQuery padding.
            removeTop: true,
            child: Expanded(
              child: ListView(
                dragStartBehavior: DragStartBehavior.down,
                padding: const EdgeInsets.only(top: 8.0),
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: _drawerMenu.map<Widget>((menu) {
                          return ListTile(
                            leading: CircleAvatar(backgroundImage: AssetImage(menu['image']),),
                            title: Text(menu['id']),
                            onTap: (){},
                          );
                        }).toList(),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  List<Widget> _buildAppbarAction(){
    return <Widget>[
          PopupMenuButton<WhyFarther>(
            onSelected: (WhyFarther result) {
              // setState(() {
              //   _selection = result;
              // });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<WhyFarther>>[
                  const PopupMenuItem<WhyFarther>(
                    value: WhyFarther.PayAmtArea,
                    child: Text('แสดงยอดรวมแต่ละพื้นที่'),
                  ),
                  const PopupMenuItem<WhyFarther>(
                    value: WhyFarther.OrderProduct,
                    child: Text('บันทึกการสั่งสินค้า'),
                  ),
                  const PopupMenuItem<WhyFarther>(
                    value: WhyFarther.PaymentCal,
                    child: Text('ตารางค่างวด'),
                  ),
                  const PopupMenuItem<WhyFarther>(
                    value: WhyFarther.Preference,
                    child: Text('ปรับแต่ง'),
                  ),
                  const PopupMenuItem<WhyFarther>(
                    value: WhyFarther.About,
                    child: Text('เกี่ยวกับ'),
                  )
                ],
          )
        ];
  }
}
