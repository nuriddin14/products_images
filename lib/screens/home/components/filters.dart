import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cubit/flutter_cubit.dart';

import 'package:products_image/constants.dart';
import 'package:products_image/database.dart';
import 'package:products_image/models/unit.dart';
import 'package:products_image/models/category.dart';
import 'package:products_image/models/provider.dart';
import 'package:products_image/models/saleType.dart';
import 'package:products_image/screens/home/cubit/filter/filter_cubit.dart';
import 'package:products_image/screens/home/cubit/filter/filter_state.dart';
import 'package:products_image/screens/home/cubit/products_list/products_list_cubit.dart';
import 'package:products_image/utils/filter_data.dart';
import 'package:products_image/widgets/form_decoration.dart';

class FiltersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1B76AB),
        title: Text("Фильтрация"),
        elevation: 0,
      ),
      backgroundColor: Color(0xFF1B76AB),
      body: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 14.0),
          child: CubitBuilder<FiltersCubit, FiltersState>(
            builder: (context, state) {
              if (state is SetFilterData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<List<Category>>(
                        future: DBProvider.db.getAllCategories(),
                        builder: (context, snapshot) {
                          List<DropdownMenuItem<int>> _categories = [
                            new DropdownMenuItem(
                                child: Text("Все категории"), value: 0)
                          ];

                          if (snapshot.hasData) {
                            _categories
                                .addAll(convertListToMenuItem(snapshot.data));
                          }

                          return DropdownButtonFormField(
                            value: state.filterData.categoryId,
                            items: _categories,
                            decoration: formInputDecoration("Категория"),
                            onChanged: (value) {
                              state.filterData.categoryId = value;
                            },
                            validator: (value) {
                              return null;
                            },
                          );
                        }),
                    SizedBox(height: 20),
                    FutureBuilder<List<Provider>>(
                        future: DBProvider.db.getAllProviders(),
                        builder: (context, snapshot) {
                          List<DropdownMenuItem<int>> _providers = [
                            new DropdownMenuItem(
                              child: Text("Все поставщики"),
                              value: 0,
                            )
                          ];
                          if (snapshot.hasData) {
                            _providers
                                .addAll(convertListToMenuItem(snapshot.data));
                          }

                          return DropdownButtonFormField(
                            value: state.filterData.providerId,
                            items: _providers,
                            elevation: 8,
                            decoration: formInputDecoration("Поставщик"),
                            onChanged: (value) {
                              state.filterData.providerId = value;
                            },
                            validator: (value) {
                              return null;
                            },
                          );
                        }),
                    SizedBox(height: 20),
                    FutureBuilder<List<SaleType>>(
                        future: DBProvider.db.getAllSaleTypes(),
                        builder: (context, snapshot) {
                          List<DropdownMenuItem<int>> _saleType = [
                            new DropdownMenuItem(
                                child: Text("Все типы продаж"), value: 0)
                          ];

                          if (snapshot.hasData) {
                            _saleType
                                .addAll(convertListToMenuItem(snapshot.data));
                          }

                          return DropdownButtonFormField(
                            value: state.filterData.saleTypeId,
                            items: _saleType,
                            decoration: formInputDecoration("Тип продаж"),
                            onChanged: (value) {
                              state.filterData.saleTypeId = value;
                            },
                            validator: (value) {
                              return null;
                            },
                          );
                        }),
                    SizedBox(height: 20),
                    FutureBuilder<List<Unit>>(
                        future: DBProvider.db.getAllUnits(),
                        builder: (context, snapshot) {
                          List<DropdownMenuItem<int>> _units = [
                            new DropdownMenuItem(
                                child: Text("Все ед. измерения"), value: 0)
                          ];

                          if (snapshot.hasData) {
                            _units.addAll(convertListToMenuItem(snapshot.data));
                          }

                          return DropdownButtonFormField(
                            value: state.filterData.unitId,
                            items: _units,
                            decoration: formInputDecoration("Ед. измерения"),
                            onChanged: (value) {
                              state.filterData.unitId = value;
                            },
                            validator: (value) {
                              return null;
                            },
                          );
                        }),
                    SizedBox(height: 5),
                    Divider(),
                    SizedBox(height: 5),
                    DropdownButtonFormField<ImageFilterEnum>(
                      value: state.filterData.imageFilterEnum,
                      items: [
                        new DropdownMenuItem(
                          child: Text("Все товары"),
                          value: ImageFilterEnum.allProducts,
                        ),
                        new DropdownMenuItem(
                          child: Text("Товары без фотографии"),
                          value: ImageFilterEnum.withoutImage,
                        ),
                        new DropdownMenuItem(
                          child: Text("Товары с фотографией"),
                          value: ImageFilterEnum.withImage,
                        )
                      ],
                      decoration: formInputDecoration("Товары"),
                      onChanged: (value) {
                        state.filterData.imageFilterEnum = value;
                      },
                      validator: (value) {
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RaisedButton(
                              color: Color(0xFF28A745),
                              textColor: Colors.white,
                              elevation: 5,
                              padding: EdgeInsets.all(0.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF656565),
                                      Color(0xFF656565)
                                    ],
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 25.0,
                                ),
                                child: const Text('Сброс',
                                    style: TextStyle(fontSize: 20)),
                              ),
                              onPressed: () {
                                buildContext
                                    .read<ProductsCubit>()
                                    .filterProducts(new FilterData(
                                        categoryId: 0,
                                        providerId: 0,
                                        saleTypeId: 0,
                                        unitId: 0,
                                        imageFilterEnum:
                                            ImageFilterEnum.allProducts));
                                buildContext
                                    .read<FiltersCubit>()
                                    .saveFilterData(new FilterData(
                                        categoryId: 0,
                                        providerId: 0,
                                        saleTypeId: 0,
                                        unitId: 0,
                                        imageFilterEnum:
                                            ImageFilterEnum.allProducts));
                                Navigator.of(buildContext).pop();
                              }),
                          SizedBox(width: 20),
                          RaisedButton(
                              color: Color(0xFF28A745),
                              textColor: Colors.white,
                              elevation: 5,
                              padding: EdgeInsets.all(0.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF1B76AB),
                                      Color(0xEE1B76AB)
                                    ],
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 25.0,
                                ),
                                child: const Text('Поиск',
                                    style: TextStyle(fontSize: 20)),
                              ),
                              onPressed: () {
                                buildContext
                                    .read<ProductsCubit>()
                                    .filterProducts(state.filterData);
                                buildContext
                                    .read<FiltersCubit>()
                                    .saveFilterData(state.filterData);

                                Navigator.of(buildContext).pop();
                              }),
                        ],
                      ),
                    )
                  ],
                );
              } else
                return Container();
            },
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<int>> convertListToMenuItem(List list) {
    return list
        .map((saleType) => DropdownMenuItem<int>(
              value: saleType.id,
              child: Text(
                saleType.name,
                textWidthBasis: TextWidthBasis.longestLine,
              ),
            ))
        .toList();
  }
}
