import 'package:flutter/material.dart';

Widget buildHeaderText({
  required String start,
  required String end,
  EdgeInsetsGeometry padding = const EdgeInsets.only(left: 20.0),
}) {
  return Padding(
    padding: padding,
    child: RichText(
      text: TextSpan(
        style: TextStyle(
          color: Colors.black,
          fontSize: 35.0,
          fontWeight: FontWeight.bold,
        ),
        children: <TextSpan>[
          TextSpan(
            text: start,
          ),
          TextSpan(
            text: end,
            style: TextStyle(
              color: Colors.blue,
            ),
          )
        ],
      ),
    ),
  );
}
