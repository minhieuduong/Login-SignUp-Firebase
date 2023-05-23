import 'package:flutter/material.dart';

Widget logoWidget(String imageName) {
  return Align(
    alignment: Alignment.center,
    child: Image.asset(
      imageName,
      fit: BoxFit.fitWidth,
      width: 200,
      height: 150,
      color: Colors.white,
    ),
  );
}
