import 'package:de_mobile/widgets/cost/costMenu.dart';
import 'package:de_mobile/widgets/dataTable/textCell.dart';
import 'package:de_mobile/widgets/dataTable/titleColumn.dart';
import 'package:flutter/material.dart';

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
          Container(
              child: ListTile(
                  title: Row(children: <Widget>[
            Text('รวม'),
            Text(
              'เลขเข็มไมล์',
              style: TextStyle(color: Colors.white),
            ),
            Text('500')
          ], mainAxisAlignment: MainAxisAlignment.spaceAround)))
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
                  title: Row(children: <Widget>[
            Text('รวม'),
            Text('500')
          ], mainAxisAlignment: MainAxisAlignment.spaceAround)))
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

  ListView List_Criteria;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List_Criteria = new ListView(
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
    return Scaffold(
        appBar: AppBar(
            title: Text('ค่าใช้จ่ายต่างๆ',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
        body: List_Criteria,
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
}
