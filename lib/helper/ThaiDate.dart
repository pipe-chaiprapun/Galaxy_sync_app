class ThaiDate{
  dynamic monthName = ['', 'มกราคม', 'กุมภาพันธ์', 'มีนาคม', 'เมษายน', 'พฤษภาคม', 'มิถุนายน', 'กรกฎาคม', 'สิงหาคม', 'กันยายน', 'ตุลาคม', 'พฤศจิกายน', 'ธันวาคม'];

  ThaiDate({this.paydate});
  final DateTime paydate;

  String get fullThaiDate => getFullThaiDate();
  String get thaiMonth => monthName[paydate.month];
  String get thaiYear => (paydate.year+543).toString();


  String getFullThaiDate(){
    return '${paydate.day} ${monthName[paydate.month]} ${paydate.year+543}';
  }
}