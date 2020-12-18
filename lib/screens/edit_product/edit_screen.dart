import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:products_image/models/product.dart';
import 'package:products_image/screens/edit_product/cubit/edit_product_cubit.dart';

import 'components/body.dart';
import 'components/gradient_app_bar.dart';

class EditProductScreen extends StatelessWidget {
  final Product product;

  const EditProductScreen({Key key, @required this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CubitProvider<EditProductCubit>(
        create: (context) => EditProductCubit(product.image),
        child: Column(
          children: [
            GradientAppBar("Изменение товар"),
            Body(product: product),
          ],
        ),
      ),
    );
  }
}
