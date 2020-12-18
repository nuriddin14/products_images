import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:products_image/screens/add_product/components/gradient_app_bar.dart';
import 'package:products_image/screens/add_product/cubit/add_product_cubit.dart';

import 'components/body.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CubitProvider<AddProductCubit>(
        create: (context) => AddProductCubit(),
        child: Column(
          children: [
            GradientAppBar("Добавление товара"),
            Body(),
          ],
        ),
      ),
    );
  }
}
