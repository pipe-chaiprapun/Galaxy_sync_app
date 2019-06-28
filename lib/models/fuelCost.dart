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

class TransportCost {
  String description;
  int cost;
  DateTime cost_date;

  TransportCost({this.description, this.cost, this.cost_date});

  factory TransportCost.fromMap(Map<String, dynamic> json) => new TransportCost(

      description: json['description'],
      cost: json['cost'],
      cost_date: DateTime.parse(json['cost_date']));
}

class DefrayCost {
  String description;
  int cost;
  DateTime cost_date;

  DefrayCost({this.description, this.cost, this.cost_date});

  factory DefrayCost.fromMap(Map<String, dynamic> json) => new DefrayCost(

      description: json['description'],
      cost: json['cost'],
      cost_date: DateTime.parse(json['cost_date']));
}

class MiscellaneousCost{
  String name;
  String description;
  int cost;
  DateTime cost_date;

  MiscellaneousCost({this.name, this.description, this.cost, this.cost_date});

  factory MiscellaneousCost.fromMap(Map<String, dynamic> json) => new MiscellaneousCost(
      name: json['name'],
      description: json['description'],
      cost: json['cost'],
      cost_date: DateTime.parse(json['cost_date']));
}