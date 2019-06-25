import 'package:de_mobile/helper/Database.dart';
import 'package:de_mobile/models/payment2.dart';
import 'package:de_mobile/pages/takePhoto.dart';
import 'package:de_mobile/widgets/dataTable/textCell.dart';
import 'package:de_mobile/widgets/dataTable/titleColumn.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class PaymentPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _paymentState();
  }
}

class _paymentState extends State<PaymentPage> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  // int _rowsPerPage = 20;
  int _sortColumnIndex;
  bool _sortAscending = true;
  PaymentsDataSource _paymentsDataSource;

  void _sort<T>(
      Comparable<T> getField(Payment2 d), int columnIndex, bool ascending) {
    _paymentsDataSource._sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    this._paymentsDataSource = new PaymentsDataSource(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('ข้อมูลการเก็บเงิน'),
        ),
        body: FutureBuilder(
            future: DBProvider.db.getAllPayments(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Payment2>> snapshot) {
              if (snapshot.hasData) {
                print('Query payment from sqlite');
                _paymentsDataSource._payments.clear();
                snapshot.data.forEach((p) => _paymentsDataSource._payments.add(
                    Payment2(
                        doc_no: p.doc_no,
                        pay_date: DateTime.now(),
                        brh_id: p.brh_id,
                        path_no: p.path_no,
                        path_name: p.path_name,
                        area_no: p.area_name,
                        lnc_no: p.lnc_no,
                        cust_no: p.cust_no,
                        first_name: p.first_name,
                        last_name: p.last_name,
                        tel_sms: p.tel_sms,
                        mpay_amt: p.mpay_amt,
                        pay_amt: p.pay_amt,
                        last_pay_date: DateTime.now(),
                        late_no_day: p.late_no_day,
                        bal: p.bal,
                        takePhoto: false,
                        hasImage: false)));
                return Scrollbar(
                    child: ListView(children: <Widget>[_buildDataTable()]));
              }
              else if(snapshot.hasError){
              } 
              else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }

  List<DataColumn> _buildColumnHeader() {
    return <DataColumn>[
      DataColumn(
        label: TitleColumn(''),
      ),
      DataColumn(
        label: TitleColumn('เลขที่สัญญา'),
        onSort: (int columnIndex, bool ascending) =>
            _sort<String>((Payment2 p) => p.lnc_no, columnIndex, ascending),
      ),
      DataColumn(
        label: TitleColumn('ชื่อลูกค้า'),
        numeric: false,
        onSort: (int columnIndex, bool ascending) =>
            _sort<String>((Payment2 p) => p.first_name, columnIndex, ascending),
      ),
      DataColumn(
        label: TitleColumn('หมดอายุ'),
        numeric: false,
        onSort: (int columnIndex, bool ascending) =>
            _sort<DateTime>((Payment2 p) => p.pay_date, columnIndex, ascending),
      ),
      DataColumn(
        label: TitleColumn('ค้าง'),
        numeric: true,
        onSort: (int columnIndex, bool ascending) =>
            _sort<num>((Payment2 p) => p.late_no_day, columnIndex, ascending),
      ),
      DataColumn(
        label: TitleColumn('งวดละ'),
        numeric: true,
        onSort: (int columnIndex, bool ascending) =>
            _sort<num>((Payment2 p) => p.mpay_amt, columnIndex, ascending),
      ),
      DataColumn(
        label: TitleColumn('งวด'),
        numeric: true,
        onSort: (int columnIndex, bool ascending) =>
            _sort<num>((Payment2 p) => p.pay_amt / p.mpay_amt, columnIndex, ascending),
      ),
      DataColumn(
        label: TitleColumn('จำนวนเงิน'),
        tooltip: 'จำนวนเงินที่เก็บได้จากลูกค้่า',
        numeric: true,
        onSort: (int columnIndex, bool ascending) =>
            _sort<num>((Payment2 p) => p.pay_amt, columnIndex, ascending),
      ),
      DataColumn(
        label: TitleColumn('เบอร์ติดต่อ'),
        numeric: false,
        onSort: (int columnIndex, bool ascending) =>
            _sort<String>((Payment2 p) => p.tel_sms, columnIndex, ascending),
      ),
      DataColumn(
        label: TitleColumn('ผลการส่ง SMS'),
        numeric: false,
        onSort: (int columnIndex, bool ascending) =>
            _sort<String>((Payment2 p) => p.tel_sms, columnIndex, ascending),
      )
    ];
  }

  Widget _buildDataTable() {
    return PaginatedDataTable(
        header: Text(
          'ประจำวันที่ 25 มิถุนายน 2562',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal),
          textAlign: TextAlign.center,
        ),
        rowsPerPage: _rowsPerPage,
        onRowsPerPageChanged: (int value) {
          setState(() {
            _rowsPerPage = value;
          });
        },
        sortColumnIndex: _sortColumnIndex,
        sortAscending: _sortAscending,
        onSelectAll: null,
        columns: _buildColumnHeader(),
        source: _paymentsDataSource);
  }
}

