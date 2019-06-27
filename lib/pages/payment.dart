import 'package:de_mobile/helper/Database.dart';
import 'package:de_mobile/helper/ThaiDate.dart';
import 'package:de_mobile/models/area.dart';
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
  DateTime _payDate;

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
    DBProvider.db.getArea().then((List<Area> res){
      print(res.first.area_no + res.first.area_name);
    });
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
                this._payDate = snapshot.data.length > 0 ? snapshot.data[0].pay_date : null;
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
                    child:
                        ListView(children: <Widget>[_buildDataTable(context)]));
              } else if (snapshot.hasError) {
                print(snapshot.hasError);
              } else {
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
        onSort: (int columnIndex, bool ascending) => _sort<num>(
            (Payment2 p) => p.pay_amt / p.mpay_amt, columnIndex, ascending),
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

  Widget _buildDataTable(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 10),
        _buildHeader(context),
        SizedBox(height: 20),
        PaginatedDataTable(
            header: this._payDate != null ? Text(
              'ประจำวันที่ ${ThaiDate(paydate: this._payDate).fullThaiDate}',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal),
              textAlign: TextAlign.center,
            ) : Text(''),
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
            source: _paymentsDataSource)
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Row(children: <Widget>[
      Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          width: width * 0.25,
          child: DropdownButton<String>(
            value: 'พื้นที่ทั้งหมด',
            onChanged: (String newValue) {
              // setState(() {
              //   dropdown1Value = newValue;
              // });
            },
            items: <String>['พื้นที่ทั้งหมด', 'Two', 'Free', 'Four']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          )),
      Container(
          width: width * 0.3,
          child: TextField(
            decoration: InputDecoration(filled: true, labelText: 'ค้นหาลูกค้า'),
          )),
      Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          width: width * 0.1,
          child: RaisedButton(
              child: Icon(Icons.clear), onPressed: () {}, color: Colors.white))
    ]);
  }
}

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

  Future _takePhoto(String name) async {
    final cameras = await availableCameras();
    print(cameras);
    print(cameras.first);
    Navigator.push(
        this._context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              TakePictureScreen(camera: cameras.first, name: name),
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
        DataCell(Icon(Icons.photo_camera, size: 36, color: Colors.teal),
            onTap: () async {
          _takePhoto(payment.lnc_no);
        }),
        DataCell(TextCell('${payment.lnc_no}')),
        DataCell(TextCell('${payment.first_name} ${payment.last_name}')),
        DataCell(TextCell(DateFormat('dd MMM yyyy').format(DateTime.now()))),
        DataCell(TextCell('${payment.late_no_day}')),
        DataCell(TextCell('${payment.mpay_amt}')),
        DataCell(TextCell('${payment.pay_amt / payment.mpay_amt}')),
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
