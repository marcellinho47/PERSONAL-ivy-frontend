import 'package:flutter/material.dart';

class OperatorAddEdit extends StatefulWidget {
  const OperatorAddEdit({Key? key}) : super(key: key);

  @override
  _OperatorAddEditState createState() => _OperatorAddEditState();
}

class _OperatorAddEditState extends State<OperatorAddEdit> {
  TextEditingController _uid = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _isAdmin = TextEditingController();

  double _boxWidth(double _screenWidth) {
    double loginBoxWidth = _screenWidth;

    if (_screenWidth > 750) {
      loginBoxWidth = 700;
    }

    return loginBoxWidth;
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        width: _boxWidth(_screenWidth),
        child: Column(
          children: [
            TextField(
              controller: _uid,
              keyboardType: TextInputType.text,
              enabled: false,
              decoration: const InputDecoration(
                hintText: "",
                labelText: "ID Operador",
                suffixIcon: Icon(Icons.numbers_rounded),
              ),
            ),
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              enabled: true,
              decoration: const InputDecoration(
                hintText: "example@com.br",
                labelText: "E-mail",
                suffixIcon: Icon(Icons.mail_outline_rounded),
              ),
            ),
            TextField(
              controller: _password,
              keyboardType: TextInputType.text,
              enabled: true,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "*******",
                labelText: "Senha",
                suffixIcon: Icon(Icons.numbers_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
