import 'dart:io';

import 'package:cubit/cubit.dart';
import 'package:products_image/constants.dart';
import 'package:products_image/screens/home/cubit/products_list/products_list_states.dart';
import 'package:products_image/database.dart';
import 'package:products_image/models/product.dart';
import 'package:products_image/utils/app_utils.dart';
import 'package:products_image/utils/filter_data.dart';

List<Product> products;
List<Product> filteredProducts;

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(InitialState()) {
    products = [];
    filteredProducts = [];
    _getProducts();
  }

  void _productEdited(Product product) async {
    try {
      int oldProductIndex = products
          .indexOf(products.firstWhere((element) => element.id == product.id));

      products[oldProductIndex] = product;

      emit(ProductsLoaded(products));
    } catch (e) {}
  }

  void _refreshAllProducts() async {
    try {
      var db = DBProvider.db;

      var _products = await db.getAllProducts();

      products = await _getProductsImages(_products);

      emit(ProductsLoaded(products));
    } catch (e) {}
  }

  void _getProducts() async {
    try {
      emit(ProductsLoading("Загрузка товаров"));

      var db = DBProvider.db;
      products = await db.getAllProducts();

      if (products.length == 0) {
        emit(ProductsEmpty());
      } else {
        products = await _getProductsImages(products);

        emit(ProductsLoaded(products));
      }
    } catch (e) {
      emit(ProductsError());
    }
  }

  Future<List<Product>> _getProductsImages(List<Product> products) async {
    int i = 0;
    String folderPath = await AppUtils.getFolderPath('Images');

    await Future.forEach(products, (Product product) async {
      if (product.imageName != '' && product.imageName != null) {
        final File image = File('$folderPath/${product.imageName}.jpg');

        if (image.existsSync()) {
          product.image = image;
          products[i] = product;
        }
      }

      i++;
    });

    return products;
  }

  _filterProducts(
    int providerId,
    int saleTypeId,
    int unitId,
    int categoryId,
    ImageFilterEnum imageFilterEnum,
  ) async {
    emit(ProductsLoading("Фильтрация товаров"));

    if (providerId + saleTypeId + unitId + categoryId == 0 &&
        imageFilterEnum == ImageFilterEnum.allProducts) {
      emit(ProductsLoaded(products));
      filteredProducts = [];
      return;
    }

    if (imageFilterEnum == ImageFilterEnum.allProducts) {
      filteredProducts = products;
    } else if (imageFilterEnum == ImageFilterEnum.withImage) {
      filteredProducts =
          products.where((element) => element.image != null).toList();
    } else if (imageFilterEnum == ImageFilterEnum.withoutImage) {
      filteredProducts =
          products.where((element) => element.image == null).toList();
    }

    if (providerId > 0 && filteredProducts.isNotEmpty) {
      filteredProducts = filteredProducts
          .where((element) => element.providerId == providerId)
          .toList();
    }

    if (saleTypeId > 0) {
      filteredProducts = filteredProducts
          .where((element) => element.saleTypeId == saleTypeId)
          .toList();
    }

    if (unitId > 0) {
      filteredProducts = filteredProducts
          .where((element) => element.unitId == unitId)
          .toList();
    }

    if (categoryId > 0) {
      filteredProducts = filteredProducts
          .where((element) => element.categoryId == categoryId)
          .toList();
    }

    if (filteredProducts.length > 0) {
      emit(FilteredProductsLoaded(filteredProducts));
    } else {
      emit(FilteredProductsEmpty());
    }
  }

  void filterProductsByName(String filter) => _filterProductsByName(filter);
  void getProducts() => _getProducts();
  void refreshProducts() => _refreshAllProducts();
  void productEdited(Product product) => _productEdited(product);
  void filterProducts(FilterData filterData) => _filterProducts(
        filterData.providerId,
        filterData.saleTypeId,
        filterData.unitId,
        filterData.categoryId,
        filterData.imageFilterEnum,
      );

  _filterProductsByName(String filter) {
    if (filter.trim().isNotEmpty) {
      var _products = [];
      if (filteredProducts != null && filteredProducts.length > 0) {
        _products = filteredProducts
            .where((product) => product.productName
                .toLowerCase()
                .contains(filter.toLowerCase()))
            .toList();
      } else if (products != null && products.length > 0) {
        _products = products
            .where((product) => product.productName
                .toLowerCase()
                .contains(filter.toLowerCase()))
            .toList();
      }
      emit(ProductsLoaded(_products));
    } else {
      if (filteredProducts != null && filteredProducts.length > 0) {
        emit(ProductsLoaded(filteredProducts));
      } else if (products != null && products.length > 0) {
        emit(ProductsLoaded(products));
      }
    }
  }
}
