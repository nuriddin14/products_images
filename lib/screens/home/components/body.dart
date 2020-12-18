import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:products_image/models/product.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:products_image/screens/edit_product/edit_screen.dart';
import 'package:products_image/screens/home/cubit/filter/filter_cubit.dart';
import 'package:products_image/screens/home/cubit/products_list/products_list_states.dart';
import 'package:products_image/screens/home/cubit/products_list/products_list_cubit.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'product_card.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext mainContext) {
    return CubitBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        if (state is ProductsLoading) {
          return buildLoadingIndicator(state);
        } else if (state is ProductsEmpty) {
          return buildEmptyState();
        } else if (state is ProductsLoaded) {
          return ProductsList(
            products: state.products,
            buildContext: mainContext,
          );
        } else if (state is FilteredProductsLoaded) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: ProductsList(
                  products: state.filteredProducts,
                  buildContext: mainContext,
                ),
              ),
              buildFiltersBar(mainContext),
            ],
          );
        } else if (state is ProductsError) {
          return Center(
            child: Text("Не удалось получить данные"),
          );
        } else if (state is FilteredProductsEmpty) {
          return Stack(children: [
            buildFiltersBar(mainContext),
            Center(
              child: Text("Не удалось найти товары по вашему запросу"),
            ),
          ]);
        } else {
          return Center(
            child: Text("Не удалось получить состояние"),
          );
        }
      },
    );
  }

  Container buildFiltersBar(BuildContext mainContext) {
    return Container(
      color: Color(0xAA1B76AB),
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Фильтры",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
          SizedBox(width: 5),
          GestureDetector(
              onTap: () {
                mainContext.read<FiltersCubit>().deleteFilterData();
                mainContext.read<ProductsCubit>().refreshProducts();
              },
              child: Icon(Icons.close, color: Colors.white)),
        ],
      ),
    );
  }

  Center buildLoadingIndicator(ProductsLoading state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitCubeGrid(color: Colors.blue),
          SizedBox(height: 20),
          Text(
            state.message,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
          )
        ],
      ),
    );
  }

  buildEmptyState() {
    return Center(
      child: Text("Здесь будут ваши товары"),
    );
  }
}

class ProductsList extends StatelessWidget {
  final List<Product> products;
  final BuildContext buildContext;

  const ProductsList({Key key, @required this.products, this.buildContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 25,
        crossAxisSpacing: 25,
        crossAxisCount: 2,
        childAspectRatio: 0.80,
      ),
      padding: EdgeInsets.all(12.0),
      itemCount: products.length,
      itemBuilder: (context, index) => ProductCard(
        product: products[index],
        press: () => Navigator.push(
          context,
          SwipeablePageRoute(
              onlySwipeFromEdge: true,
              builder: (context) => CubitProvider.value(
                  value: buildContext.cubit<ProductsCubit>(),
                  child: CubitProvider.value(
                    value: buildContext.cubit<FiltersCubit>(),
                    child: EditProductScreen(product: products[index]),
                  ))),
        ),
      ),
    );
  }
}
