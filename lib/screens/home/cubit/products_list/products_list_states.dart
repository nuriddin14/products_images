import 'package:equatable/equatable.dart';
import 'package:products_image/models/product.dart';

abstract class ProductsState extends Equatable {}

class InitialState extends ProductsState {
  @override
  List<Object> get props => [];
}

class ProductsLoading extends ProductsState {
  ProductsLoading(this.message);

  @override
  String toString() => 'ProductsLoading';

  final String message;

  @override
  List<Object> get props => [message];
}

class ProductsLoaded extends ProductsState {
  @override
  String toString() => 'ProductsLoaded';

  ProductsLoaded(this.products);

  final List<Product> products;

  @override
  List<Object> get props => [products];
}

class FilteredProductsLoaded extends ProductsState {
  final List<Product> filteredProducts;

  FilteredProductsLoaded(this.filteredProducts);

  @override
  List<Object> get props => [filteredProducts];
}

class FilteredProductsEmpty extends ProductsState {
  @override
  String toString() => 'ProductsEmpty';

  @override
  List<Object> get props => [];
}

class ProductsEmpty extends ProductsState {
  @override
  String toString() => 'ProductsEmpty';

  @override
  List<Object> get props => [];
}

class ProductsError extends ProductsState {
  @override
  String toString() => 'ProductsError';

  @override
  List<Object> get props => [];
}
