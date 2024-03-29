// ignore_for_file: prefer_final_fields

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sys_ivy_frontend/config/routes_config.dart';
import 'package:sys_ivy_frontend/utils/color_pallete.dart';
import 'package:sys_ivy_frontend/utils/functions.dart';
import 'package:sys_ivy_frontend/utils/toasts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ----------------------------------------------------------
  // VARIABLES
  // ----------------------------------------------------------
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  StringBuffer _toastMsg = StringBuffer("");

  FirebaseAuth _auth = FirebaseAuth.instance;

  // ----------------------------------------------------------
  // METHODS
  // ----------------------------------------------------------
  @override
  void initState() {
    super.initState();

    _resetFields();
  }

  void _resetFields() {
    _toastMsg = StringBuffer("");
    _emailController.text = "marcello_doalves@hotmail.com";
    _passwordController.text = "123456123";
  }

  Future<void> _login(BuildContext context) async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (isValidForm(email, password)) {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((auth) {
        Navigator.pushReplacementNamed(context, Routes.HOME_ROUTE);
      }).onError((error, stackTrace) {
        showToast(context, ERROR_TYPE_TOAST, "Usuário e/ou Senha inválidos",
            null, null);
      });
    } else {
      setState(() {
        showToast(
            context, WARNING_TYPE_TOAST, _toastMsg.toString(), null, null);
        _resetFields();
      });
    }
  }

  bool isValidForm(String? email, String? password) {
    bool isValidForm = true;
    _toastMsg = StringBuffer("");

    // EMAIL
    if (email == null || email.isEmpty) {
      _toastMsg.write("E-mail não informado.\n");
      isValidForm = false;
    } else if (!UtilFunctions.isValidEmail(email)) {
      _toastMsg.write("E-mail inválido.\n");
      isValidForm = false;
    }

    // PASSWORD
    if (password == null || password.isEmpty) {
      _toastMsg.write("\nSenha não informada.");
      isValidForm = false;
    } else if (password.length < 8) {
      _toastMsg.write("\nSenha inválida.");
      isValidForm = false;
    }

    return isValidForm;
  }

  double _loginBoxWidth(double screenWitdth) {
    double loginBoxWidth = double.infinity;

    if (screenWitdth > 750) {
      loginBoxWidth = 650;
    }

    return loginBoxWidth;
  }

  // ----------------------------------------------------------
  // BUILD
  // ----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    double _screenHeight = MediaQuery.of(context).size.height;
    double _screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        color: ColorPallete.backgroudSystem,
        height: _screenHeight,
        width: _screenWidth,
        child: Stack(
          children: [
            Positioned(
                child: Container(
              width: _screenWidth,
              height: _screenHeight * 0.4,
              color: Colors.black,
            )),
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Card(
                    elevation: 4,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: SizedBox(
                      height: 350,
                      width: _loginBoxWidth(_screenWidth),
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "SYS - ANC",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'VogueProject',
                                fontSize: 32,
                              ),
                            ),
                            TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                hintText: "example@mail.com",
                                labelText: "E-mail",
                                suffixIcon: Icon(Icons.email_outlined),
                              ),
                            ),
                            TextField(
                              controller: _passwordController,
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              decoration: const InputDecoration(
                                hintText: "",
                                labelText: "Senha",
                                suffixIcon: Icon(Icons.lock_outline),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  _login(context);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text(
                                    "Entrar",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white60,
                                  backgroundColor: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
