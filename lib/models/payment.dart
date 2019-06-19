class Payments {
  Payments(
      {this.pay_no,
      this.con_no,
      this.cust_name,
      this.exp_date,
      this.period,
      this.period_left,
      this.period_amt,
      this.pay_amt,
      this.tel,
      this.sms_status,
      this.hasImage,
      this.takePhoto});

  final int pay_no;
  final String con_no;
  final String cust_name;
  final DateTime exp_date;
  final int period;
  final int period_left;
  final int period_amt;
  final int pay_amt;
  final String tel;
  final String sms_status;
  final bool hasImage;
  final bool takePhoto;

  factory Payments.fromMap(Map<String, dynamic> json) => new Payments(
        pay_no: json["pay_no"],
        con_no: json['con_no'],
        cust_name: json["cust_name"],
        exp_date: DateTime.parse(json['exp_date']),
        period: json['period'],
        period_left: json['period_left'],
        period_amt: json['period_amt'],
        pay_amt: json['pay_amt'],
        tel: json['tel'],
        sms_status: json['sms_status'],
        hasImage: json["hasImage"] == 1,
        takePhoto: json['takePhoto'] == 1
      );
}
