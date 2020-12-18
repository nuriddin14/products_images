import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:products_image/screens/edit_product/components/open_image.dart';
import 'package:products_image/screens/edit_product/cubit/edit_product_cubit.dart';
import 'package:products_image/screens/edit_product/cubit/edit_product_states.dart';

import '../../../constants.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({
    Key key,
    @required this.size,
    @required this.id,
  }) : super(key: key);

  final double size;
  final int id;

  @override
  Widget build(BuildContext buildContext) {
    return SafeArea(
      child: Align(
        alignment: Alignment.center,
        child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 20.0,
              )
            ],
          ),
          child: CubitBuilder<EditProductCubit, EditProductState>(
            buildWhen: (previosState, state) {
              if (state is ProductEditing ||
                  state is ProductEdited ||
                  state is ProductEditError ||
                  state is SetMainColor) {
                return false;
              } else {
                return true;
              }
            },
            builder: (context, state) {
              if (state is ImageLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is ImageLoaded) {
                return buildImage(state, buildContext);
              } else if (state is ImageDoesntExist) {
                return buildWithoutImage(buildContext);
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  buildWithoutImage(BuildContext buildContext) {
    return GestureDetector(
      onTap: () => buildShowDialog(buildContext),
      child: Container(
        width: size,
        height: size,
        color: Colors.transparent,
        child: Icon(Icons.add_photo_alternate, size: 40, color: Colors.black54),
      ),
    );
  }

  buildImage(ImageLoaded state, BuildContext buildContext) {
    return GestureDetector(
      onTap: () => Navigator.push(
        buildContext,
        MaterialPageRoute(
            builder: (context) => CubitProvider.value(
                value: buildContext.read<EditProductCubit>(),
                child: OpenImage(image: state.image))),
      ),
      child: Container(
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Hero(
              tag: 'Product Image',
              child: Image(
                fit: BoxFit.cover,
                width: size,
                height: size,
                image: FileImage(state.image),
              ),
            )),
      ),
    );
  }

  Future buildShowDialog(BuildContext parentContext) {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Загрузить фото",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 19),
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: FlatButton.icon(
                      icon: Icon(
                        Icons.photo_size_select_actual,
                        color: kTextColor,
                      ),
                      label:
                          Text("Галерея", style: TextStyle(color: kTextColor)),
                      onPressed: () async {
                        parentContext
                            .read<EditProductCubit>()
                            .getImage(ImageSource.gallery);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Expanded(
                    child: FlatButton.icon(
                      icon: Icon(
                        Icons.photo_camera,
                        color: kTextColor,
                      ),
                      label:
                          Text("Камера", style: TextStyle(color: kTextColor)),
                      onPressed: () async {
                        parentContext
                            .read<EditProductCubit>()
                            .getImage(ImageSource.camera);
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
