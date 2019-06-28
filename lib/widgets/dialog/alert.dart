import 'package:flutter/material.dart';

class Alert extends StatelessWidget {
  String message;

  Alert({this.message});

  @override
  Widget build(BuildContext context) {
    return null;
  }
  Future<bool> alertDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(this.message),
              actions: <Widget>[
                FlatButton(
                  child: const Text('ตกลง'),
                  onPressed: () {
                    Navigator.of(context).pop(
                        true); // Pops the confirmation dialog but not the page.
                  },
                )
              ],
            );
          },
        ) ??
        false;
  }
  Future<bool> confirmDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(this.message),
              actions: <Widget>[
                FlatButton(
                  child: const Text('ตกลง'),
                  onPressed: () {
                    Navigator.of(context).pop(
                        true); // Pops the confirmation dialog but not the page.
                  },
                ),
                FlatButton(
                  child: const Text('ยกเลิก'),
                  onPressed: () {
                    Navigator.of(context).pop(
                        false); // Returning true to _onWillPop will pop again.
                  },
                ),
              ],
            );
          },
        ) ??
        false;
  }
  void snackBar(GlobalKey<ScaffoldState> key) {
    key.currentState.showSnackBar(SnackBar(
      content: Text(this.message),
    ));
  }
}
