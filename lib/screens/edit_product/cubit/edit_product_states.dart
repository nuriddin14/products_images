import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:products_image/models/product.dart';

abstract class EditProductState extends Equatable {}

class InitialState extends EditProductState {
  @override
  List<Object> get props => [];
}

class ImageLoading extends EditProductState {
  @override
  List<Object> get props => [];
}

class ImageLoaded extends EditProductState {
  final File image;
  ImageLoaded(this.image);

  @override
  List<Object> get props => [image];
}

class ImageNotFind extends EditProductState {
  @override
  List<Object> get props => [];
}

class ImageDoesntExist extends EditProductState {
  @override
  List<Object> get props => [];
}

class ImageError extends EditProductState {
  @override
  List<Object> get props => [];
}

class ProductEditing extends EditProductState {
  @override
  List<Object> get props => [];
}

class ProductEdited extends EditProductState {
  @override
  List<Object> get props => [];
}

class ProductEditError extends EditProductState {
  @override
  List<Object> get props => [];
}

class SetMainColor extends EditProductState {
  final Color primaryColor;

  SetMainColor(this.primaryColor);

  @override
  List<Object> get props => [primaryColor];
}
