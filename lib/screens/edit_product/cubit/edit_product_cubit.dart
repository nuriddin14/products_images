import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as Img;
import 'package:image_cropper/image_cropper.dart';

import 'package:intl/intl.dart';
import 'package:cubit/cubit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:products_image/models/product.dart';
import 'package:products_image/utils/app_utils.dart';
import 'package:products_image/screens/edit_product/cubit/edit_product_states.dart';

import '../../../database.dart';

class EditProductCubit extends Cubit<EditProductState> {
  EditProductCubit(this.image) : super(InitialState()) {
    _setImage();
  }

  bool isImageEdited = false;
  File image;

  void _setImage() async {
    if (image != null) {
      try {
        emit(ImageLoaded(image));
        print("${DateTime.now().second}");
        Future.delayed(Duration(milliseconds: 5), () => _setMainColor(image));
      } catch (e) {
        emit(ImageError());
      }
    } else {
      emit(ImageDoesntExist());
    }
  }

  void _getImage(ImageSource source) async {
    Future.delayed(Duration(seconds: 1), () => emit(ImageLoading()));

    final pickedFile = await ImagePicker().getImage(source: source);

    if (pickedFile == null) {
      if (image == null) {
        emit(ImageDoesntExist());
      } else {
        emit(ImageLoaded(image));
      }

      return;
    }

    File croppedImage = await ImageCropper.cropImage(
      sourcePath: pickedFile.path,
      aspectRatioPresets: [CropAspectRatioPreset.square],
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Обрезать фото',
        toolbarColor: Colors.black,
        toolbarWidgetColor: Colors.white,
        hideBottomControls: true,
        initAspectRatio: CropAspectRatioPreset.square,
      ),
      iosUiSettings: IOSUiSettings(
        title: 'Обрезать фото',
      ),
    );

    if (croppedImage == null) {
      if (image == null) {
        emit(ImageDoesntExist());
      } else {
        emit(ImageLoaded(image));
      }

      return;
    }

    image = File(croppedImage.path);
    isImageEdited = true;

    emit(ImageLoaded(image));

    _setMainColor(image);
    print("первый");
  }

  void _deleteImage() async {
    isImageEdited = true;
    image = null;
    _setImage();
  }

  void _editProduct(Product product) async {
    try {
      emit(ProductEditing());

      product.image = image;

      if (isImageEdited) {
        product = await _saveImage(product);
      }

      await DBProvider.db.editProduct(product);

      emit(ProductEdited());
    } catch (e) {
      emit(ProductEditError());
    }
  }

  Future<Product> _saveImage(Product product) async {
    if (image != null) {
      String fileName = DateFormat('yyyyMMddkkmmss').format(DateTime.now());
      String imagesFolderPath = await AppUtils.getFolderPath('Images');
      String imgPath = '$imagesFolderPath/IMG_$fileName.jpg';

      Img.Image localImage = Img.decodeImage(await image.readAsBytes());
      localImage = Img.copyResizeCropSquare(localImage, 700);

      image = File(imgPath)
        ..create(recursive: true)
        ..writeAsBytesSync(Img.encodeJpg(localImage));

      product.image = image;
      product.imageName = 'IMG_$fileName';

      return product;
    }
    if (product.imageName != '' && product.imageName != null) {
      String imagesFolderPath = await AppUtils.getFolderPath("Images");
      String imgPath = '$imagesFolderPath/${product.imageName}.jpg';

      File(imgPath)..delete();

      product.image = null;
      product.imageName = '';

      return product;
    }
    return product;
  }

  void _setMainColor(File image) async {
    ui.decodeImageFromList(image.readAsBytesSync(), (result) async {
      var palette =
          await PaletteGenerator.fromImage(result, maximumColorCount: 5);
      var primaryColor = palette.dominantColor.color;
      emit(SetMainColor(primaryColor));
    });
  }

  void getImage(ImageSource source) => _getImage(source);
  void editProduct(Product product) => _editProduct(product);
  void deleteImage() => _deleteImage();
}
