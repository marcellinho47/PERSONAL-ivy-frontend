// ignore_for_file: prefer_final_fields

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sys_ivy_frontend/config/routes_config.dart';
import 'package:sys_ivy_frontend/repos/operator_repo.dart';
import 'package:sys_ivy_frontend/utils/color_pallete.dart';
import 'package:sys_ivy_frontend/utils/toasts.dart';
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

  OperatorRepo _operatorRepo = OperatorRepo();

  // ----------------------------------------------------------
  // METHODS
  // ----------------------------------------------------------
  void _checkOperatorLogin() async {
    // AUTH
    if (_auth.currentUser == null) {
      // Logout
      await _auth.signOut();
      Navigator.pushReplacementNamed(context, Routes.LOGIN_ROUTE);
    }

    // FIRESTORE
    _operatorRepo.findById(_auth.currentUser!.uid).then((operator) async {
      // Check is operator is not deleted
      if (operator != null && operator.exclusionDate != null) {
        // Feedback
        showToast(
          context,
          'Operador sem Acesso!',
          ERROR_TYPE_TOAST,
          null,
          null,
        );

        // Logout
        await _auth.signOut();
        Navigator.pushReplacementNamed(context, Routes.LOGIN_ROUTE);
      }
    });
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
