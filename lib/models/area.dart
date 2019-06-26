class Area {
  Area({this.area_no, this.area_name});

  final String area_no;
  final String area_name;

  factory Area.fromMap(Map<String, dynamic> json) =>
      new Area(area_no: json['area_no'], area_name: json['area_name']);
}
