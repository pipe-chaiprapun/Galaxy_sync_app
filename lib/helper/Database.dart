import 'dart:async';
import 'dart:io';

import 'package:de_mobile/models/area.dart';
import 'package:de_mobile/models/fuelCost.dart';
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
          "doc_no TEXT,"
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
      await db.execute("CREATE TABLE FuelCost ("
          "license_plate TEXT,"
          "miles INTEGER,"
          "cost INTEGER,"
          "cost_date TEXT"
          ")");
      await db.execute("CREATE TABLE RepairCost ("
          "license_plate TEXT,"
          "description TEXT,"
          "cost INTEGER,"
          "cost_date TEXT"
          ")");
      await db.execute("CREATE TABLE TransportationCost ("
          "description TEXT,"
          "cost INTEGER,"
          "cost_date TEXT"
          ")");
      await db.execute("CREATE TABLE DefrayCost ("
          "description TEXT,"
          "cost INTEGER,"
          "cost_date TEXT"
          ")");
      await db.execute("CREATE TABLE MiscellaneousCost ("
          "name TEXT,"
          "description TEXT,"
          "cost INTEGER,"
          "cost_date TEXT"
          ")");
    });
  }

  clearPayments() async {
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
            p.pay_date.toString(),
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
            p.last_pay_date.toString(),
            p.late_no_day,
            p.bal,
            0,
            0
          ]);
    });
    return res;
  }

  Future<List<Area>> getArea() async {
    final db = await database;
    var res =
        await db.rawQuery('select distinct area_no, area_name from Payments');
    List<Area> data = res.isNotEmpty
        ? res.map((payment) => Area.fromMap(payment)).toList()
        : [];
    return data;
  }

  Future<List<Payment2>> getAllPayments() async {
    final db = await database;
    var res = await db.query('Payments');
    List<Payment2> data = res.isNotEmpty
        ? res.map((payment) => Payment2.fromMap(payment)).toList()
        : [];
    return data;
  }

  Future<int> addFuelCost(FuelCost data) async {
    final db = await database;
    var raw = await db.rawInsert(
        "INSERT Into FuelCost (license_plate,miles,cost,cost_date)"
        " VALUES (?,?,?,?)",
        [data.license_plate, data.miles, data.cost, data.cost_date.toString()]);
    return raw;
  }
  Future<List<FuelCost>> getAllFuelCost() async {
    final db = await database;
    var res = await db.query('FuelCost');
    List<FuelCost> data = res.isNotEmpty
        ? res.map((cost) => FuelCost.fromMap(cost)).toList()
        : [];
    return data;
  }
  

  Future<int> addRepairCost(RepairCost data) async {
    final db = await database;
    var raw = await db.rawInsert(
        "INSERT Into RepairCost (license_plate,description,cost,cost_date)"
        " VALUES (?,?,?,?)",
        [
          data.license_plate,
          data.description,
          data.cost,
          data.cost_date.toString()
        ]);
    return raw;
  }

  Future<int> addTransportCost(TransportCost data) async {
    final db = await database;
    var raw = await db.rawInsert(
        'INSERT Into TransportationCost (description, cost, cost_date)'
        ' VALUES (?,?,?)',
        [data.description, data.cost, data.cost_date.toString()]);
    return raw;
  }

  Future<int> addDefrayCost(DefrayCost data) async {
    final db = await database;
    var raw = await db.rawInsert(
        'INSERT Into DefrayCost (description, cost, cost_date)'
        ' VALUES (?,?,?)',
        [data.description, data.cost, data.cost_date.toString()]);
    return raw;
  }

  Future<int> addMiscellaneousCost(MiscellaneousCost data) async {
    final db = await database;
    var raw = await db.rawInsert(
        'INSERT Into MiscellaneousCost (name,description, cost, cost_date)'
        ' VALUES (?,?,?,?)',
        [data.name, data.description, data.cost, data.cost_date.toString()]);
    return raw;
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
