// ignore_for_file: prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sys_ivy_frontend/config/firestore_config.dart';
import 'package:sys_ivy_frontend/config/routes_config.dart';
import 'package:sys_ivy_frontend/entity/category_entity.dart';
import 'package:sys_ivy_frontend/utils/toasts.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  // ----------------------------------------------------------
  // VARIABLES
  // ----------------------------------------------------------
  TextEditingController _id = TextEditingController();
  TextEditingController _description = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<CategoryEntity> _listCategories = [];

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

  void _search() async {
    cleanList();

    DocumentReference? doc;
    QuerySnapshot? snapshot;

    if (_id.text.isNotEmpty) {
      // FILTERING BY ID
      doc = _firestore.collection(DaoConfig.CATEGORY_COLLECTION).doc(_id.text);
    } else {
      // ALL
      CollectionReference catRef =
          _firestore.collection(DaoConfig.CATEGORY_COLLECTION);
      snapshot = await catRef.get();
    }

    // Return
    if (doc != null) {
      //BY ID
      DocumentSnapshot snapshot = await doc.get();

      if (snapshot.exists) {
        setState(() {
          _listCategories.add(CategoryEntity.fromDocument(snapshot));
        });
      }
    } else if (snapshot != null && snapshot.docs.isNotEmpty) {
      if (_description.text.isNotEmpty) {
        // BY TEXT

        for (DocumentSnapshot item in snapshot.docs) {
          CategoryEntity temp = CategoryEntity.fromDocument(item);

          if (temp.description!
              .toLowerCase()
              .trim()
              .contains(_description.text.trim().toLowerCase())) {
            setState(() {
              _listCategories.add(temp);
            });
          }
        }
      } else {
        // ALL
        for (DocumentSnapshot item in snapshot.docs) {
          setState(() {
            _listCategories.add(CategoryEntity.fromDocument(item));
          });
        }
      }
    }
  }

  void cleanList() {
    _listCategories = [];
  }

  void refreshComponent() {
    setState(() {
      _listCategories;
    });
  }

  void _addCategory() {
    Navigator.pushReplacementNamed(context, Routes.CATEGORIES_ADD_EDIT_ROUTE);
  }

  void _editCategory() {
    if (_countSelectCategories() != 1) {
      showWarningToast(context, "Selecione apenas 1 registro para alteração.");
      return;
    }

    Navigator.pushReplacementNamed(
      context,
      Routes.CATEGORIES_ADD_EDIT_ROUTE,
      arguments:
          _listCategories.where((element) => element.isSelect).first.idCategory,
    );
  }

  void _deleteCategory() {
    if (_countSelectCategories() != 1) {
      showWarningToast(context, "Selecione ao menos 1 registro para exclusão.");
      return;
    }

    // TODO create method that valids if there product associated to a category = disabled
    // else delete
  }

  int _countSelectCategories() {
    return _listCategories.where((element) => element.isSelect).length;
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
                padding: const EdgeInsets.all(20),
                child: Flex(
                  direction: Axis.horizontal,
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
                      flex: 6,
                      child: TextField(
                        controller: _description,
                        keyboardType: TextInputType.text,
                        enabled: true,
                        decoration: const InputDecoration(
                          hintText: "",
                          labelText: "Descrição",
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _search();
                          });
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(20)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            Text("Pesquisar"),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.search_rounded,
                              size: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Visibility(
              visible: _listCategories.isNotEmpty,
              child: Column(
                children: [
                  PaginatedDataTable(
                    rowsPerPage: 5,
                    showFirstLastButtons: true,
                    showCheckboxColumn: true,
                    checkboxHorizontalMargin: 20,
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text(
                          'Código',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Descrição',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Habilitado',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                    source: CategoryDataTableSource(
                        _listCategories, refreshComponent),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _addCategory();
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(20)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            Text("Adicionar"),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.add_circle_outline_rounded,
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
                          _editCategory();
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(20)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            Text("Editar"),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.mode_edit_outline_rounded,
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
                          _deleteCategory();
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(20)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            Text("Excluir"),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.delete_outline_rounded,
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
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------
// AUXILIAR CLASS
// ----------------------------------------------------------
class CategoryDataTableSource extends DataTableSource {
  List<CategoryEntity> _listCategories;
  void Function() refreshComponent;

  CategoryDataTableSource(this._listCategories, this.refreshComponent);

  @override
  DataRow? getRow(int index) {
    return DataRow.byIndex(
      onSelectChanged: (value) {
        selectIndex(index, value);
      },
      selected: isSelect(index),
      index: index,
      cells: <DataCell>[
        DataCell(
          SizedBox(
            width: 70,
            child: Text(_listCategories[index].idCategory.toString()),
          ),
        ),
        DataCell(
          SizedBox(
            width: 320,
            child: Text(_listCategories[index].description ?? ""),
          ),
        ),
        DataCell(_listCategories[index].enabled!
            ? const Icon(Icons.check_circle_outline_rounded)
            : const Text("")),
      ],
    );
  }

  void selectIndex(int index, bool? isSelect) {
    _listCategories.elementAt(index).isSelect = isSelect ?? false;
    refreshComponent();
  }

  bool isSelect(int index) {
    return _listCategories.elementAt(index).isSelect;
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _listCategories.length;

  @override
  int get selectedRowCount =>
      _listCategories.where((element) => element.isSelect).toList().length;
}