// class Dessert {
//   Dessert(this.name, this.calories, this.fat, this.carbs, this.protein,
//       this.sodium, this.calcium, this.iron);
//   final String name;
//   final int calories;
//   final double fat;
//   final int carbs;
//   final double protein;
//   final int sodium;
//   final int calcium;
//   final int iron;

//   bool selected = false;
// }

// class DessertDataSource extends DataTableSource {
//   final List<Dessert> _desserts = <Dessert>[
//     Dessert('Frozen yogurt', 159, 6.0, 24, 4.0, 87, 14, 1),
//     Dessert('Ice cream sandwich', 237, 9.0, 37, 4.3, 129, 8, 1),
//     Dessert('Eclair', 262, 16.0, 24, 6.0, 337, 6, 7),
//     Dessert('Cupcake', 305, 3.7, 67, 4.3, 413, 3, 8),
//     Dessert('Gingerbread', 356, 16.0, 49, 3.9, 327, 7, 16),
//     Dessert('Jelly bean', 375, 0.0, 94, 0.0, 50, 0, 0),
//     Dessert('Lollipop', 392, 0.2, 98, 0.0, 38, 0, 2),
//     Dessert('Honeycomb', 408, 3.2, 87, 6.5, 562, 0, 45),
//     Dessert('Donut', 452, 25.0, 51, 4.9, 326, 2, 22),
//     Dessert('KitKat', 518, 26.0, 65, 7.0, 54, 12, 6),
//     Dessert('Frozen yogurt with sugar', 168, 6.0, 26, 4.0, 87, 14, 1),
//     Dessert('Ice cream sandwich with sugar', 246, 9.0, 39, 4.3, 129, 8, 1),
//     Dessert('Eclair with sugar', 271, 16.0, 26, 6.0, 337, 6, 7),
//     Dessert('Cupcake with sugar', 314, 3.7, 69, 4.3, 413, 3, 8),
//     Dessert('Gingerbread with sugar', 345, 16.0, 51, 3.9, 327, 7, 16),
//     Dessert('Jelly bean with sugar', 364, 0.0, 96, 0.0, 50, 0, 0),
//     Dessert('Lollipop with sugar', 401, 0.2, 100, 0.0, 38, 0, 2),
//     Dessert('Honeycomb with sugar', 417, 3.2, 89, 6.5, 562, 0, 45),
//     Dessert('Donut with sugar', 461, 25.0, 53, 4.9, 326, 2, 22),
//     Dessert('KitKat with sugar', 527, 26.0, 67, 7.0, 54, 12, 6),
//     Dessert('Frozen yogurt with honey', 223, 6.0, 36, 4.0, 87, 14, 1),
//     Dessert('Ice cream sandwich with honey', 301, 9.0, 49, 4.3, 129, 8, 1),
//     Dessert('Eclair with honey', 326, 16.0, 36, 6.0, 337, 6, 7),
//     Dessert('Cupcake with honey', 369, 3.7, 79, 4.3, 413, 3, 8),
//     Dessert('Gingerbread with honey', 420, 16.0, 61, 3.9, 327, 7, 16),
//     Dessert('Jelly bean with honey', 439, 0.0, 106, 0.0, 50, 0, 0),
//     Dessert('Lollipop with honey', 456, 0.2, 110, 0.0, 38, 0, 2),
//     Dessert('Honeycomb with honey', 472, 3.2, 99, 6.5, 562, 0, 45),
//     Dessert('Donut with honey', 516, 25.0, 63, 4.9, 326, 2, 22),
//     Dessert('KitKat with honey', 582, 26.0, 77, 7.0, 54, 12, 6),
//     Dessert('Frozen yogurt with milk', 262, 8.4, 36, 12.0, 194, 44, 1),
//     Dessert('Ice cream sandwich with milk', 339, 11.4, 49, 12.3, 236, 38, 1),
//     Dessert('Eclair with milk', 365, 18.4, 36, 14.0, 444, 36, 7),
//     Dessert('Cupcake with milk', 408, 6.1, 79, 12.3, 520, 33, 8),
//     Dessert('Gingerbread with milk', 459, 18.4, 61, 11.9, 434, 37, 16),
//     Dessert('Jelly bean with milk', 478, 2.4, 106, 8.0, 157, 30, 0),
//     Dessert('Lollipop with milk', 495, 2.6, 110, 8.0, 145, 30, 2),
//     Dessert('Honeycomb with milk', 511, 5.6, 99, 14.5, 669, 30, 45),
//     Dessert('Donut with milk', 555, 27.4, 63, 12.9, 433, 32, 22),
//     Dessert('KitKat with milk', 621, 28.4, 77, 15.0, 161, 42, 6),
//     Dessert('Coconut slice and frozen yogurt', 318, 21.0, 31, 5.5, 96, 14, 7),
//     Dessert(
//         'Coconut slice and ice cream sandwich', 396, 24.0, 44, 5.8, 138, 8, 7),
//     Dessert('Coconut slice and eclair', 421, 31.0, 31, 7.5, 346, 6, 13),
//     Dessert('Coconut slice and cupcake', 464, 18.7, 74, 5.8, 422, 3, 14),
//     Dessert('Coconut slice and gingerbread', 515, 31.0, 56, 5.4, 316, 7, 22),
//     Dessert('Coconut slice and jelly bean', 534, 15.0, 101, 1.5, 59, 0, 6),
//     Dessert('Coconut slice and lollipop', 551, 15.2, 105, 1.5, 47, 0, 8),
//     Dessert('Coconut slice and honeycomb', 567, 18.2, 94, 8.0, 571, 0, 51),
//     Dessert('Coconut slice and donut', 611, 40.0, 58, 6.4, 335, 2, 28),
//     Dessert('Coconut slice and KitKat', 677, 41.0, 72, 8.5, 63, 12, 12),
//   ];
//   void _sort<T>(Comparable<T> getField(Dessert d), bool ascending) {
//     _desserts.sort((Dessert a, Dessert b) {
//       if (!ascending) {
//         final Dessert c = a;
//         a = b;
//         b = c;
//       }
//       final Comparable<T> aValue = getField(a);
//       final Comparable<T> bValue = getField(b);
//       return Comparable.compare(aValue, bValue);
//     });
//     notifyListeners();
//   }

