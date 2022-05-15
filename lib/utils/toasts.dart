// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

/* ---------------------------------------------------------------------------------------------------------------------------------------------------------------- */
/* TOAST */
/* ---------------------------------------------------------------------------------------------------------------------------------------------------------------- */

const String SUCESS_TYPE_TOAST = "SUCESS";
const String WARNING_TYPE_TOAST = "WARNING";
const String ERROR_TYPE_TOAST = "ERROR";
const double widthDefault = 300;
const int timeDefault = 3;

void showToast(BuildContext context, String typeToast, String msg,
    int? timeDuration, double? width) {
  Color backgroundColor = Colors.transparent;
  switch (typeToast) {
    case SUCESS_TYPE_TOAST:
      backgroundColor = Colors.green;
      break;
    case WARNING_TYPE_TOAST:
      backgroundColor = Colors.yellow;
      break;
    case ERROR_TYPE_TOAST:
      backgroundColor = Colors.red;
      break;
    default:
  }

  _mountToast(context, msg, backgroundColor, timeDuration, width);
}

void _mountToast(BuildContext context, String msg, Color backgroundColor,
    int? timeDuration, double? width) {
  dynamic scaffold = ScaffoldMessenger.of(context);

  scaffold.showSnackBar(
    SnackBar(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.assignment_late_outlined,
            color: Colors.black,
          ),
          const Padding(
            padding: EdgeInsets.all(5),
          ),
          Text(
            msg,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color.fromRGBO(0, 0, 0, 1),
              fontSize: 14.0,
            ),
          )
        ],
      ),
      elevation: 5,
      duration: Duration(seconds: timeDuration ?? timeDefault),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      width: width ?? widthDefault,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
    ),
  );
}
