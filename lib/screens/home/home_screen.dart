import 'dart:io';

import 'package:barras/barras.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:products_image/screens/add_product/add_screen.dart';
import 'package:products_image/screens/edit_product/edit_screen.dart';
import 'package:products_image/screens/home/cubit/filter/filter_cubit.dart';
import 'package:products_image/utils/app_utils.dart';

import '../../database.dart';
import 'components/body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:products_image/screens/home/components/filters.dart';
import 'package:products_image/screens/home/cubit/products_list/products_list_cubit.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
bool isSearch;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    isSearch = false;
  }

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      key: _scaffoldKey,
      appBar:
          (isSearch) ? buildSearchBar(buildContext) : buildAppBar(buildContext),
      body: Body(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xFF1B76AB),
        onPressed: () async {
          await DBProvider.db.addCategory();
          await DBProvider.db.addSaleType();
          await DBProvider.db.addUnit();
          await DBProvider.db.addProvider();
          Navigator.push(
              buildContext,
              SwipeablePageRoute(
                  onlySwipeFromEdge: true,
                  builder: (context) => CubitProvider.value(
                      value: buildContext.cubit<ProductsCubit>(),
                      child: AddProductScreen())));
        },
      ),
    );
  }

  AppBar buildAppBar(BuildContext buildContext) {
    return AppBar(
      title: Text("Товары"),
      actions: [
        IconButton(
            icon: Icon(Icons.search_outlined),
            onPressed: () {
              setState(() {
                isSearch = true;
              });
            }),
        IconButton(
            icon:
                SvgPicture.asset("icons/barcode_scan.svg", color: Colors.white),
            iconSize: 30,
            onPressed: () async {
              final barcode =
                  await Barras.scan(context, cancelButtonText: "Назад");

              if (barcode == null) return;

              final product = await DBProvider.db.getProductByBarcode(barcode);

              if (product == null) {
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text("Товар с штрихкодом $barcode не найден"),
                  backgroundColor: Color(0xFF272727),
                  behavior: SnackBarBehavior.floating,
                ));
              } else {
                String folderPath = await AppUtils.getFolderPath('Images');
                if (product.imageName != '' && product.imageName != null) {
                  final File image =
                      File('$folderPath/${product.imageName}.jpg');

                  if (image.existsSync()) {
                    product.image = image;
                    product.primaryColor =
                        await PaletteGenerator.fromImageProvider(
                      FileImage(image),
                      maximumColorCount: 20,
                    ).then((value) => value.dominantColor.color);
                  } else {
                    product.primaryColor = Colors.blue;
                  }
                }

                Navigator.push(
                    buildContext,
                    SwipeablePageRoute(
                        onlySwipeFromEdge: true,
                        builder: (context) => CubitProvider.value(
                              value: buildContext.cubit<ProductsCubit>(),
                              child: EditProductScreen(product: product),
                            )));
              }
            }),
        PopupMenuButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          icon: Icon(Icons.more_vert, color: Colors.white),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'Filters',
              child: Row(
                children: [
                  Icon(
                    Icons.filter_alt_outlined,
                    size: 25,
                    color: Colors.black54,
                  ),
                  SizedBox(width: 10),
                  Text('Фильтры'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'Synchronization',
              child: Row(
                children: [
                  Icon(
                    Icons.sync,
                    color: Colors.black54,
                    size: 25,
                  ),
                  SizedBox(width: 10),
                  Text('Синхронизация'),
                ],
              ),
            ),
          ],
          onSelected: (result) {
            if (result == 'Filters') {
              Navigator.push(
                  buildContext,
                  SwipeablePageRoute(
                      onlySwipeFromEdge: true,
                      builder: (context) => CubitProvider.value(
                          value: buildContext.cubit<ProductsCubit>(),
                          child: CubitProvider.value(
                              value: buildContext.cubit<FiltersCubit>(),
                              child: FiltersScreen()))));
            } else if (result == 'Synchronization') {}
          },
        ),
      ],
    );
  }

  AppBar buildSearchBar(BuildContext buildContext) {
    return AppBar(
      leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            setState(() {
              isSearch = false;
              buildContext.read<ProductsCubit>().filterProductsByName('');
            });
          }),
      title: TextField(
          cursorColor: Colors.white,
          autofocus: true,
          onChanged: (filter) {
            buildContext.read<ProductsCubit>().filterProductsByName(filter);
          },
          style: TextStyle(color: Colors.white, fontSize: 17),
          textAlignVertical: TextAlignVertical.top,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0.0), border: InputBorder.none)),
    );
  }
}