//   int _selectedCount = 0;

//   // @override
//   // DataRow getRow(int index) {
//   //   assert(index >= 0);
//   //   if (index >= _desserts.length) return null;
//   //   final Dessert dessert = _desserts[index];
//   //   return DataRow.byIndex(
//   //     index: index,
//   //     selected: dessert.selected,
//   //     onSelectChanged: null,
//   //     // onSelectChanged: (bool value) {
//   //     //   if (dessert.selected != value) {
//   //     //     _selectedCount += value ? 1 : -1;
//   //     //     assert(_selectedCount >= 0);
//   //     //     dessert.selected = value;
//   //     //     notifyListeners();
//   //     //   }
//   //     // },
//   //     cells: <DataCell>[
//   //       DataCell(Text('${dessert.name}')),
//   //       DataCell(Text('${dessert.calories}')),
//   //       DataCell(Text('${dessert.fat.toStringAsFixed(1)}')),
//   //       DataCell(RaisedButton(
//   //         child: Text('${dessert.carbs}'),
//   //         onPressed: () {
//   //           print('click');
//   //         },
//   //       )),
//   //       DataCell(Text('${dessert.protein.toStringAsFixed(1)}')),
//   //       DataCell(Text('${dessert.sodium}')),
//   //       DataCell(Text('${dessert.calcium}%')),
//   //       DataCell(Text('${dessert.iron}%')),
//   //     ],
//   //   );
//   // }

