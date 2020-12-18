import 'dart:ui';

import 'package:barras/barras.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:products_image/constants.dart';
import 'package:products_image/database.dart';
import 'package:products_image/models/product.dart';
import 'package:products_image/models/category.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:products_image/models/provider.dart';
import 'package:products_image/models/saleType.dart';
import 'package:products_image/models/unit.dart';
import 'package:products_image/screens/edit_product/cubit/edit_product_cubit.dart';
import 'package:products_image/screens/edit_product/cubit/edit_product_states.dart';
import 'package:products_image/screens/home/cubit/filter/filter_cubit.dart';
import 'package:products_image/screens/home/cubit/products_list/products_list_cubit.dart';
import 'package:products_image/widgets/form_decoration.dart';

class ProductForm extends StatefulWidget {
  final Product product;
  final Size size;

  ProductForm({Key key, this.product, this.size}) : super(key: key);

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();

  final _productNameCntrl = new TextEditingController();

  final _descriptionCntrl = new TextEditingController();

  final _barcodeCntrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    _productNameCntrl.text = widget.product.productName;
    _descriptionCntrl.text = widget.product.description;
    _barcodeCntrl.text = widget.product.barcode;

    bool productNameValidator, barcodeValidator;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              textInputAction: TextInputAction.next,
              controller: _productNameCntrl,
              decoration: formInputDecoration("Наименование товара"),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Введите наименование товара';
                } else if (productNameValidator) {
                  return 'Такое имя уже существует в БД';
                }

                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              textInputAction: TextInputAction.next,
              controller: _descriptionCntrl,
              decoration: formInputDecoration("Описание"),
              validator: (value) {
                return null;
              },
            ),
            SizedBox(height: 20),
            Container(
              child: Stack(
                children: <Widget>[
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _barcodeCntrl,
                    decoration: formInputDecoration("Штрихкод"),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Введите Штрихкод';
                      } else if (barcodeValidator) {
                        return 'Такой штрихкод уже существует в БД';
                      }
                      return null;
                    },
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        icon: SvgPicture.asset("icons/barcode_scan.svg",
                            color: Colors.black87),
                        onPressed: () async {
                          final barcode = await Barras.scan(context,
                              cancelButtonText: "Назад");

                          if (barcode != null) {
                            _barcodeCntrl.text = barcode;
                          }
                        }),
                  ),
                ],
              ),
            ),
            MyCheckBox(),
            FutureBuilder<List<Category>>(
                future: DBProvider.db.getAllCategories(),
                builder: (context, snapshot) {
                  List<DropdownMenuItem<int>> _categories = [];
                  if (snapshot.hasData) {
                    _categories = convertListToMenuItem(snapshot.data);
                  }

                  return DropdownButtonFormField(
                    value: _categories.length > 0
                        ? widget.product.categoryId
                        : null,
                    items: _categories,
                    decoration: formInputDecoration("Категория"),
                    onChanged: (value) {
                      widget.product.categoryId = value;
                    },
                  );
                }),
            SizedBox(height: 20),
            FutureBuilder<List<Provider>>(
                future: DBProvider.db.getAllProviders(),
                builder: (context, snapshot) {
                  List<DropdownMenuItem<int>> _providers = [];

                  if (snapshot.hasData) {
                    _providers = convertListToMenuItem(snapshot.data);
                  }

                  return DropdownButtonFormField(
                    value: _providers.length > 0
                        ? widget.product.providerId
                        : null,
                    items: _providers,
                    decoration: formInputDecoration("Поставщик"),
                    onChanged: (value) {
                      widget.product.providerId = value;
                    },
                  );
                }),
            SizedBox(height: 20),
            FutureBuilder<List<SaleType>>(
                future: DBProvider.db.getAllSaleTypes(),
                builder: (context, snapshot) {
                  List<DropdownMenuItem<int>> _saleTypes = [];
                  if (snapshot.hasData) {
                    _saleTypes = convertListToMenuItem(snapshot.data);
                  }

                  return DropdownButtonFormField(
                    value: _saleTypes.length > 0
                        ? widget.product.saleTypeId
                        : null,
                    items: _saleTypes,
                    decoration: formInputDecoration("Тип продаж"),
                    onChanged: (value) {
                      widget.product.saleTypeId = value;
                    },
                  );
                }),
            SizedBox(height: 20),
            FutureBuilder<List<Unit>>(
                future: DBProvider.db.getAllUnits(),
                builder: (context, snapshot) {
                  List<DropdownMenuItem<int>> units = [];
                  if (snapshot.hasData) {
                    units = convertListToMenuItem(snapshot.data);
                  }

                  return DropdownButtonFormField(
                    value: units.length > 0 ? widget.product.unitId : null,
                    items: units,
                    decoration: formInputDecoration("Ед. измерения"),
                    onChanged: (value) {
                      widget.product.saleTypeId = value;
                    },
                  );
                }),
            SizedBox(height: 20),
            RaisedButton(
              onPressed: () async {
                productNameValidator =
                    await DBProvider.db.checkProductNameDublicate(
                  _productNameCntrl.text,
                  widget.product.id,
                );
                barcodeValidator = await DBProvider.db.checkBarcodeDublicate(
                  _barcodeCntrl.text,
                  widget.product.id,
                );

                if (!_formKey.currentState.validate()) return;
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(minutes: 5),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Изменение товара. Пожалуйста подождите'),
                      ],
                    ),
                  ),
                );
                final editedProduct = Product(
                  id: widget.product.id,
                  imageName: widget.product.imageName,
                  barcode: _barcodeCntrl.text,
                  description: _descriptionCntrl.text,
                  productName: _productNameCntrl.text,
                  categoryId: widget.product.categoryId,
                  hasNoBarcode: widget.product.hasNoBarcode,
                  providerId: widget.product.providerId,
                  saleTypeId: widget.product.saleTypeId,
                  unitId: widget.product.unitId,
                );
                context.read<EditProductCubit>().editProduct(editedProduct);
              },
              color: Color(0xFF28A745),
              textColor: Colors.white,
              elevation: 1,
              padding: EdgeInsets.all(0.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  gradient: LinearGradient(
                    colors: [Colors.green[700], Colors.green[600]],
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 25.0,
                ),
                child: const Text('Изменить', style: TextStyle(fontSize: 20)),
              ),
            ),
            CubitListener<EditProductCubit, EditProductState>(
              listener: (context, state) {
                if (state is ProductEdited) {
                  Scaffold.of(context).hideCurrentSnackBar();
                  context.read<ProductsCubit>().refreshProducts();
                  Navigator.of(context).pop();
                }
              },
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}

bool checBoxvalue = false;

class MyCheckBox extends StatefulWidget {
  @override
  _MyCheckBoxState createState() => _MyCheckBoxState();
}

class _MyCheckBoxState extends State<MyCheckBox> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: checBoxvalue,
      title: Text("Автогенерация штрихкода"),
      onChanged: (val) {
        setState(() {
          checBoxvalue = val;
        });
      },
    );
  }
}

List<DropdownMenuItem<int>> convertListToMenuItem(List list) {
  return list
      .map((saleType) => DropdownMenuItem<int>(
            child: Text(
              saleType.name,
              textWidthBasis: TextWidthBasis.longestLine,
            ),
            value: saleType.id,
          ))
      .toList();
}
