import 'package:flutter/material.dart';
import 'package:sys_ivy_frontend/utils/color_pallete.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  double loginBoxWidth(double screenWitdth) {
    double loginBoxWidth = double.infinity;

    if (screenWitdth > 750) {
      loginBoxWidth = 650;
    }

    return loginBoxWidth;
  }

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double _screenHeight = MediaQuery.of(context).size.height;
    double _screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Container(
      // color: ColorPallete.backgroudSystem,
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
                  child: Container(
                    height: 350,
                    width: loginBoxWidth(_screenWidth),
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "SYS - IVY",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'VogueProject', fontSize: 32),
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
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
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
                                primary: Colors.black87,
                                onPrimary: Colors.white60,
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
    ));
  }
}
