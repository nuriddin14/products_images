import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:products_image/screens/edit_product/cubit/edit_product_cubit.dart';
import 'package:products_image/screens/edit_product/cubit/edit_product_states.dart';
import 'package:photo_view/photo_view.dart';

class OpenImage extends StatelessWidget {
  File image;

  OpenImage({Key key, @required this.image}) : super(key: key);
  @override
  Widget build(BuildContext mainContext) {
    Size size = MediaQuery.of(mainContext).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Theme(
            data: Theme.of(mainContext).copyWith(cardColor: Color(0xFF272727)),
            child: PopupMenuButton(
              icon: Icon(Icons.more_vert, color: Colors.white),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'Camera',
                  child: Row(
                    children: [
                      Icon(
                        Icons.photo_camera_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Сделать снимок',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'Gallery',
                  child: Row(
                    children: [
                      Icon(
                        Icons.photo_size_select_actual_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Загрузить из галереи',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'Delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_forever_outlined,
                          color: Colors.redAccent, size: 23),
                      SizedBox(width: 10),
                      Text('Удалить фото',
                          style: TextStyle(color: Colors.redAccent)),
                    ],
                  ),
                ),
              ],
              onSelected: (result) {
                if (result == 'Camera') {
                  mainContext
                      .read<EditProductCubit>()
                      .getImage(ImageSource.camera);
                } else if (result == 'Gallery') {
                  mainContext
                      .read<EditProductCubit>()
                      .getImage(ImageSource.gallery);
                } else if (result == 'Delete') {
                  mainContext.read<EditProductCubit>().deleteImage();
                }
              },
            ),
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.center,
        child: Container(
          width: size.width,
          height: size.width,
          color: Colors.black,
          child: CubitConsumer<EditProductCubit, EditProductState>(
            listener: (context, state) {
              if (state is ImageDoesntExist) {
                return Navigator.of(mainContext).pop();
              }
            },
            buildWhen: (previosState, state) {
              if (state is ProductEditing ||
                  state is ProductEdited ||
                  state is ProductEditError ||
                  state is ImageDoesntExist ||
                  state is SetMainColor) {
                return false;
              } else {
                return true;
              }
            },
            // ignore: missing_return
            builder: (mainContext, state) {
              if (state is ImageLoading) {
                return Center(child: SpinKitFadingFour(color: Colors.white));
              } else if (state is ImageLoaded) {
                image = state.image;
                return buildImage(state.image, size);
              } else if (state is SetMainColor) {
                return buildImage(image, size);
              }
            },
          ),
        ),
      ),
    );
  }

  buildImage(File image, Size size) {
    return Container(
      width: size.width,
      height: size.width,
      child: PhotoView(
        imageProvider: FileImage(image),
        backgroundDecoration: BoxDecoration(color: Colors.black),
        gaplessPlayback: false,
        heroAttributes: const PhotoViewHeroAttributes(
          tag: "Product Image",
          transitionOnUserGestures: true,
        ),
        minScale: PhotoViewComputedScale.contained * 0.8,
        maxScale: PhotoViewComputedScale.covered * 1.8,
        initialScale: PhotoViewComputedScale.contained,
        basePosition: Alignment.center,
      ),
    );
  }
}
