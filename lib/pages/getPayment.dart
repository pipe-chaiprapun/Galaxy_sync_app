import 'package:de_mobile/helper/Database.dart';
import 'package:de_mobile/models/payment2.dart';
//import 'package:de_mobile/pages/resultGetPayment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class GetPaymentPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _getPaymentState();
  }
}

enum PaymentAction { ready,fetch, save, complete }

class _getPaymentState extends State<GetPaymentPage> {
  PaymentAction action;
  List<Payment2> payments = [];

  @override
  initState() {
    super.initState();
    action = PaymentAction.ready;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('รับใบรายวัน'),
          //   actions: <Widget> [
          //   FlatButton(
          //     child: Text('SAVE', style: TextStyle(color: Colors.white)),
          //     onPressed: () {
          //       Navigator.pop(context, DismissDialogAction.save);
          //     },
          //   ),
          // ],
        ),
        body: Center(
            child: _buildActivity()));
  }

  Widget _buildActivity() {
    if (action == PaymentAction.fetch) {
      return Column(
          children: <Widget>[
            CircularProgressIndicator(),
            Text(
              'กำลังดึงใบรายวันจากเซิฟเวอร์',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center);
    } else if (action == PaymentAction.save) {
      return Column(
          children: <Widget>[
            CircularProgressIndicator(),
            Text('กำลังเขียนข้อมูลลงใบรายวันลงเครื่อง Galaxy Tab',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center);
    } else if (action == PaymentAction.complete) {
      return Text('รับใบรายวันสำเร็จ',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
    } else{
      return RaisedButton(
                child: Text('รับใบรายวัน',
                    style: TextStyle(fontSize: 28, color: Colors.white)),
                onPressed: () {
                  setState(() {
                    action = PaymentAction.fetch;
                    fetchPayment();
                  });
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute<DismissDialogAction>(
                  //       builder: (BuildContext context) =>
                  //           ResultGetPaymentPage(),
                  //       fullscreenDialog: true,
                  //     ));
                });
    }
  }
  Future fetchPayment() async {
    try {
      await 
          get('http://192.168.0.62:5000/api/sync/test')
          .then((Response response) {
        print(response.statusCode);
        //List<Payment2> payments = [];
        List<dynamic> res = json.decode(response.body);
        res.forEach((f) {
          payments.add(Payment2.fromJson(f));
        });
        print(res.first['pay_date']);
        setState(() {
          print(payments[0].doc_no);
          print(payments[0].pay_date);
          action = PaymentAction.save;
          DBProvider.db.clearPayments();
        });
        setState(() {
          DBProvider.db.addPayments(payments).then((res){
            print('Response from write database');
            print(res);
              action = PaymentAction.ready;
          });
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
