import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AddProductState extends Equatable {}

class InitialState extends AddProductState {
  @override
  List<Object> get props => [];
}

class ImageLoading extends AddProductState {
  @override
  List<Object> get props => [];
}

class ImageLoaded extends AddProductState {
  final File image;

  ImageLoaded(this.image);
  @override
  List<Object> get props => [image];
}

class ImageNotFind extends AddProductState {
  @override
  List<Object> get props => [];
}

class ImageDoesntExist extends AddProductState {
  @override
  List<Object> get props => [];
}

class ImageError extends AddProductState {
  @override
  List<Object> get props => [];
}

class ProductAdding extends AddProductState {
  @override
  List<Object> get props => [];
}

class ProductAdded extends AddProductState {
  @override
  List<Object> get props => [];
}

class ProductAddError extends AddProductState {
  @override
  List<Object> get props => [];
}

class SetMainColor extends AddProductState {
  final Color primaryColor;

  SetMainColor(this.primaryColor);

  @override
  List<Object> get props => [primaryColor];
}
