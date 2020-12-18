import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:products_image/screens/add_product/cubit/add_product_cubit.dart';
import 'package:products_image/screens/add_product/cubit/add_product_states.dart';

import 'product_form.dart';
import 'product_image.dart';

class Body extends StatelessWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Expanded(
      child: SingleChildScrollView(
        child: Stack(children: [
          CubitBuilder<AddProductCubit, AddProductState>(
            buildWhen: (previous, current) {
              if (current is SetMainColor || current is ImageDoesntExist)
                return true;
              else
                return false;
            },
            builder: (context, state) {
              if (state is SetMainColor) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  width: size.width,
                  height: size.height / 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      state.primaryColor.withOpacity(0.9),
                      state.primaryColor.withOpacity(0.8),
                      state.primaryColor.withOpacity(0.6),
                    ]),
                  ),
                );
              } else {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  width: size.width,
                  height: size.height / 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color(0xFF1B76AB),
                      Color(0xEE1B76AB),
                      Color(0xDD1B76AB),
                    ]),
                  ),
                );
              }
            },
          ),
          Column(
            children: [
              ProductImage(size: size.width * 0.5),
              SizedBox(height: 30),
              ProductForm()
            ],
          ),
        ]),
      ),
    );
  }
}
