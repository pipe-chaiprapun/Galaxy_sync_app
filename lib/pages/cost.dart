import 'package:de_mobile/helper/Database.dart';
import 'package:de_mobile/models/fuelCost.dart';
import 'package:de_mobile/widgets/cost/costMenu.dart';
import 'package:de_mobile/widgets/dataTable/textCell.dart';
import 'package:de_mobile/widgets/dataTable/titleColumn.dart';
import 'package:flutter/material.dart';

enum CostType { fuel, repair, tranport, defray, miscellaneous }

class CostPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CostState();
  }
}

class ExpandItem {
  bool isExpanded;
  final Icon icon;
  final String header;
  final Widget body;
  final int amount;
  ExpandItem({this.isExpanded, this.header, this.body, this.icon, this.amount});
}

class CostState extends State<CostPage> {
  List<ExpandItem> items = <ExpandItem>[
    ExpandItem(
        isExpanded: false,
        header: 'ค่าน้ำมันเชื่อเพลิง',
        body: Column(children: <Widget>[
          Container(
              color: Colors.green[400],
              child: ListTile(
                  title: Row(children: <Widget>[
                Text('ทะเบียนรถ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20)),
                Text('เลขเข็มไมล์',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20)),
                Text('จำนวนเงิน',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20))
              ], mainAxisAlignment: MainAxisAlignment.spaceAround))),
          Container(
              child: ListTile(
                  title: Row(children: <Widget>[
            Text('6กว4940'),
            Text('54435'),
            Text('500')
          ], mainAxisAlignment: MainAxisAlignment.spaceAround))),
          Column(
              children: <Widget>[ListTile(
                  title: Row(children: <Widget>[
            Text('รวม'),
            Text(
              'เลขเข็มไมล์',
              style: TextStyle(color: Colors.white),
            ),
            Text('500')
          ], mainAxisAlignment: MainAxisAlignment.spaceAround))])
        ]),
        icon: Icon(Icons.local_gas_station),
        amount: 500),
    ExpandItem(
        isExpanded: false,
        header: 'ค่าซ่อมยานพาหนะ',
        body: Column(children: <Widget>[
          Container(
              color: Colors.green[400],
              child: ListTile(
                  title: Row(children: <Widget>[
                Text('ทะเบียนรถ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20)),
                Text('รายละเอียด',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20)),
                Text('จำนวนเงิน',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20))
              ], mainAxisAlignment: MainAxisAlignment.spaceAround))),
          Container(
              child: ListTile(
                  title: Row(children: <Widget>[
            Text('6กว4940'),
            Text('เปลี่ยนยางอะไหล่หน้า'),
            Text('500')
          ], mainAxisAlignment: MainAxisAlignment.spaceAround))),
          Container(
              child: ListTile(
                  title: Row(children: <Widget>[
            Text('รวม'),
            Text(
              'รายละเอียด',
              style: TextStyle(color: Colors.white),
            ),
            Text('500')
          ], mainAxisAlignment: MainAxisAlignment.spaceAround)))
        ]),
        icon: Icon(Icons.settings),
        amount: 500),
    ExpandItem(
        isExpanded: false,
        header: 'ค่ายานพาหนะ',
        body: Column(children: <Widget>[
          Container(
              color: Colors.green[400],
              child: ListTile(
                  title: Row(children: <Widget>[
                Text('รายละเอียด',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20)),
                Text('จำนวนเงิน',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20))
              ], mainAxisAlignment: MainAxisAlignment.spaceAround))),
          Container(
              child: ListTile(
                  title: Row(
                      children: <Widget>[Text('บีทีเอส'), Text('500')],
                      mainAxisAlignment: MainAxisAlignment.spaceAround))),
          Container(
              child: ListTile(
                  title: Row(
                      children: <Widget>[Text('รวม'), Text('500')],
                      mainAxisAlignment: MainAxisAlignment.spaceAround)))
        ]),
        icon: Icon(Icons.directions_bus),
        amount: 500),
    ExpandItem(
        isExpanded: false,
        header: 'ทดลองจ่าย',
        body: Padding(
            padding: EdgeInsets.all(10.0), child: Column(children: <Widget>[])),
        icon: Icon(Icons.attach_money),
        amount: 0),
    ExpandItem(
        isExpanded: false,
        header: 'อื่นๆ',
        body: Padding(
            padding: EdgeInsets.all(10.0), child: Column(children: <Widget>[])),
        icon: Icon(Icons.add_circle),
        amount: 0)
  ];

  // ListView List_Criteria;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('ค่าใช้จ่ายต่างๆ',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
        body: _buildListCost(),
        floatingActionButton: CostMenu());
  }

  Widget _buildExpandedHeader({Icon icon, String header, int amount}) {
    return ListTile(
        leading: icon,
        title: Text(header,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
            )),
        trailing: Text('$amount บาท',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w100,
            )));
  }

  Widget _buildTileHeader(CostType type) {
    switch (type) {
      case CostType.fuel:
        {
          return Container(
              color: Colors.green[400],
              child: ListTile(
                  title: Row(children: <Widget>[
                Text('ทะเบียนรถ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20)),
                Text('เลขเข็มไมล์',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20)),
                Text('จำนวนเงิน',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20))
              ], mainAxisAlignment: MainAxisAlignment.spaceAround)));
        }
        break;
      case CostType.repair:
        {
          return Container(
              color: Colors.green[400],
              child: ListTile(
                  title: Row(children: <Widget>[
                Text('ทะเบียนรถ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20)),
                Text('รายละเอียด',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20)),
                Text('จำนวนเงิน',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20))
              ], mainAxisAlignment: MainAxisAlignment.spaceAround)));
        }
        break;
      case CostType.tranport:
        {
          return Container(
              color: Colors.green[400],
              child: ListTile(
                  title: Row(children: <Widget>[
                Text('รายละเอียด',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20)),
                Text('จำนวนเงิน',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20))
              ], mainAxisAlignment: MainAxisAlignment.spaceAround)));
        }
        break;
      case CostType.defray:
        {
          return Container(
              color: Colors.green[400],
              child: ListTile(
                  title: Row(children: <Widget>[
                Text('รายละเอียด',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20)),
                Text('จำนวนเงิน',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20))
              ], mainAxisAlignment: MainAxisAlignment.spaceAround)));
        }
        break;
      case CostType.miscellaneous:
        {
          return Container(
              color: Colors.green[400],
              child: ListTile(
                  title: Row(children: <Widget>[
                Text('รายการ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20)),
                Text('รายละเอียด',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20)),
                Text('จำนวนเงิน',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20))
              ], mainAxisAlignment: MainAxisAlignment.spaceAround)));
        }
    }
  }
  
  // Widget _buildTileBody(CostType type) {
  //   switch (type) {
  //     case CostType.fuel:
  //       {
  //         return FutureBuilder(
  //           future: DBProvider.db.getAllFuelCost(),
  //           builder:
  //               (BuildContext context, AsyncSnapshot<List<FuelCost>> snapshot) {
  //             if (snapshot.hasData) {
  //               return snapshot.data.map((FuelCost f){
  //                 return Container()
  //               });

  //               snapshot.data.forEach((p) => _paymentsDataSource._payments.add(
  //                   Payment2(
  //                       doc_no: p.doc_no,
  //                       pay_date: DateTime.now(),
  //                       brh_id: p.brh_id,
  //                       path_no: p.path_no,
  //                       path_name: p.path_name,
  //                       area_no: p.area_name,
  //                       lnc_no: p.lnc_no,
  //                       cust_no: p.cust_no,
  //                       first_name: p.first_name,
  //                       last_name: p.last_name,
  //                       tel_sms: p.tel_sms,
  //                       mpay_amt: p.mpay_amt,
  //                       pay_amt: p.pay_amt,
  //                       last_pay_date: DateTime.now(),
  //                       late_no_day: p.late_no_day,
  //                       bal: p.bal,
  //                       takePhoto: false,
  //                       hasImage: false)));
  //               return Scrollbar(
  //                   child:
  //                       ListView(children: <Widget>[_buildDataTable(context)]));
  //             } else if (snapshot.hasError) {
  //               print(snapshot.hasError);
  //             } else {
  //               return Center(child: CircularProgressIndicator());
  //             }
  //           });
  //       }
  //       break;
  //     case CostType.repair:
  //       {
  //         return Container(
  //             color: Colors.green[400],
  //             child: ListTile(
  //                 title: Row(children: <Widget>[
  //               Text('ทะเบียนรถ',
  //                   style: TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.white,
  //                       fontSize: 20)),
  //               Text('รายละเอียด',
  //                   style: TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.white,
  //                       fontSize: 20)),
  //               Text('จำนวนเงิน',
  //                   style: TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.white,
  //                       fontSize: 20))
  //             ], mainAxisAlignment: MainAxisAlignment.spaceAround)));
  //       }
  //       break;
  //     case CostType.tranport:
  //       {
  //         return Container(
  //             color: Colors.green[400],
  //             child: ListTile(
  //                 title: Row(children: <Widget>[
  //               Text('รายละเอียด',
  //                   style: TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.white,
  //                       fontSize: 20)),
  //               Text('จำนวนเงิน',
  //                   style: TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.white,
  //                       fontSize: 20))
  //             ], mainAxisAlignment: MainAxisAlignment.spaceAround)));
  //       }
  //       break;
  //     case CostType.defray:
  //       {
  //         return Container(
  //             color: Colors.green[400],
  //             child: ListTile(
  //                 title: Row(children: <Widget>[
  //               Text('รายละเอียด',
  //                   style: TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.white,
  //                       fontSize: 20)),
  //               Text('จำนวนเงิน',
  //                   style: TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.white,
  //                       fontSize: 20))
  //             ], mainAxisAlignment: MainAxisAlignment.spaceAround)));
  //       }
  //       break;
  //     case CostType.miscellaneous:
  //       {
  //         return Container(
  //             color: Colors.green[400],
  //             child: ListTile(
  //                 title: Row(children: <Widget>[
  //               Text('รายการ',
  //                   style: TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.white,
  //                       fontSize: 20)),
  //               Text('รายละเอียด',
  //                   style: TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.white,
  //                       fontSize: 20)),
  //               Text('จำนวนเงิน',
  //                   style: TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.white,
  //                       fontSize: 20))
  //             ], mainAxisAlignment: MainAxisAlignment.spaceAround)));
  //       }
  //   }
  // }

  Widget _buildListCost() {
    return ListView(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          child: ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                items[index].isExpanded = !items[index].isExpanded;
              });
            },
            animationDuration: Duration(milliseconds: 800),
            children: items.map((ExpandItem item) {
              return ExpansionPanel(
                canTapOnHeader: true,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return _buildExpandedHeader(
                      icon: item.icon,
                      header: item.header,
                      amount: item.amount);
                },
                isExpanded: item.isExpanded,
                body: item.body,
              );
            }).toList(),
          ),
        )
      ],
    );
  }
}
