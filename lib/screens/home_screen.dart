// ignore_for_file: prefer_final_fields

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sys_ivy_frontend/config/routes_config.dart';
import 'package:sys_ivy_frontend/utils/color_pallete.dart';
import 'package:sys_ivy_frontend/widgets/nav_bar.dart';

class HomeScreen extends StatefulWidget {
  final Widget? widgetBody;
  final String screenName;

  const HomeScreen(
    this.widgetBody,
    this.screenName, {
    Key? key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ----------------------------------------------------------
  // VARIABLES
  // ----------------------------------------------------------
  FirebaseAuth _auth = FirebaseAuth.instance;
  Widget? _widgetBody;
  late String _screenName;

  // ----------------------------------------------------------
  // METHODS
  // ----------------------------------------------------------
  void _checkOperatorLogin() async {
// TODO remove operator excluded

    if (_auth.currentUser == null) {
      await _auth.signOut();
      Navigator.pushNamed(context, Routes.LOGIN_ROUTE);
    }
  }

  @override
  void initState() {
    super.initState();

    _checkOperatorLogin();
    _widgetBody = widget.widgetBody;
    _screenName = widget.screenName;
  }

  // ----------------------------------------------------------
  // BUILD
  // ----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPallete.primaryColor,
        title: Text(
          "ANC - $_screenName",
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      drawer: const NavBar(),
      body: SingleChildScrollView(
        child: _widgetBody,
        padding: const EdgeInsets.fromLTRB(0, 50, 0, 50),
      ),
    );
  }
}
