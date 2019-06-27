class FuelCost {
  String license_plate;
  int miles;
  int cost;
  DateTime cost_date;

  FuelCost({this.license_plate, this.miles, this.cost, this.cost_date});

  factory FuelCost.fromMap(Map<String, dynamic> json) => new FuelCost(
      license_plate: json['license_plate'],
      miles: json['miles'],
      cost: json['cost'],
      cost_date: DateTime.parse(json['cost_date']));
}

class RepairCost {
  String license_plate;
  String description;
  int cost;
  DateTime cost_date;

  RepairCost({this.license_plate, this.description, this.cost, this.cost_date});

  factory RepairCost.fromMap(Map<String, dynamic> json) => new RepairCost(
      license_plate: json['license_plate'],
      description: json['description'],
      cost: json['cost'],
      cost_date: DateTime.parse(json['cost_date']));
}