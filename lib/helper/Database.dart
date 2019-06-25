import 'dart:async';
import 'dart:io';

import 'package:de_mobile/models/payment.dart';
import 'package:de_mobile/models/payment2.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:sqlite_demo/ClientModel.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  // initDB() async {
  //   Directory documentsDirectory = await getApplicationDocumentsDirectory();
  //   String path = join(documentsDirectory.path, "GTDB.db");
  //   return await openDatabase(path, version: 1, onOpen: (db) {},
  //       onCreate: (Database db, int version) async {
  //     await db.execute("CREATE TABLE Payments ("
  //         "pay_no INTEGER PRIMARY KEY,"
  //         "con_no TEXT,"
  //         "cust_name TEXT,"
  //         "exp_date TEXT,"
  //         "period INTEGER,"
  //         "period_left INTEGER,"
  //         "period_amt INTEGER,"
  //         "pay_amt INTEGER,"
  //         "tel TEXT,"
  //         "sms_status TEXT,"
  //         "hasImage NUMERIC,"
  //         "takePhoto NUMERIC"
  //         ")");
  //   });
  // }
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "GTDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Payments ("
          "doc_no TEXT KEY,"
          "pay_date TEXT,"
          "brh_id TEXT,"
          "path_no TEXT,"
          "path_name TEXT,"
          "area_no TEXT,"
          "area_name TEXT,"
          "lnc_no TEXT,"
          "cust_no INTEGER,"
          "first_name TEXT,"
          "last_name TEXT,"
          "tel_sms TEXT,"
          "mpay_amt INTEGER,"
          "pay_amt INTEGER,"
          "last_pay_date TEXT,"
          "late_no_day INTEGER,"
          "bal INTEGER,"
          "hasImage NUMERIC,"
          "takePhoto NUMERIC"
          ")");
    });
  }

  // addContract() async{
  //   final db = await database;
  //   var table = await db.rawQuery('SELECT MAX(pay_no)+1 as pay_no FROM Payments');
  //   int id = table.first['pay_no'];
  //   var raw = await db.rawInsert('INSERT INTO Payments('
  //   'pay_no,'
  //   'con_no,'
  //   'cust_name,'
  //   'exp_date,'
  //   'period,'
  //   'period_left,'
  //   'period_amt,'
  //   'pay_amt,'
  //   'tel,'
  //   'sms_status,'
  //   'hasImage,'
  //   'takePhoto'
  //   ') VALUES(?,?,?,?,?,?,?,?,?,?,?,?)', [id, '42545243', 'ณัฏฐพัชร ชัยประพันธ์', '2016-01-01 10:20:05.123', 100, 20, 430, 25000, '0897567880', 'SUCCESS', 0, 0]);
  //   return raw;
  // }
  addContract() async {
    final db = await database;
    var raw = await db.rawInsert(
        'INSERT INTO Payments('
        'doc_no,'
        'pay_date,'
        'brh_id,'
        'path_no,'
        'path_name,'
        'area_no,'
        'area_name,'
        'lnc_no,'
        'cust_no,'
        'first_name,'
        'last_name,'
        'tel_sms,'
        'mpay_amt,'
        'pay_amt,'
        'last_pay_date,'
        'late_no_day,'
        'bal,'
        'hasImage,'
        'takePhoto'
        ') VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          '42435',
          '2016-01-01 10:20:05.123',
          '02',
          '24',
          'ณัฏฐพัชร',
          '5',
          'มหาชัย',
          '84748494',
          23432,
          'ณัฏฐพัชร',
          'ชัยประพันธ์',
          '0897567880',
          450,
          0,
          '2016-01-01 10:20:05.123',
          0,
          25000,
          0,
          0
        ]);
    return raw;
  }
  clearPayments() async{
    final db = await database;
    db.rawDelete('delete from Payments');
  }
  Future<int> addPayments(List<Payment2> data) async {
    final db = await database;
    int res;
    data.forEach((p) async {
      res = await db.rawInsert(
        'INSERT INTO Payments('
        'doc_no,'
        'pay_date,'
        'brh_id,'
        'path_no,'
        'path_name,'
        'area_no,'
        'area_name,'
        'lnc_no,'
        'cust_no,'
        'first_name,'
        'last_name,'
        'tel_sms,'
        'mpay_amt,'
        'pay_amt,'
        'last_pay_date,'
        'late_no_day,'
        'bal,'
        'hasImage,'
        'takePhoto'
        ') VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          p.doc_no,
          '2016-01-01 10:20:05.123',
          p.brh_id,
          p.path_no,
          p.path_name,
          p.area_no,
          p.area_name,
          p.lnc_no,
          p.cust_no,
          p.first_name,
          p.last_name,
          p.tel_sms,
          p.mpay_amt,
          p.pay_amt,
          '2016-01-01 10:20:05.123',
          p.late_no_day,
          p.bal,
          0,
          0
        ]);
    });
    return res;
  }

  // Future<List<Payments>> getAllPayments() async {
  //   final db = await database;
  //   var res = await db.query('Payments');
  //   List<Payments> data = res.isNotEmpty
  //       ? res.map((payment) => Payments.fromMap(payment)).toList()
  //       : [];
  //   return data;
  // }
  Future<List<Payment2>> getAllPayments() async {
    final db = await database;
    var res = await db.query('Payments');
    List<Payment2> data = res.isNotEmpty
        ? res.map((payment) => Payment2.fromMap(payment)).toList()
        : [];
    return data;
  }
  // Future<List<Client>> getAllClients() async {
  //   final db = await database;
  //   var res = await db.query("Client");
  //   List<Client> list =
  //       res.isNotEmpty ? res.map((c) => Client.fromMap(c)).toList() : [];
  //   return list;
  // }
  // newClient(Client newClient) async {
  //   final db = await database;
  //   //get the biggest id in the table
  //   var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Client");
  //   int id = table.first["id"];
  //   //insert to the table using the new id
  //   var raw = await db.rawInsert(
  //       "INSERT Into Client (id,first_name,last_name,blocked)"
  //       " VALUES (?,?,?,?)",
  //       [id, newClient.firstName, newClient.lastName, newClient.blocked]);
  //   return raw;
  // }

  // blockOrUnblock(Client client) async {
  //   final db = await database;
  //   Client blocked = Client(
  //       id: client.id,
  //       firstName: client.firstName,
  //       lastName: client.lastName,
  //       blocked: !client.blocked);
  //   var res = await db.update("Client", blocked.toMap(),
  //       where: "id = ?", whereArgs: [client.id]);
  //   return res;
  // }

  // updateClient(Client newClient) async {
  //   final db = await database;
  //   var res = await db.update("Client", newClient.toMap(),
  //       where: "id = ?", whereArgs: [newClient.id]);
  //   return res;
  // }

  // getClient(int id) async {
  //   final db = await database;
  //   var res = await db.query("Client", where: "id = ?", whereArgs: [id]);
  //   return res.isNotEmpty ? Client.fromMap(res.first) : null;
  // }

  // Future<List<Client>> getBlockedClients() async {
  //   final db = await database;

  //   print("works");
  //   // var res = await db.rawQuery("SELECT * FROM Client WHERE blocked=1");
  //   var res = await db.query("Client", where: "blocked = ? ", whereArgs: [1]);

  //   List<Client> list =
  //       res.isNotEmpty ? res.map((c) => Client.fromMap(c)).toList() : [];
  //   return list;
  // }

  // Future<List<Client>> getAllClients() async {
  //   final db = await database;
  //   var res = await db.query("Client");
  //   List<Client> list =
  //       res.isNotEmpty ? res.map((c) => Client.fromMap(c)).toList() : [];
  //   return list;
  // }

  // deleteClient(int id) async {
  //   final db = await database;
  //   return db.delete("Client", where: "id = ?", whereArgs: [id]);
  // }

  // deleteAll() async {
  //   final db = await database;
  //   db.rawDelete("Delete * from Client");
  // }
}