//   @override
//   int get rowCount => _desserts.length;

//   @override
//   bool get isRowCountApproximate => false;

//   @override
//   int get selectedRowCount => _selectedCount;

//   void _selectAll(bool checked) {
//     for (Dessert dessert in _desserts) dessert.selected = checked;
//     _selectedCount = checked ? _desserts.length : 0;
//     notifyListeners();
//   }
// }

class PaymentsDataSource extends DataTableSource {
  final List<Payment2> _payments = [];
  final BuildContext _context;

  PaymentsDataSource(this._context);

  void _sort<T>(Comparable<T> getField(Payment2 d), bool ascending) {
    _payments.sort((Payment2 a, Payment2 b) {
      if (!ascending) {
        final Payment2 c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    notifyListeners();
  }

  int _selectedCount = 0;

  Future _takePhoto() async {
    final cameras = await availableCameras();
          print(cameras);
          print(cameras.first);
    Navigator.push(
                      this._context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            TakePictureScreen(camera: cameras.first),
                        // fullscreenDialog: true,
                      ));
  }

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _payments.length) return null;
    final Payment2 payment = _payments[index];
    return DataRow.byIndex(
      index: index,
      // selected: payment.selected,
      onSelectChanged: null,
      // onSelectChanged: (bool value) {
      //   if (dessert.selected != value) {
      //     _selectedCount += value ? 1 : -1;
      //     assert(_selectedCount >= 0);
      //     dessert.selected = value;
      //     notifyListeners();
      //   }
      // },
      cells: <DataCell>[
        DataCell(Icon(Icons.photo_camera, size: 36, color: Colors.teal), onTap: () async {        
          _takePhoto();
        }),
        DataCell(TextCell('${payment.lnc_no}')),
        DataCell(TextCell('${payment.first_name} ${payment.last_name}')),
        DataCell(TextCell(DateFormat('dd MMM yyyy').format(DateTime.now()))),
        DataCell(TextCell('${payment.late_no_day}')),
        DataCell(TextCell('${payment.mpay_amt}')),
        DataCell(TextCell('${payment.pay_amt/payment.mpay_amt}')),
        DataCell(TextField(
            textAlign: TextAlign.right,
            decoration: InputDecoration(filled: true),
            keyboardType: TextInputType.number)),
        // DataCell(Text('${payment.pay_amt}')),
        DataCell(TextCell('${payment.tel_sms}')),
        DataCell(TextCell('SUCCESS')),
        // DataCell(Icon(Icons.camera_alt)),
        // DataCell(Icon(Icons.photo_library))
      ],
    );
  }

  @override
  int get rowCount => _payments.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  // void _selectAll(bool checked) {
  //   for (Dessert dessert in _desserts) dessert.selected = checked;
  //   _selectedCount = checked ? _desserts.length : 0;
  //   notifyListeners();
  // }
}
