import 'package:flutter/material.dart';

const boxDecoration1 = BoxDecoration(
  gradient: LinearGradient(
    colors: [
      Color.fromARGB(255, 1, 117, 250),
      Color.fromARGB(255, 145, 201, 251)
    ],
    begin: Alignment.topLeft,
    end: Alignment.centerRight,
  ),
);

const boxDecoration2 = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.only(
      topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0)),
);
