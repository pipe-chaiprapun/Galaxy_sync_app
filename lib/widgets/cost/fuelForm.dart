import 'package:de_mobile/helper/Database.dart';
import 'package:de_mobile/models/fuelCost.dart';
import 'package:de_mobile/models/payment2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class FuelForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _fuelFormState();
  }
}

enum FuelFormAction { saved, cancel, fail }

class _fuelFormState extends State<FuelForm> {
  // PaymentAction action;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Payment2> payments = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FuelCost _fuelCost = new FuelCost();
  bool _autovalidate = false;
  bool _saveNeeded = false;
  bool _hasLicense = false;
  bool _hasMiles = false;
  bool _hasCost = false;

  @override
  initState() {
    super.initState();
    // action = PaymentAction.ready;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ค่าน้ำมันเชื้อเพลิง'),
          //   actions: <Widget> [
          //   FlatButton(
          //     child: Text('SAVE', style: TextStyle(color: Colors.white)),
          //     onPressed: () {
          //       Navigator.pop(context, DismissDialogAction.save);
          //     },
          //   ),
          // ],
        ),
        body: SafeArea(
            top: false,
            bottom: false,
            child: Form(
              key: _formKey,
              // autovalidate: _autovalidate,
              // onWillPop: _warnUserAboutInvalidData,
              child: Scrollbar(
                child: SingleChildScrollView(
                  dragStartBehavior: DragStartBehavior.down,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(height: 24.0),
                      TextFormField(
                        autovalidate: _autovalidate,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          icon: Icon(Icons.person),
                          labelText: 'ทะเบียนรถ *',
                        ),
                        onSaved: (String value) {
                          _fuelCost.license_plate = value;
                        },
                        validator: _validateLicense,
                        style: TextStyle(fontSize: 24),
                      ),
                      SizedBox(height: 24.0),
                      TextFormField(
                        autovalidate: _autovalidate,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          icon: Icon(Icons.network_check),
                          border: OutlineInputBorder(),
                          filled: true,
                          labelText: 'เลขเข็มไมล์ *',
                          suffixText: 'กิโลเมตร',
                          suffixStyle: TextStyle(color: Colors.green),
                        ),
                        maxLines: 1,
                        validator: _validateMiles,
                        onSaved: (String value) {
                          _fuelCost.miles = int.parse(value);
                        },
                        style: TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 24.0),
                      TextFormField(
                          autovalidate: _autovalidate,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.attach_money),
                            border: OutlineInputBorder(),
                            labelText: 'ค่าน้ำมัน *',
                            prefixText: '฿',
                            suffixText: 'บาท',
                            filled: true,
                            suffixStyle: TextStyle(color: Colors.green),
                          ),
                          maxLines: 1,
                          validator: _validateCost,
                          onSaved: (String value) {
                            _fuelCost.cost = int.parse(value);
                          },
                          style: TextStyle(fontSize: 24)),
                      const SizedBox(height: 24.0),
                      const SizedBox(height: 24.0),
                      Center(
                        child: RaisedButton(
                          child: const Text(
                            'ตกลง',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: _handleSubmitted,
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      Text(
                        '* จำเป็นต้องกรอกข้อมูลให้ครบถ้วน',
                        style: Theme.of(context).textTheme.caption,
                      ),
                      const SizedBox(height: 24.0),
                    ],
                  ),
                ),
              ),
            )));
  }

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      // _autovalidate = true; // Start validating on every change.
      // showInSnackBar('กรุณากรอกข้อมูลให้ถูกต้อง');
      // return;
      _autovalidate = true;
    } else {
      form.save();
      _comfirmSave().then((bool ans) {
        print(ans);
        if (ans) {
          DBProvider.db
              .addFuelCost(new FuelCost(
                  license_plate: _fuelCost.license_plate,
                  miles: _fuelCost.miles,
                  cost: _fuelCost.cost,
                  cost_date: DateTime.now()))
              .then((int res) {
            print(res.toString());
            if (res > 0) {
              print('saved success');
              // showInSnackBar('บันทึกข้อมูลสำเร็จ');
              Navigator.pop(context, FuelFormAction.saved);
            } else {
              Navigator.pop(context, FuelFormAction.fail);
            }
          });
        }
      });
      // showInSnackBar('${person.name}\'s phone number is ${person.phoneNumber}');
    }
  }

  Future<bool> _comfirmSave() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(
                'คุณต้องการบันทึกรายการค่าใช้จ่ายหรือไม่?',
              ),
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

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(value),
    ));
  }

  String _validateLicense(String value) {
    if (value.isEmpty) return 'กรุณากรอกเลขทะเบียนรถ!';
    return null;
  }

  String _validateMiles(String value) {
    if (value.isNotEmpty) {
      if (!_isNumeric(value)) {
        return 'กรุณากรอกข้อมูลเป็นตัวเลข!';
      } else {
        if (double.parse(value) < 1) {
          return 'เลขไมล์ต้องมากกว่า0!';
        }
      }
    } else if (value.isEmpty) {
      return 'กรุณากรอกเลขไมล์!';
    }
    return null;
  }

  String _validateCost(String value) {
    if (value.isNotEmpty) {
      if (!_isNumeric(value)) {
        return 'กรุณากรอกข้อมูลเป็นตัวเลข!';
      } else {
        if (double.parse(value) < 1) {
          return 'ค่าน้ำมันต้องมากกว่า0!';
        }
      }
    } else if (value.isEmpty) {
      return 'กรุณากรอกค่าน้ำมัน!';
    }
    return null;
  }

  bool _isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }
}
