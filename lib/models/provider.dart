class Provider {
  int id;
  String name;

  Provider({
    this.id,
    this.name,
  });

  factory Provider.fromMap(Map<String, dynamic> json) {
    return new Provider(
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
