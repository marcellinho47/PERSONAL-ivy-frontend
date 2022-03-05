import 'package:flutter/material.dart';

// TODO PUT TO WORK

void showBanner(BuildContext context, String msg, Color backgroundColor) {
  dynamic scaffold = ScaffoldMessenger.of(context);
  scaffold.showMaterialBanner(
    MaterialBanner(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.assignment_late_outlined,
            color: Colors.white,
          ),
          const Padding(
            padding: EdgeInsets.all(5),
          ),
          Text(
            msg,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color.fromRGBO(255, 225, 255, 1),
              fontSize: 14.0,
            ),
          )
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
            padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Icon(
                Icons.check_circle_outline_rounded,
                size: 15,
              ),
              SizedBox(
                width: 5,
              ),
              Text("Sim"),
            ],
          ),
        ),
      ],
      backgroundColor: backgroundColor,
      leadingPadding: const EdgeInsets.only(top: 10),
    ),
  );
}
