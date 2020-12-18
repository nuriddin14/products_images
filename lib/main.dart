import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:products_image/screens/home/cubit/filter/filter_cubit.dart';

import 'screens/home/cubit/products_list/products_list_cubit.dart';
import 'screens/home/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      // theme: ThemeData.dark().copyWith(
      //     appBarTheme: AppBarTheme(color: Color(0xFF1B76AB)),
      //     buttonColor: Color(0xFF1B76AB),
      //     primaryColor: Color(0xFF1B76AB),
      //     accentColor: Color(0xFF1B76AB)),
      theme: ThemeData.light().copyWith(primaryColor: Color(0xFF1B76AB)),
      home: MultiCubitProvider(
        providers: [
          CubitProvider<ProductsCubit>(
            create: (BuildContext context) => ProductsCubit(),
          ),
          CubitProvider<FiltersCubit>(
            create: (BuildContext context) => FiltersCubit(),
          ),
        ],
        child: Home(),
      ),
    );
  }
}
