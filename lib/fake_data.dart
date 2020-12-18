import 'package:products_image/models/category.dart';
import 'package:products_image/models/saleType.dart';
import 'package:products_image/models/unit.dart';

import 'models/provider.dart';

List<SaleType> fakeSaleTypes = [
  SaleType(id: 1, name: "Штрихкод"),
  SaleType(id: 2, name: "Скидочный"),
];
List<Provider> fakeProviders = [
  Provider(id: 1, name: "ООО Зам-Зам"),
  Provider(id: 2, name: "Юрия Фарм"),
  Provider(id: 3, name: "Эмити Интер."),
];
List<Category> fakeCategories = [
  Category(id: 1, name: "Таблетки"),
  Category(id: 2, name: "Сироп"),
  Category(id: 3, name: "Шприцы"),
];
List<Unit> fakeUnits = [
  Unit(id: 1, name: "кг."),
  Unit(id: 2, name: "шт."),
  Unit(id: 3, name: "комплект"),
];

List<SaleType> filterfakeSaleTypes = [
  SaleType(id: 0, name: "Все типы продаж"),
  SaleType(id: 1, name: "Штрихкод"),
  SaleType(id: 2, name: "Скидочный"),
];
List<Provider> filterfakeProviders = [
  Provider(id: 0, name: "Все поставщики"),
  Provider(id: 1, name: "ООО Зам-Зам"),
  Provider(id: 2, name: "Юрия Фарм"),
  Provider(id: 3, name: "Эмити Интер."),
];
List<Category> filterfakeCategories = [
  Category(id: 0, name: "Все категории"),
  Category(id: 1, name: "Таблетки"),
  Category(id: 2, name: "Сироп"),
  Category(id: 3, name: "Шприцы"),
];
List<Unit> filterfakeUnits = [
  Unit(id: 0, name: "Все ед. измерения"),
  Unit(id: 1, name: "кг."),
  Unit(id: 2, name: "шт."),
  Unit(id: 3, name: "комплект"),
];
