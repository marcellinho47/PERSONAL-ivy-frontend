// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class CategoryAddEditScreen extends StatefulWidget {
  final Object? args;
  const CategoryAddEditScreen(
    this.args, {
    Key? key,
  }) : super(key: key);

  @override
  State<CategoryAddEditScreen> createState() => _CategoryAddEditScreenState();
}

class _CategoryAddEditScreenState extends State<CategoryAddEditScreen> {
  // ----------------------------------------------------------
  // VARIABLES
  // ----------------------------------------------------------
  TextEditingController _id = TextEditingController();
  TextEditingController _description = TextEditingController();
  bool _enabled = false;

  Object? _args;

  // ----------------------------------------------------------
  // METHODS
  // ----------------------------------------------------------
  @override
  void initState() {
    super.initState();

    _args = widget.args;
  }

  bool _isCreate() {
    return _args == null ? true : false;
  }

  double _boxWidth(double _screenWidth) {
    double loginBoxWidth = _screenWidth;

    if (_screenWidth > 750) {
      loginBoxWidth = 650;
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
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _id,
                  keyboardType: TextInputType.text,
                  enabled: false,
                  decoration: const InputDecoration(
                    hintText: "",
                    labelText: "ID Categoria",
                    suffixIcon: Icon(Icons.star_border_rounded),
                  ),
                ),
                TextField(
                  controller: _description,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: "",
                    labelText: "Descrição",
                    suffixIcon: Icon(Icons.text_fields_rounded),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Text("Habilitado "),
                    const SizedBox(
                      width: 10,
                    ),
                    FlutterSwitch(
                      toggleSize: 20.0,
                      width: 50,
                      height: 25,
                      value: _enabled,
                      onToggle: (value) {
                        setState(() {
                          _enabled = value;
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
