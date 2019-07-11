class Payment2 {
  Payment2(
      {this.doc_no,
      this.pay_date,
      this.brh_id,
      this.path_no,
      this.path_name,
      this.area_no,
      this.area_name,
      this.lnc_no,
      this.cust_no,
      this.first_name,
      this.last_name,
      this.tel_sms,
      this.mpay_amt,
      this.pay_amt,
      this.last_pay_date,
      this.late_no_day,
      this.bal,
      this.placeImage,
      this.homeImage,
      this.receiveImage,
      this.traceImage
      // this.hasImage,
      // this.takePhoto
      });

  final String doc_no;
  final DateTime pay_date;
  final String brh_id;
  final String path_no;
  final String path_name;
  final String area_no;
  final String area_name;
  final String lnc_no;
  final int cust_no;
  final String first_name;
  final String last_name;
  final String tel_sms;
  final int mpay_amt;
  final int pay_amt;
  final DateTime last_pay_date;
  final int late_no_day;
  final int bal;
  final int placeImage;
  final int homeImage;
  final int receiveImage;
  final int traceImage;
  // final bool hasImage;
  // final bool takePhoto;

  factory Payment2.fromMap(Map<String, dynamic> json) => new Payment2(
      doc_no: json['doc_no'],
      pay_date: DateTime.parse(json['pay_date']),
      brh_id: json['brh_id'],
      path_no: json['path_no'],
      path_name: json['path_name'],
      area_no: json['area_no'],
      area_name: json['area_name'],
      lnc_no: json['lnc_no'],
      cust_no: json['cust_no'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      tel_sms: json['tel_sms'],
      mpay_amt: json['mpay_amt'],
      pay_amt: json['pay_amt'],
      last_pay_date: DateTime.parse(json['last_pay_date']),
      late_no_day: json['late_no_day'],
      bal: json['bal'],
      placeImage: json['placeImage'],
      homeImage: json['homeImage'],
      receiveImage: json['receiveImage'],
      traceImage: json['traceImage']);

  factory Payment2.fromJson(Map<String, dynamic> json) {
    return Payment2(
        doc_no: json['doc_no'],
        pay_date: DateTime.parse(json['pay_date']),
        brh_id: json['brh_id'],
        path_no: json['path_no'],
        path_name: json['path_name'],
        area_no: json['area_no'],
        area_name: json['area_name'],
        lnc_no: json['lnc_no'],
        cust_no: json['cust_no'],
        first_name: json['first_name'],
        last_name: json['last_name'],
        tel_sms: json['tel_sms'],
        mpay_amt: json['mpay_amt'],
        pay_amt: json['pay_amt'],
        last_pay_date: DateTime.parse(json['last_pay_date']),
        late_no_day: json['late_no_day'],
        bal: json['bal'],
        placeImage: json['placeImage'],
        homeImage: json['homeImage'],
        receiveImage: json['receiveImage'],
        traceImage: json['traceImage']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = new Map<String, dynamic>();
    json['doc_no'] = doc_no;
    json['pay_date'] = pay_date.toString();
    json['brh_id'] = brh_id;
    json['path_no'] = path_no;
    json['path_name'] = path_name;
    json['area_no'] = area_no;
    json['area_name'] = area_name;
    json['lnc_no'] = lnc_no;
    json['cust_no'] = cust_no;
    json['first_name'] = first_name;
    json['last_name'] = last_name;
    json['tel_sms'] = tel_sms;
    json['mpay_amt'] = mpay_amt;
    json['pay_amt'] = pay_amt;
    json['last_pay_date'] = last_pay_date.toString();
    json['late_no_day'] = late_no_day;
    json['bal'] = bal;
    json['placeImage'] = placeImage;
    json['homeImage'] = homeImage;
    json['receiveImage'] = receiveImage;
    json['traceImage'] = traceImage;
    return json;
  }
}
