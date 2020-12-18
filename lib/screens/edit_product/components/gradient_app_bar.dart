import "package:flutter/material.dart";
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:products_image/screens/edit_product/cubit/edit_product_cubit.dart';
import 'package:products_image/screens/edit_product/cubit/edit_product_states.dart';

class Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GradientAppBar("Custom Gradient App Bar"),
        Container()
      ],
    );
  }
}

class GradientAppBar extends StatelessWidget {
  final String title;
  final double barHeight = 50.0;

  GradientAppBar(this.title);

  @override
  Widget build(BuildContext context) {
    final double statusbarHeight = MediaQuery.of(context).padding.top;
    return CubitBuilder<EditProductCubit, EditProductState>(
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
            padding: EdgeInsets.only(top: statusbarHeight),
            height: statusbarHeight + barHeight,
            child: Stack(children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              Center(
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      shadows: [Shadow(color: Colors.black38, blurRadius: 10)],
                      fontWeight: FontWeight.bold),
                ),
              ),
            ]),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  state.primaryColor.withOpacity(0.9),
                  state.primaryColor.withOpacity(0.8),
                  state.primaryColor.withOpacity(0.6),
                ],
              ),
            ),
          );
        } else {
          return AnimatedContainer(
            duration: Duration(milliseconds: 500),
            padding: EdgeInsets.only(top: statusbarHeight),
            height: statusbarHeight + barHeight,
            child: Stack(children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              Center(
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      shadows: [Shadow(color: Colors.black38, blurRadius: 10)],
                      fontWeight: FontWeight.bold),
                ),
              ),
            ]),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1B76AB),
                  Color(0xEE1B76AB),
                  Color(0xDD1B76AB),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
