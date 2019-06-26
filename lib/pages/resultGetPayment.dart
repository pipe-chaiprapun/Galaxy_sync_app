import 'dart:async';
import 'package:de_mobile/helper/Database.dart';
import 'package:de_mobile/models/payment2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum DismissDialogAction {
  cancel,
  discard,
  save,
}

enum GetPaymentAction { fetch, save, complete }

class ResultGetPaymentPage extends StatefulWidget {
  @override
  _resultGetPaymentState createState() => _resultGetPaymentState();
}

class _resultGetPaymentState extends State<ResultGetPaymentPage> {
  DateTime _fromDateTime = DateTime.now();
  DateTime _toDateTime = DateTime.now();
  bool _allDayValue = false;
  bool _saveNeeded = false;
  bool _hasLocation = false;
  bool _hasName = false;
  String _eventName;
  List<Payment2> payments = [];
  GetPaymentAction action;
  @override
  initState() {
    super.initState();
    action = GetPaymentAction.fetch;
    fetchPayment();
  }

  Future<bool> _onWillPop() async {
    _saveNeeded = _hasLocation || _hasName || _saveNeeded;
    if (!_saveNeeded) return true;

    final ThemeData theme = Theme.of(context);
    final TextStyle dialogTextStyle =
        theme.textTheme.subhead.copyWith(color: theme.textTheme.caption.color);

    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(
                'Discard new event?',
                style: dialogTextStyle,
              ),
              actions: <Widget>[
                FlatButton(
                  child: const Text('CANCEL'),
                  onPressed: () {
                    Navigator.of(context).pop(
                        false); // Pops the confirmation dialog but not the page.
                  },
                ),
                FlatButton(
                  child: const Text('DISCARD'),
                  onPressed: () {
                    Navigator.of(context).pop(
                        true); // Returning true to _onWillPop will pop again.
                  },
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(_hasName ? _eventName : 'ใบรายวัน')),
        body: Center(
            child: Form(onWillPop: _onWillPop, child: _buildActivity())));
  }

  Widget _buildActivity() {
    if (action == GetPaymentAction.fetch) {
      return Column(
          children: <Widget>[
            CircularProgressIndicator(),
            Text('กำลังดึงใบรายวันจากเซิฟเวอร์',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center);
    } else if (action == GetPaymentAction.save) {
      return Column(
          children: <Widget>[
            CircularProgressIndicator(),
            Text('กำลังเขียนข้อมูลลงใบรายวันลงเครื่อง Galaxy Tab',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center);
    } else if(action == GetPaymentAction.complete) {
      return Text('รับใบรายวันสำเร็จ',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
    }
  }

  Future fetchPayment() async {
    try {
      await http
          .get('http://192.168.0.62:5000/api/sync/test')
          .then((http.Response response) {
        print(response.statusCode);
        //List<Payment2> payments = [];
        List<dynamic> res = json.decode(response.body);
        res.forEach((f) {
          payments.add(Payment2.fromJson(f));
        });
        setState(() {
          print(payments[0].doc_no);
          action = GetPaymentAction.save;
          DBProvider.db.clearPayments();
        });
        setState(() {
          DBProvider.db.addPayments(payments).then((dynamic res){
            print('Response from write database');
            print(res);
            // if(res>0)
            // {
              action = GetPaymentAction.complete;
            // }
          });
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
