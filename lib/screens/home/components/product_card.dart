import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:products_image/models/product.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final Function press;

  const ProductCard({Key key, this.product, this.press}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      semanticContainer: true,
      elevation: 5,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 12,
            child: GestureDetector(
                onTap: press,
                child: product.image == null
                    ? buildWithoutImage()
                    : buildWithImage(product.image)),
          ),
          Flexible(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  product.productName,
                  maxLines: 2,
                  softWrap: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildLoadingIndicator() {
    return SpinKitPulse(color: Colors.blue[500]);
  }

  buildWithoutImage() {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Color(0xEE1B76AB),
          Color(0xDD1B76AB),
          Color(0xBB1B76AB),
        ]),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      child: Center(
        child: Icon(
          Icons.photo_rounded,
          size: 40,
          color: Colors.white,
        ),
      ),
    );
  }

  buildWithImage(File image) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: FileImage(image),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
