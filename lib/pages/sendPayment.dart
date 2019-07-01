import 'package:de_mobile/helper/Database.dart';
import 'package:de_mobile/models/payment2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class SendPaymentPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _sendPaymentState();
  }
}

enum PaymentAction {
  check,
  connected,
  disconnected,
  send,
  complete,
  incomplete
}

class _sendPaymentState extends State<SendPaymentPage> {
  PaymentAction action;
  List<Payment2> payments = [];

  @override
  initState() {
    super.initState();
    action = PaymentAction.check;
    checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ส่งใบรายวัน'),
          //   actions: <Widget> [
          //   FlatButton(
          //     child: Text('SAVE', style: TextStyle(color: Colors.white)),
          //     onPressed: () {
          //       Navigator.pop(context, DismissDialogAction.save);
          //     },
          //   ),
          // ],
        ),
        body: Center(child: _buildActivity()));
  }

  Widget _buildActivity() {
    switch (action) {
      case PaymentAction.check:
        {
          return Column(
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'กำลังตรวจสอบการเชื่อมต่อกับเซิฟเวอร์',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center);
        }
        break;
      case PaymentAction.connected:
        {
          return Column(
              children: <Widget>[
                Icon(
                  Icons.check_circle_outline,
                  size: 100,
                  color: Colors.green,
                ),
                SizedBox(
                  height: 50,
                ),
                Text('สถานะพร้อมส่งข้อมูล',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                    child: Text('ส่งใบรายวัน',
                        style: TextStyle(fontSize: 24, color: Colors.white)),
                    onPressed: () {
                      setState(() {
                        action = PaymentAction.send;
                        // fetchPayment();
                      });
                    })
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center);
        }
      case PaymentAction.disconnected:
        {
          return Column(
              children: <Widget>[
                Icon(
                  Icons.perm_scan_wifi,
                  size: 100,
                  color: Colors.red[300],
                ),
                SizedBox(height: 50),
                Text('ไม่สามารถเชื่อมต่อเซิฟเวอร์ได้ กรุณาตรวจสัญญาณ WiFi',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                    child: Text('ตรวจสอบการเชื่อมต่อ',
                        style: TextStyle(fontSize: 24, color: Colors.white)),
                    onPressed: () {
                      setState(() {
                        action = PaymentAction.check;
                        checkConnection();
                        // fetchPayment();
                      });
                    })
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center);
        }
      case PaymentAction.send:
        {
          return Column(
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'กำลังส่งใบรายวัน',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center);
        }
      case PaymentAction.complete:
        {
          return Column(
              children: <Widget>[
                Icon(Icons.assignment_turned_in),
                Text(
                  'ส่งใบรายวันสำเร็จ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center);
        }
      case PaymentAction.incomplete:
        {
          return Column(
              children: <Widget>[
                Icon(Icons.error),
                Text(
                  'การส่งใบรายวันล้มเหลว',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                RaisedButton(
                    child: Text('ส่งใบรายวัน',
                        style: TextStyle(fontSize: 28, color: Colors.white)),
                    onPressed: () {
                      setState(() {
                        action = PaymentAction.send;
                        // fetchPayment();
                      });
                    })
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center);
        }
    }
  }

  checkConnection() async {
    get('http://192.168.0.76:5000/api/sync/checkstatus').then((Response res) {
      print(res.statusCode);
      if (res.statusCode == 200) {
        setState(() {
          action = PaymentAction.connected;
        });
      } else {
        setState(() {
          action = PaymentAction.disconnected;
        });
      }
    }).timeout(Duration(seconds: 5), onTimeout: () {
      setState(() {
        action = PaymentAction.disconnected;
      });
    }).catchError((onError) {
      print(onError);
      setState(() {
        action = PaymentAction.disconnected;
      });
    });
  }
}
// Future fetchPayment() async {
//   try {
//     await get('http://192.168.0.59:5000/api/sync/test')
//         .then((Response response) {
//       print(response.statusCode);
//       //List<Payment2> payments = [];
//       List<dynamic> res = json.decode(response.body);
//       res.forEach((f) {
//         payments.add(Payment2.fromJson(f));
//       });
//       print(res.first['pay_date']);
//       setState(() {
//         print(payments[0].doc_no);
//         print(payments[0].pay_date);
//         action = PaymentAction.save;
//         DBProvider.db.clearPayments();
//       });
//       setState(() {
//         DBProvider.db.addPayments(payments).then((res) {
//           print('Response from write database');
//           print(res);
//           action = PaymentAction.ready;
//         });
//       });
//     });
//   } catch (e) {
//     print(e.toString());
//   }
// }
