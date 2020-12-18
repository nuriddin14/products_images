import 'dart:async';
import 'dart:io';

import 'package:products_image/models/category.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'models/product.dart';
import 'models/provider.dart';
import 'models/saleType.dart';
import 'models/unit.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "SomonSoft.db");
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: _onCreate,
    );
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE Products ("
        "id INTEGER PRIMARY KEY,"
        "productName TEXT,"
        "barcode TEXT,"
        "providerId INTEGER,"
        "unitId INTEGER,"
        "saleTypeId INTEGER,"
        "categoryId INTEGER,"
        "description TEXT,"
        "hasNoBarcode BIT,"
        "isEdited BIT,"
        "imageName TEXT"
        ")");

    await db.execute("CREATE TABLE SaleTypes ("
        "id INTEGER PRIMARY KEY, "
        "name TEXT)");

    await db.execute("CREATE TABLE Providers ("
        "id INTEGER PRIMARY KEY, "
        "name TEXT)");

    await db.execute("CREATE TABLE Categories ("
        "id INTEGER PRIMARY KEY, "
        "name TEXT)");

    await db.execute("CREATE TABLE Units ("
        "id INTEGER PRIMARY KEY, "
        "name TEXT)");
  }

  newProduct(Product newProduct) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id) as id FROM Products");
    int id = table.first["id"];

    if (id == null)
      id = 1;
    else
      id++;

    var raw = await db.rawInsert(
        "INSERT Into Products (id, productName, barcode, providerId, unitId, saleTypeId, categoryId, description, hasNoBarcode, IsEdited, imageName)"
        "VALUES (?,?,?,?,?,?,?,?,?,?,?)",
        [
          id,
          newProduct.productName,
          newProduct.barcode,
          newProduct.providerId,
          newProduct.unitId,
          newProduct.saleTypeId,
          newProduct.categoryId,
          newProduct.description,
          newProduct.hasNoBarcode,
          newProduct.isEdited,
          newProduct.imageName
        ]);

    return raw;
  }

  getProduct(int id) async {
    final db = await database;
    var res = await db.query("Products", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Product.fromMap(res.first) : null;
  }

  addProductImage(int id, String imageName) async {
    final db = await database;
    var raw = await db.rawUpdate(
      'UPDATE Products '
      'SET imageName = ? '
      'WHERE id = ?',
      [imageName, id],
    );

    return raw;
  }

  getImageById(int id) async {
    final db = await database;

    var res =
        await db.rawQuery("SELECT imageName FROM Products WHERE id = $id");

    return res.isNotEmpty ? Product.fromMap(res.first).imageName : null;
  }

  editProduct(Product product) async {
    final db = await database;
    var raw = db.update("Products", product.toMap(),
        where: "id = ?", whereArgs: [product.id]);
    return raw;
  }

  Future<List<Product>> getAllProducts() async {
    final db = await database;
    var res = await db.query("Products");
    List<Product> list =
        res.isNotEmpty ? res.map((c) => Product.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Category>> getAllCategories() async {
    final db = await database;
    var res = await db.query("Categories");

    List<Category> list =
        res.isNotEmpty ? res.map((c) => Category.fromMap(c)).toList() : [];

    return list;
  }

  Future<List<Provider>> getAllProviders() async {
    final db = await database;
    var res = await db.query("Providers");

    List<Provider> list =
        res.isNotEmpty ? res.map((c) => Provider.fromMap(c)).toList() : [];

    return list;
  }

  Future<List<SaleType>> getAllSaleTypes() async {
    final db = await database;
    var res = await db.query("SaleTypes");

    List<SaleType> list =
        res.isNotEmpty ? res.map((c) => SaleType.fromMap(c)).toList() : [];

    return list;
  }

  Future<List<Unit>> getAllUnits() async {
    final db = await database;
    var res = await db.query("Units");

    List<Unit> list =
        res.isNotEmpty ? res.map((c) => Unit.fromMap(c)).toList() : [];

    return list;
  }

  Future<Product> getProductByBarcode(String barcode) async {
    final db = await database;
    var res =
        await db.query("Products", where: "barcode = ?", whereArgs: [barcode]);

    return res.isNotEmpty ? Product.fromMap(res.first) : null;
  }

  addSaleType() async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id) as id FROM SaleTypes");
    int id = table.first["id"];

    if (id == null)
      id = 1;
    else
      id++;

    var raw = await db.rawInsert(
        "INSERT INTO SaleTypes(id, name) VALUES(?,?)", [id, id.toString()]);

    return raw;
  }

  addCategory() async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id) as id FROM Categories");
    int id = table.first["id"];

    if (id == null)
      id = 1;
    else
      id++;

    var raw = await db.rawInsert(
        "INSERT INTO Categories(id, name) VALUES(?,?)", [id, id.toString()]);

    return raw;
  }

  addProvider() async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id) as id FROM Providers");
    int id = table.first["id"];

    if (id == null)
      id = 1;
    else
      id++;

    var raw = await db.rawInsert(
        "INSERT INTO Providers(id, name) VALUES(?,?)", [id, id.toString()]);

    return raw;
  }

  addUnit() async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id) as id FROM Units");
    int id = table.first["id"];

    if (id == null)
      id = 1;
    else
      id++;

    var raw = await db.rawInsert(
        "INSERT INTO Units(id, name) VALUES(?,?)", [id, id.toString()]);

    return raw;
  }

  Future<List<Product>> filteringList(
    int categoryId,
    int providerId,
    int saleTypeId,
    String productName,
  ) async {
    String query = "SELECT * FROM Products WHERE ";

    if (categoryId > 0) query += "categoryId = $categoryId AND ";
    if (providerId > 0) query += "providerId = $providerId AND ";
    if (saleTypeId > 0) query += "saleTypeId = $saleTypeId";

    query = query.trimRight();

    if (query.endsWith('AND')) {
      query = query.substring(0, query.length - 3);
    }
    query += ";";
    print(query);
    final db = await database;
    var res = await db.rawQuery(query);

    List<Product> list =
        res.isNotEmpty ? res.map((c) => Product.fromMap(c)).toList() : [];

    return list;
  }

  Future<bool> checkProductNameDublicate(
      String productName, int productId) async {
    var db = await database;
    List<Map<String, dynamic>> res;

    if (productId > 0) {
      res = await db.rawQuery(
          "SELECT * FROM Products WHERE LOWER(productName) = ? AND id != ?",
          [productName.toLowerCase(), productId]);
    } else {
      res = await db.rawQuery(
          "SELECT * FROM Products WHERE LOWER(productName) = ?",
          [productName.toLowerCase()]);
    }

    return res.isNotEmpty;
  }

  Future<bool> checkBarcodeDublicate(String barcode, int productId) async {
    var db = await database;
    List<Map<String, dynamic>> res;

    if (productId > 0) {
      res = await db.rawQuery(
          "SELECT * FROM Products WHERE barcode = ? AND id != ?",
          [barcode, productId]);
    } else {
      res = await db
          .rawQuery("SELECT * FROM Products WHERE barcode = ?", [barcode]);
    }

    return res.isNotEmpty;
  }
}
