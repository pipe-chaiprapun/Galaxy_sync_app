import 'package:de_mobile/pages/catalog.dart';
import 'package:de_mobile/pages/cost.dart';
import 'package:de_mobile/pages/home.dart';
import 'package:de_mobile/pages/payment.dart';
import 'package:de_mobile/pages/payment2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'helper/Database.dart';

void main() {
  // debugPaintSizeEnabled = true;
  // debugPaintBaselinesEnabled = true;
  // debugPaintPointersEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  var db = DBProvider.db.database;

  @override
  Widget build(BuildContext context) {
    // _products.add(Product(title: 'ทองคำแท่ง', description: 'ทองคำแท่ง', price: 15000, image: 'assets/images/gold2.jpg'));
    // _products.add(Product(title: 'ทองคำรูปพรรณ', description: 'ทองคำรูปพรรณ', price: 20000, image: 'assets/images/gold2.jpg'));
    return MaterialApp(
      // debugShowMaterialGrid: true,
      theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.green,
          accentColor: Colors.green,
          buttonColor: Colors.teal,
          fontFamily: 'Kodchasan'),
      // home: AuthPage(),
      routes: {
        '/': (BuildContext context) => HomePage(),
        '/catalog' : (BuildContext context) => CatalogPage(),
        '/payment': (BuildContext context) => PaymentPage(),
        '/payment2': (BuildContext context) => PaymentPage2(),
        '/cost': (BuildContext context) => CostPage()
        // '/products': (BuildContext context) => ProductsPage(), //ProductsPage(_products),
        // '/admin': (BuildContext context) => ProductsAdminPage()
      }
    );
    
  }
}
