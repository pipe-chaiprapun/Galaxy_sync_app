import 'package:de_mobile/widgets/cost/fuelForm.dart';
import 'package:de_mobile/widgets/cost/repairForm.dart';
import 'package:de_mobile/widgets/cost/transportForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'defrayForm.dart';
import 'miscellaneousForm.dart';

class CostMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 36),
      // this is ignored if animatedIcon is non null
      // child: Icon(Icons.add),r
      visible: true,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.2,
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      tooltip: 'เพิ่มรายการค่าใช้จ่าย',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 8.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
            child: Icon(Icons.local_gas_station),
            backgroundColor: Colors.green,
            label: 'ค่าน้ำมันเชิื้อเพลิง',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute<FuelFormAction>(
                    builder: (BuildContext context) => FuelForm(),
                    fullscreenDialog: true,
                  )).then((FuelFormAction action) {
                print(action);
              });
            }),
        SpeedDialChild(
          child: Icon(Icons.settings),
          backgroundColor: Colors.green,
          label: 'ค่าซ่อมยานพาหนะ',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute<RepairFormAction>(
                  builder: (BuildContext context) => RepairForm(),
                  fullscreenDialog: true,
                )).then((RepairFormAction action) {
              print(action);
            });
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.directions_bus),
          backgroundColor: Colors.green,
          label: 'ค่ายานพาหนะ',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute<TransportFormAction>(
                  builder: (BuildContext context) => TransportForm(),
                  fullscreenDialog: true,
                )).then((TransportFormAction action) {
              print(action);
            });
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.attach_money),
          backgroundColor: Colors.green,
          label: 'ทดลองจ่าย',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute<DefrayFormAction>(
                  builder: (BuildContext context) => DefrayForm(),
                  fullscreenDialog: true,
                )).then((DefrayFormAction action) {
              print(action);
            });
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.add_circle),
          backgroundColor: Colors.green,
          label: 'อื่นๆ',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute<MiscellaneousFormAction>(
                  builder: (BuildContext context) => MiscellaneousForm(),
                  fullscreenDialog: true,
                )).then((MiscellaneousFormAction action) {
              print(action);
            });
          },
        )
      ],
    );
  }
}
