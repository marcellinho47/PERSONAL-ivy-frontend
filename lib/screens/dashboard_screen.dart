import 'package:flutter/material.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  // ----------------------------------------------------------
  // VARIABLES
  // ----------------------------------------------------------

  // ----------------------------------------------------------
  // METHODS
  // ----------------------------------------------------------

  // ----------------------------------------------------------
  // BUILD
  // ----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("DASHBOARD"),
    );
  }
}
