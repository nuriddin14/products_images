import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as Img;
import 'package:image_cropper/image_cropper.dart';

import 'package:intl/intl.dart';
import 'package:cubit/cubit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:products_image/models/product.dart';
import 'package:products_image/utils/app_utils.dart';
import 'package:products_image/screens/add_product/cubit/add_product_states.dart';

import '../../../database.dart';

class AddProductCubit extends Cubit<AddProductState> {
  AddProductCubit() : super(ImageDoesntExist());

  String imageName;
  File image;

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
    _setMainColor(image);

    emit(ImageLoaded(image));
  }

  void _deleteImage() async {
    imageName = null;
    emit(ImageDoesntExist());
  }

  void _addProduct(Product product) async {
    try {
      emit(ProductAdding());

      if (image != null) {
        String imageName = await _saveImage(product);
        product.imageName = imageName;
      }

      await DBProvider.db.newProduct(product);

      print("Добавление завершено");

      emit(ProductAdded());
    } catch (e) {
      emit(ProductAddError());
    }
  }

  Future<String> _saveImage(Product product) async {
    String fileName = DateFormat('yyyyMMddkkmmss').format(DateTime.now());
    String imagesFolderPath = await AppUtils.getFolderPath('Images');
    String imgPath = '$imagesFolderPath/IMG_$fileName.jpg';

    Img.Image localImage = Img.decodeImage(await image.readAsBytes());
    localImage = Img.copyResizeCropSquare(localImage, 700);

    File(imgPath)
      ..create(recursive: true)
      ..writeAsBytesSync(Img.encodeJpg(localImage, quality: 70));

    return 'IMG_$fileName';
  }

  void _setMainColor(File image) async {
    ui.decodeImageFromList(image.readAsBytesSync(), (result) async {
      var palette =
          await PaletteGenerator.fromImage(result, maximumColorCount: 1);
      var primaryColor = palette.dominantColor.color;
      emit(SetMainColor(primaryColor));
    });
  }

  void getImage(ImageSource source) => _getImage(source);
  void addProduct(Product product) => _addProduct(product);
  void deleteImage() => _deleteImage();
}
