import 'package:de_mobile/helper/Database.dart';
import 'package:de_mobile/models/fuelCost.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RepairForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _repairFormState();
  }
}

enum RepairFormAction { saved, cancel, fail }

class _repairFormState extends State<RepairForm> {
  // PaymentAction action;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  RepairCost _cost = new RepairCost();
  bool _autovalidate = false;

  @override
  initState() {
    super.initState();
    // action = PaymentAction.ready;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ค่าซ่อมยานพาหนะ'),
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
                          _cost.license_plate = value;
                        },
                        validator: _validateLicense,
                        style: TextStyle(fontSize: 24),
                      ),
                      SizedBox(height: 24.0),
                      TextFormField(
                        decoration: const InputDecoration(
                          filled: true,
                          icon: Icon(Icons.details),
                          border: OutlineInputBorder(),
                          labelText: 'รายละเอียด',
                        ),
                        maxLines: 3,
                        validator: _validateDescription,
                      ),
                      const SizedBox(height: 24.0),
                      TextFormField(
                          autovalidate: _autovalidate,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.attach_money),
                            border: OutlineInputBorder(),
                            labelText: 'ค่าซ่อม *',
                            prefixText: '฿',
                            suffixText: 'บาท',
                            filled: true,
                            suffixStyle: TextStyle(color: Colors.green),
                          ),
                          maxLines: 1,
                          validator: _validateCost,
                          onSaved: (String value) {
                            _cost.cost = int.parse(value);
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
              .addRepairCost(new RepairCost(
                  license_plate: _cost.license_plate,
                  description: _cost.description,
                  cost: _cost.cost,
                  cost_date: DateTime.now()))
              .then((int res) {
            print(res.toString());
            if (res > 0) {
              print('saved success');
              // showInSnackBar('บันทึกข้อมูลสำเร็จ');
              Navigator.pop(context, RepairFormAction.saved);
            } else {
              Navigator.pop(context, RepairFormAction.fail);
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

  String _validateDescription(String value){
    if (value.isEmpty) return 'กรุณากรอกเลขทะเบียนรถ!';
    return null;
  }

  String _validateCost(String value) {
    if (value.isNotEmpty) {
      if (!_isNumeric(value)) {
        return 'กรุณากรอกข้อมูลเป็นตัวเลข!';
      } else {
        if (double.parse(value) < 1) {
          return 'ค่าซ่อมยานพาหนะต้องมากกว่า0!';
        }
      }
    } else if (value.isEmpty) {
      return 'กรุณากรอกค่าซ่อมยานพาหนะ!';
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
