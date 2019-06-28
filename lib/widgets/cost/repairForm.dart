import 'package:de_mobile/helper/Database.dart';
import 'package:de_mobile/models/fuelCost.dart';
import 'package:de_mobile/widgets/dialog/alert.dart';
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
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('ค่าซ่อมยานพาหนะ'),
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
                          icon: Icon(Icons.person, size: 36,),
                          labelText: 'ทะเบียนรถ *',
                        ),
                        onSaved: (String value) => _cost.license_plate = value,
                        validator: _validateLicense,
                        style: TextStyle(fontSize: 24),
                      ),
                      SizedBox(height: 24.0),
                      TextFormField(
                        decoration: const InputDecoration(
                          filled: true,
                          icon: Icon(Icons.details, size: 36),
                          border: OutlineInputBorder(),
                          labelText: 'รายละเอียด *',
                        ),
                        maxLines: 3,
                        validator: _validateDescription,
                        onSaved: (String value) => _cost.description = value,
                        style: TextStyle(fontSize: 24)
                      ),
                      const SizedBox(height: 24.0),
                      TextFormField(
                          autovalidate: _autovalidate,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.attach_money, size: 36),
                            border: OutlineInputBorder(),
                            labelText: 'ค่าซ่อม *',
                            prefixText: '฿',
                            suffixText: 'บาท',
                            filled: true,
                            suffixStyle: TextStyle(color: Colors.green),
                          ),
                          maxLines: 1,
                          validator: _validateCost,
                          onSaved: (String value) => _cost.cost = int.parse(value),
                          style: TextStyle(fontSize: 24)),
                      SizedBox(height: 24.0),
                      SizedBox(height: 24.0),
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
    Alert alert = new Alert();

    if (!form.validate()) {
      alert.message = 'กรุณากรอกข้อมูลให้ถูกต้อง!';
      alert.snackBar(_scaffoldKey);
      _autovalidate = true;
      // return;
    } else {
      form.save();
      alert.message = 'คุณต้องการบันทึกรายการค่าใช้จ่ายหรือไม่?';
      alert.confirmDialog(context).then((bool ans) {
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
              Navigator.pop(context, RepairFormAction.saved);
            } else {
              alert.message = 'ไม่สามารถบันทีึกข้อมูลค่าใช้จ่ายได้!';
              alert.alertDialog(context);
            }
          }).catchError((onError){
            alert.message = 'ไม่สามารถบันทึกข้อมูลค่าใช้จ่ายได้!';
            alert.alertDialog(context).then((ans) {
              alert.message = onError.toString();
              alert.snackBar(_scaffoldKey);
            });
          });
        }
      });
    }
  }

  String _validateLicense(String value) {
    if (value.isEmpty) return 'กรุณากรอกเลขทะเบียนรถ!';
    return null;
  }

  String _validateDescription(String value) {
    if (value.isEmpty) return 'กรุณากรอกรายละเอียด';
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
