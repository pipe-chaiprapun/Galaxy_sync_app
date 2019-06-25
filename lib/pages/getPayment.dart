import 'package:de_mobile/pages/resultGetPayment.dart';
import 'package:flutter/material.dart';

class GetPaymentPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _getPaymentState();
  }
}

class _getPaymentState extends State<GetPaymentPage> {
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
            child: RaisedButton(
                child: (Text('รับใบรายวัน', style: TextStyle(fontSize: 28, color: Colors.white),)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute<DismissDialogAction>(
                        builder: (BuildContext context) =>
                            ResultGetPaymentPage(),
                        fullscreenDialog: true,
                      ));
                })));
  }
}
