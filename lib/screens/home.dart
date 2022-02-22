import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sys_ivy_frontend/config/routes.dart';
import 'package:sys_ivy_frontend/utils/color_pallete.dart';
import 'package:sys_ivy_frontend/widgets/nav_bar.dart';

class Home extends StatefulWidget {
  final Widget? widgetBody;
  final String screenName;

  const Home(this.widgetBody, this.screenName, {Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Widget? _widgetBody;
  late String _screenName;

  void _checkOperatorLogin() async {
    if (_auth.currentUser == null) {
      await _auth.signOut();
      Navigator.pushNamed(context, Routes.LOGIN_ROUTE);
    }
  }

  @override
  void initState() {
    super.initState();

    _widgetBody = widget.widgetBody;
    _screenName = widget.screenName;
    _checkOperatorLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPallete.primaryColor,
        title: Text(
          "IVY - $_screenName",
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      drawer: const NavBar(),
      body: _widgetBody,
    );
  }
}
