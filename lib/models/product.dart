import 'dart:convert';

import 'dart:io';

import 'package:flutter/material.dart';

Product productFromJson(String str) {
  final jsonData = json.decode(str);
  return Product.fromMap(jsonData);
}

String productToJson(Product data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Product {
  String productName, barcode, description, imageName;
  int providerId, unitId, id, saleTypeId, categoryId;
  bool hasNoBarcode, isEdited;
  File image;
  Color primaryColor;

  Product({
    this.id,
    this.productName,
    this.barcode,
    this.providerId,
    this.unitId,
    this.saleTypeId,
    this.categoryId,
    this.description,
    this.hasNoBarcode,
    this.isEdited,
    this.imageName,
    this.image,
    this.primaryColor,
  });

  factory Product.fromMap(Map<String, dynamic> json) => new Product(
        id: json["id"],
        unitId: json['unitId'],
        barcode: json['barcode'],
        imageName: json['imageName'],
        providerId: json['providerId'],
        saleTypeId: json['saleTypeId'],
        categoryId: json['categoryId'],
        productName: json['productName'],
        description: json['description'],
        isEdited: json['isEdited'] == 0 ? false : true,
        hasNoBarcode: json['hasNoBarcode'] == 0 ? false : true,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "unitId": unitId,
        "barcode": barcode,
        "imageName": imageName,
        "isEdited": isEdited,
        "providerId": providerId,
        "saleTypeId": saleTypeId,
        "categoryId": categoryId,
        "productName": productName,
        "description": description,
        "hasNoBarcode": hasNoBarcode,
      };
}
