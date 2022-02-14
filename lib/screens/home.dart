import 'package:flutter/material.dart';
import 'package:sys_ivy_frontend/utils/color_pallete.dart';
import 'package:sys_ivy_frontend/widgets/nav_bar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
      drawer: const NavBar(),
    );
  }
}
