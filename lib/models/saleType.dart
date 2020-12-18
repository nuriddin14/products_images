class SaleType {
  int id;
  String name;

  SaleType({
    this.id,
    this.name,
  });

  factory SaleType.fromMap(Map<String, dynamic> json) {
    return new SaleType(
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
