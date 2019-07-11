class PlacePhoto {
  String lnc_no;
  int cust_no;
  String first_name;
  String last_name;
  String file_name;
  String path;
  String latitude = '0';
  String longtitude = '0';
  DateTime photo_date;

  PlacePhoto({this.lnc_no, this.cust_no, this.first_name, this.last_name, this.file_name, this.path, this.latitude, this.longtitude, this.photo_date});

  factory PlacePhoto.fromMap(Map<String, dynamic> json) => new PlacePhoto(
      lnc_no: json['lnc_no'],
      cust_no: json['cust_no'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      file_name: json['file_name'],
      path: json['path'],
      latitude: json['latitude'],
      longtitude: json['longtitude'],
      photo_date: DateTime.parse(json['photo_date'])
      );
}