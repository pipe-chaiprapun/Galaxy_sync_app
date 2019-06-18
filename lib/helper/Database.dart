import 'dart:async';
import 'dart:io';

import 'package:de_mobile/models/payment.dart';
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

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "GTDB2.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Payments ("
          "pay_no INTEGER PRIMARY KEY,"
          "con_no TEXT,"
          "cust_name TEXT,"
          "exp_date TEXT,"
          "period INTEGER,"
          "period_left INTEGER,"
          "period_amt INTEGER,"
          "pay_amt INTEGER,"
          "tel TEXT,"
          "sms_status TEXT,"
          "hasImage NUMERIC,"
          "takePhoto NUMERIC"
          ")");
    });
  }

  addContract() async{
    final db = await database;
    var table = await db.rawQuery('SELECT MAX(pay_no)+1 as pay_no FROM Payments');
    int id = table.first['pay_no'];
    var raw = await db.rawInsert('INSERT INTO Payments('
    'pay_no,' 
    'con_no,' 
    'cust_name,' 
    'exp_date,' 
    'period,'
    'period_left,' 
    'period_amt,' 
    'pay_amt,'
    'tel,'
    'sms_status,'
    'hasImage,'
    'takePhoto'
    ') VALUES(?,?,?,?,?,?,?,?,?,?,?,?)', [id, '42545243', 'ณัฏฐพัชร ชัยประพันธ์', '2016-01-01 10:20:05.123', 100, 20, 430, 25000, '0897567880', 'SUCCESS', 0, 0]);
    return raw;
  }
  Future<List<Payments>> getAllPayments() async {
    final db = await database;
    var res = await db.query('Payments');
    List<Payments> data = res.isNotEmpty ? res.map((payment) => Payments.fromMap(payment)).toList() : [];
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