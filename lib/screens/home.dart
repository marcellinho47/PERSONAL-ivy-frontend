import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sys_ivy_frontend/screens/operator.dart';
import 'package:sys_ivy_frontend/utils/color_pallete.dart';
import 'package:sys_ivy_frontend/widgets/nav_bar.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  void _checkOperatorLogin() {
    if (_auth.currentUser == null) {
      Navigator.pushReplacementNamed(context, "/");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPallete.primaryColor,
        title: const Text(
          "IVY",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "VogueProject",
          ),
        ),
        centerTitle: true,
      ),
      drawer: NavBar(),
      body: Operator(),
    );
  }
}
