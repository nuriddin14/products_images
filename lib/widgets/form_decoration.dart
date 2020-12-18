import 'package:flutter/material.dart';

formInputDecoration(String labelText) {
  return InputDecoration(
    labelText: labelText,
    filled: false,
    fillColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(horizontal: 10),
    focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent, width: 1.0),
        borderRadius: BorderRadius.circular(10.0)),
    errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent, width: 1.0),
        borderRadius: BorderRadius.circular(10.0)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 1.0),
        borderRadius: BorderRadius.circular(10.0)),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 1.0),
        borderRadius: BorderRadius.circular(10.0)),
  );
}
