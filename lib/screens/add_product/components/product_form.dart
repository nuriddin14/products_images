import 'package:barras/barras.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:products_image/models/category.dart';
import 'package:products_image/models/provider.dart';
import 'package:products_image/models/saleType.dart';
import 'package:products_image/models/unit.dart';
import 'package:products_image/models/product.dart';
import 'package:products_image/screens/add_product/cubit/add_product_cubit.dart';
import 'package:products_image/screens/add_product/cubit/add_product_states.dart';
import 'package:products_image/screens/home/cubit/products_list/products_list_cubit.dart';
import 'package:products_image/widgets/form_decoration.dart';

import '../../../database.dart';

bool checBoxvalue = false;

// ignore: must_be_immutable
class ProductForm extends StatefulWidget {
  final Size size;
  ProductForm({Key key, this.size}) : super(key: key);

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  int _selectedSaleType, _selectedCategory, _selectedProvider, _selectedUnit;

  final _formKey = GlobalKey<FormState>();

  final _productNameCntrl = new TextEditingController();

  final _descriptionCntrl = new TextEditingController();

  final _barcodeCntrl = new TextEditingController();

  bool productNameValidator = false, barcodeValidator = false;

  @override
  Widget build(BuildContext buildContext) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 20.0, left: 15, right: 15, bottom: 20),
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
                          return 'Введите штрихкод';
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
                      value: null,
                      items: _categories,
                      decoration: formInputDecoration("Категория"),
                      onChanged: (value) {
                        _selectedCategory = value;
                      },
                      validator: (value) {
                        if (value == null && _categories.length > 0) {
                          return 'Выберите категорию';
                        }
                        return null;
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
                      value: null,
                      items: _providers,
                      decoration: formInputDecoration("Поставщик"),
                      onChanged: (value) {
                        _selectedProvider = value;
                      },
                      validator: (value) {
                        if (value == null && _providers.length > 0) {
                          return 'Выберите поставщика';
                        }
                        return null;
                      },
                    );
                  }),
              SizedBox(height: 20),
              FutureBuilder<List<SaleType>>(
                  future: DBProvider.db.getAllSaleTypes(),
                  builder: (context, snapshot) {
                    List<DropdownMenuItem<int>> _saleType = [];
                    if (snapshot.hasData) {
                      _saleType = convertListToMenuItem(snapshot.data);
                    }

                    return DropdownButtonFormField(
                      value: null,
                      items: _saleType,
                      decoration: formInputDecoration("Тип продаж"),
                      onChanged: (value) {
                        _selectedSaleType = value;
                      },
                      validator: (value) {
                        if (value == null && _saleType.length > 0) {
                          return 'Выберите тип продаж';
                        }
                        return null;
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
                      value: null,
                      items: units,
                      decoration: formInputDecoration("Ед. измерения"),
                      onChanged: (value) {
                        _selectedUnit = value;
                      },
                      validator: (value) {
                        if (value == null && units.length > 0) {
                          return 'Выберите eд. измерения';
                        }
                        return null;
                      },
                    );
                  }),
              SizedBox(height: 20),
              RaisedButton(
                onPressed: () async {
                  if (_productNameCntrl.text.trim().isNotEmpty) {
                    productNameValidator = await DBProvider.db
                        .checkProductNameDublicate(_productNameCntrl.text, 0);
                  }
                  if (_barcodeCntrl.text.trim().isNotEmpty) {
                    barcodeValidator = await DBProvider.db
                        .checkBarcodeDublicate(_barcodeCntrl.text, 0);
                  }

                  if (!_formKey.currentState.validate()) return;

                  final newProduct = Product(
                    barcode: _barcodeCntrl.text,
                    description: _descriptionCntrl.text,
                    productName: _productNameCntrl.text,
                    categoryId: _selectedCategory,
                    hasNoBarcode: true,
                    providerId: _selectedProvider,
                    saleTypeId: _selectedSaleType,
                    unitId: _selectedUnit,
                  );

                  buildContext.read<AddProductCubit>().addProduct(newProduct);
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
                  child: const Text('Добавить', style: TextStyle(fontSize: 20)),
                ),
              ),
              CubitListener<AddProductCubit, AddProductState>(
                listener: (context, state) {
                  if (state is ProductAdding) {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        duration: Duration(minutes: 5),
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Добавление товара. Пожалуйста подождите'),
                          ],
                        ),
                      ),
                    );
                  } else if (state is ProductAdded) {
                    Scaffold.of(context).hideCurrentSnackBar();
                    buildContext.read<ProductsCubit>().refreshProducts();
                    Navigator.of(context).pop();
                  }
                },
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<int>> convertListToMenuItem(List list) {
    return list
        .map((element) => DropdownMenuItem<int>(
              child: Text(
                element.name,
                textWidthBasis: TextWidthBasis.parent,
                strutStyle: StrutStyle(fontSize: 10),
              ),
              value: element.id,
            ))
        .toList();
  }
}

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
