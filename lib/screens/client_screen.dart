import 'package:flutter/material.dart';

class ClientScreen extends StatefulWidget {
  const ClientScreen({Key? key}) : super(key: key);

  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  // ----------------------------------------------------------
  // VARIABLES
  // ----------------------------------------------------------
  TextEditingController _id = TextEditingController();
  TextEditingController _name = TextEditingController();

  // ----------------------------------------------------------
  // METHODS
  // ----------------------------------------------------------
  @override
  void initState() {
    super.initState();
  }

  double _boxWidth(double _screenWidth) {
    double loginBoxWidth = _screenWidth;

    if (_screenWidth > 750) {
      loginBoxWidth = 700;
    }

    return loginBoxWidth;
  }

  // ----------------------------------------------------------
  // BUILD
  // ----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: SizedBox(
        width: _boxWidth(_screenWidth),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _id,
                        keyboardType: TextInputType.number,
                        enabled: true,
                        decoration: const InputDecoration(
                          hintText: "",
                          labelText: "Código",
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 8,
                      child: TextField(
                        controller: _name,
                        keyboardType: TextInputType.text,
                        enabled: true,
                        decoration: const InputDecoration(
                          hintText: "",
                          labelText: "Descrição",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
