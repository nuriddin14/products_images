class Unit {
  int id;
  String name;

  Unit({
    this.id,
    this.name,
  });

  factory Unit.fromMap(Map<String, dynamic> json) {
    return new Unit(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
