import 'package:flutter/material.dart';

/* ---------------------------------------------------------------------------------------------------------------------------------------------------------------- */
/* TOAST */
/* ---------------------------------------------------------------------------------------------------------------------------------------------------------------- */

// TODO REFATORAR CODIGOS

void showWarningToast(BuildContext context, String warningMsg) {
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
            warningMsg,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Color.fromRGBO(0, 0, 0, 1), fontSize: 14.0),
          )
        ],
      ),
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.yellow,
      behavior: SnackBarBehavior.floating,
      width: 240.0,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25))),
    ),
  );
}

void showSuccessToast(BuildContext context, String successMsg) {
  dynamic scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle_outline_outlined,
            color: Colors.black,
          ),
          const Padding(
            padding: EdgeInsets.all(5),
          ),
          Text(
            successMsg,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Color.fromRGBO(0, 0, 0, 1), fontSize: 14.0),
          ),
        ],
      ),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      width: 120.0,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25))),
    ),
  );
}

void showErrorToast(BuildContext context, String errorMsg) {
  dynamic scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Colors.black,
          ),
          const Padding(
            padding: EdgeInsets.all(5),
          ),
          Text(
            errorMsg,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Color.fromRGBO(0, 0, 0, 1), fontSize: 14.0),
          ),
        ],
      ),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      width: 120.0,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25))),
    ),
  );
}
