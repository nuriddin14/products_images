class Category {
  int id;
  String name;

  Category({
    this.id,
    this.name,
  });

  factory Category.fromMap(Map<String, dynamic> json) {
    return new Category(
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
