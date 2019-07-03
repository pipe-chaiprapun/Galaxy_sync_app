import 'dart:io';
import 'package:de_mobile/constants/httpService.dart';
import 'package:de_mobile/helper/Database.dart';
import 'package:de_mobile/models/payment2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart' as dio;
import 'dart:convert';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

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
  incomplete,
  sendPhoto,
  photoComplete,
  photoIncomplete
}

class _sendPaymentState extends State<SendPaymentPage> {
  PaymentAction action;
  List<Payment2> payments = [];
  String host = HttpService.host;
  String port = HttpService.port;
  String checkStatusUrl =
      '${HttpService.host}:${HttpService.port}${HttpService.checkStatus}';
  String sendPaymentUrl =
      '${HttpService.host}:${HttpService.port}${HttpService.sendPayment}';
  String sendPhotosUrl =
      '${HttpService.host}:${HttpService.port}${HttpService.sendPhoto}';
  double uploadPhotoProgress = 0;

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
        return _buildCheckUI();
        break;
      case PaymentAction.connected:
        return _buildConnectedUI();
        break;
      case PaymentAction.disconnected:
        return _buildDisconnectedUI();
        break;
      case PaymentAction.send:
        return _buildSendUI();
        break;
      case PaymentAction.complete:
        return _buildCompletedUI();
        break;
      case PaymentAction.incomplete:
        return _buildIncompleteUI();
        break;
      case PaymentAction.sendPhoto:
        return _buildSendPhotosUI();
        break;
      case PaymentAction.photoComplete:
        return _buildCompletedPhotosUI();
        break;
      case PaymentAction.photoIncomplete:
        return _buildIncompletePhotosUI();
        break;
    }
  }

  checkConnection() async {
    get(checkStatusUrl).then((Response res) {
      print(res.statusCode);
      if (res.statusCode == 200) {
        setState(() {
          action = PaymentAction.connected;
        });
      } else {
        setState(() {
          action = PaymentAction.disconnected;
        });
        Future.delayed(const Duration(seconds: 5), () {
          setState(() {
            action = PaymentAction.check;
          });
          checkConnection();
        });
      }
    }).timeout(Duration(seconds: 20), onTimeout: () {
      setState(() {
        action = PaymentAction.disconnected;
      });
      Future.delayed(const Duration(seconds: 5), () {
        setState(() {
          action = PaymentAction.check;
        });
        checkConnection();
      });
    }).catchError((onError) {
      print(onError);
      setState(() {
        action = PaymentAction.disconnected;
      });
      Future.delayed(const Duration(seconds: 5), () {
        setState(() {
          action = PaymentAction.check;
        });
        checkConnection();
      });
    });
  }

  sendPayment(List<Payment2> payments) async {
    print(payments.first.toJson());
    List<Map<String, dynamic>> body = new List<Map<String, dynamic>>();
    payments.forEach((p) => body.add(p.toJson()));
    post(sendPaymentUrl,
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'}).then((Response res) {
      print(res.statusCode);
      if (res.statusCode == 200) {
        print('http ok');
        print(res.body);
        setState(() {
          action = PaymentAction.sendPhoto;
        });
        sendPhotos();
      } else {
        print('http code error');
        print(res.statusCode);
        print(res.reasonPhrase);
        print(json.decode(res.body));
        setState(() {
          action = PaymentAction.incomplete;
        });
      }
    }).timeout(Duration(seconds: 60), onTimeout: () {
      print('time out');
      setState(() {
        action = PaymentAction.incomplete;
      });
    }).catchError((onError) {
      print(onError);
      setState(() {
        action = PaymentAction.incomplete;
      });
    });
  }

  sendPhotos() {
    getExternalStorageDirectory().then((directory) {
      final String storagePath = directory.path;
      final photoPath = '$storagePath/DE';
      Directory(photoPath).exists().then((onValue) {
        if (onValue) {
          var files = Directory(photoPath).listSync();
          List<dio.UploadFileInfo> uploadFiles = new List<dio.UploadFileInfo>();
          dio.Dio httpClient = new dio.Dio();
          for (var file in files) {
            print(basename(file.path));
            uploadFiles.add(new dio.UploadFileInfo(
                new File(file.path), basename(file.path)));
          }
          dio.FormData formData = new dio.FormData.from({"files": uploadFiles});
          httpClient.post(sendPhotosUrl, data: formData, onSendProgress: (sent, total){
            var percent = (sent/total)*100;
            setState(() {
              uploadPhotoProgress = percent;
            });
          }).then((res) {
            uploadPhotoProgress = 0;
            if (res.statusCode == 200) {
              print('upload photo ok');
              print(res.data);
              setState(() {
                action = PaymentAction.photoComplete;
              });
            } else {
              print('upload photos error');
              print(res.data);
              setState(() {
                action = PaymentAction.incomplete;
              });
            }
          }).catchError((onError) {
            print('upload photos error');
            print(onError);
            setState(() {
              action = PaymentAction.photoIncomplete;
            });
          });
        }
      });
    });
  }

  Widget _buildCheckUI() {
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

  Widget _buildConnectedUI() {
    return Column(
        children: <Widget>[
          Icon(
            Icons.cloud_upload,
            size: 100,
            color: Colors.green,
          ),
          SizedBox(
            height: 50,
          ),
          Text('สถานะพร้อมส่งข้อมูล',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 10,
          ),
          RaisedButton(
              child: Text('ส่งใบรายวัน',
                  style: TextStyle(fontSize: 24, color: Colors.white)),
              onPressed: () {
                setState(() {
                  action = PaymentAction.send;
                  DBProvider.db.getAllPayments().then((res) {
                    print(res.length);
                    if (res != null) {
                      print('has data');
                      sendPayment(res);
                    }
                  });
                });
              })
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center);
  }

  Widget _buildDisconnectedUI() {
    return Column(
        children: <Widget>[
          Icon(
            Icons.cloud_upload,
            size: 100,
            color: Colors.red[300],
          ),
          SizedBox(height: 50),
          Text('ไม่สามารถเชื่อมต่อเซิฟเวอร์ได้ กรุณาตรวจสัญญาณ WiFi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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

  Widget _buildSendUI() {
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

  Widget _buildCompletedUI() {
    return Column(
        children: <Widget>[
          Icon(Icons.assignment_turned_in, size: 100, color: Colors.green),
          SizedBox(height: 50),
          Text(
            'ส่งใบรายวันสำเร็จ',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center);
  }

  Widget _buildIncompleteUI() {
    return Column(
        children: <Widget>[
          Icon(Icons.assignment_late, size: 100, color: Colors.red[300]),
          SizedBox(height: 50),
          Text(
            'การส่งใบรายวันล้มเหลว',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          RaisedButton(
              child: Text('ส่งใบรายวัน',
                  style: TextStyle(fontSize: 28, color: Colors.white)),
              onPressed: () {
                setState(() {
                  action = PaymentAction.send;
                  DBProvider.db.getAllPayments().then((res) {
                    print(res.length);
                    if (res != null) {
                      print('has data');
                      sendPayment(res);
                    }
                  });
                });
              })
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center);
  }

  Widget _buildSendPhotosUI() {
    return Column(
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(
            height: 10,
          ),
          Text(
            'กำลังส่งรูป',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '${uploadPhotoProgress.toStringAsFixed(1)} %',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center);
  }

  Widget _buildCompletedPhotosUI() {
    return Column(
        children: <Widget>[
          Icon(Icons.image, size: 100, color: Colors.green),
          SizedBox(height: 50),
          Text(
            'ส่งรูปสำเร็จ',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center);
  }

  Widget _buildIncompletePhotosUI() {
    return Column(
        children: <Widget>[
          Icon(Icons.photo_library, size: 100, color: Colors.red[300]),
          SizedBox(height: 50),
          Text(
            'การส่งรูปล้มเหลว',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          RaisedButton(
              child: Text('ส่งรูป',
                  style: TextStyle(fontSize: 28, color: Colors.white)),
              onPressed: () {
                setState(() {
                  // action = PaymentAction.send;
                  // DBProvider.db.getAllPayments().then((res) {
                  //   print(res.length);
                  //   if (res != null) {
                  //     print('has data');
                  //     sendPayment(res);
                  //   }
                  // });
                });
              })
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center);
  }
}
