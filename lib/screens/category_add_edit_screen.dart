// ignore_for_file: prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:sys_ivy_frontend/config/firestore_config.dart';
import 'package:sys_ivy_frontend/config/routes_config.dart';
import 'package:sys_ivy_frontend/entity/category_entity.dart';
import 'package:sys_ivy_frontend/utils/toasts.dart';

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

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Object? _args;

  // ----------------------------------------------------------
  // METHODS
  // ----------------------------------------------------------
  @override
  void initState() {
    super.initState();

    _args = widget.args;

    _cleanForm();

    _recoverCategory();
  }

  bool _isCreate() {
    return _id.text.isEmpty;
  }

  void _recoverCategory() async {
    if (_args != null && _args.toString().isNotEmpty) {
      DocumentSnapshot snapshot = await _firestore
          .collection(DaoConfig.CATEGORY_COLLECTION)
          .doc(_args.toString())
          .get();

      if (snapshot.exists) {
        CategoryEntity ce = CategoryEntity.fromDocument(snapshot);
        setState(() {
          _id.text = ce.idCategory!.toString();
          _description.text = ce.description!;
          _enabled = ce.enabled!;
        });
      }
    }
  }

  double _boxWidth(double _screenWidth) {
    double loginBoxWidth = _screenWidth;

    if (_screenWidth > 750) {
      loginBoxWidth = 650;
    }

    return loginBoxWidth;
  }

  void _cleanForm() {
    _id.text = "";
    _description.text = "";
    _enabled = true;
  }

  void _validForm() async {
    if (_description.text.isEmpty) {
      showWarningToast(context, "Descrição é um campo obrigatório!");
      return;
    }

    CollectionReference catRef =
        _firestore.collection(DaoConfig.CATEGORY_COLLECTION);

    QuerySnapshot? snapshot = await catRef.get();

    List<CategoryEntity> list = [];
    if (snapshot.docs.isNotEmpty) {
      for (DocumentSnapshot item in snapshot.docs) {
        CategoryEntity temp = CategoryEntity.fromDocument(item);
        list.add(temp);

        if (temp.description!
            .toLowerCase()
            .trim()
            .contains(_description.text.trim().toLowerCase())) {
          if (_id.text.isEmpty ||
              _id.text.compareTo(temp.idCategory.toString()) != 0) {
            showWarningToast(context,
                "Já existe uma categoria com essa descrição. ID: ${temp.idCategory}");
            return;
          }
        }
      }
    }

    _saveOrUpdate(list);
  }

  void _saveOrUpdate(List<CategoryEntity> list) async {
    if (_isCreate()) {
      CategoryEntity ce = CategoryEntity(
        description: _description.text.trim(),
        enabled: _enabled,
      );

      List _ids = list.map((e) => e.idCategory!).toList();
      _ids.sort((b, a) => a.compareTo(b));
      int newID = _ids.first + 1;

      await _firestore
          .collection(DaoConfig.CATEGORY_COLLECTION)
          .doc(newID.toString())
          .set(ce.toJson());
    } else {
      CategoryEntity ce = list
          .where((element) =>
              element.idCategory.toString().compareTo(_id.text) == 0)
          .first;
      ce.description = _description.text.trim();
      ce.enabled = _enabled;

      await _firestore
          .collection(DaoConfig.CATEGORY_COLLECTION)
          .doc(ce.idCategory.toString())
          .update(ce.toJson());
    }
    _cleanForm();
    showSuccessToast(context, "Salvo com sucesso!");
    Navigator.pushReplacementNamed(context, Routes.CATEGORIES_ROUTE);
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
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _cleanForm();
                    });
                  },
                  style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Text("Limpar"),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.cleaning_services_rounded,
                        size: 15,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _validForm();
                    });
                  },
                  style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Text("Salvar"),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.save_alt_rounded,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
