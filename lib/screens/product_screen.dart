// ignore_for_file: prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sys_ivy_frontend/config/firestore_config.dart';
import 'package:sys_ivy_frontend/entity/product_entity.dart';
import 'package:sys_ivy_frontend/utils/toasts.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  // ----------------------------------------------------------
  // VARIABLES
  // ----------------------------------------------------------
  TextEditingController _id = TextEditingController();
  TextEditingController _description = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<ProductEntity> _listProduct = [];

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

  void _cleanList() {
    _listProduct = [];
  }

  void _search() async {
    _cleanList();

    DocumentReference? doc;
    QuerySnapshot? snapshot;

    if (_id.text.isNotEmpty) {
      // FILTERING BY ID
      doc = _firestore.collection(DaoConfig.PRODUCT_COLLECTION).doc(_id.text);
    } else {
      // ALL
      CollectionReference catRef =
          _firestore.collection(DaoConfig.PRODUCT_COLLECTION);
      snapshot = await catRef.get();
    }

    // Return
    if (doc != null) {
      //BY ID
      DocumentSnapshot snapshot = await doc.get();

      if (snapshot.exists) {
        setState(() {
          _listProduct.add(ProductEntity.fromDocument(snapshot));
        });
      }
    } else if (snapshot != null && snapshot.docs.isNotEmpty) {
      if (_description.text.isNotEmpty) {
        // BY TEXT

        for (DocumentSnapshot item in snapshot.docs) {
          ProductEntity temp = ProductEntity.fromDocument(item);

          if (temp.description!
                  .toLowerCase()
                  .trim()
                  .contains(_description.text.trim().toLowerCase()) ||
              temp.name!
                  .toLowerCase()
                  .trim()
                  .contains(_description.text.trim().toLowerCase())) {
            setState(() {
              _listProduct.add(temp);
            });
          }
        }
      } else {
        // ALL
        for (DocumentSnapshot item in snapshot.docs) {
          setState(() {
            _listProduct.add(ProductEntity.fromDocument(item));
          });
        }
      }
    }

    if (_listProduct.isEmpty) {
      showSuccessToast(context,
          "Não foram encontrados registros para os parâmetros informados.");
    }
  }

  void refreshComponent() {
    setState(() {
      _listProduct;
    });
  }

  void _addProduct() {}

  void _editProduct() {}

  void _deleteProduct() {}

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
              visible: _listProduct.isNotEmpty,
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
                    source: ProductDataTableSource(
                      _listProduct,
                      refreshComponent,
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
                          _addProduct();
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
                          _editProduct();
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
                          _deleteProduct();
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
class ProductDataTableSource extends DataTableSource {
  List<ProductEntity> _listProduct;
  void Function() refreshComponent;

  ProductDataTableSource(
    this._listProduct,
    this.refreshComponent,
  );

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
            width: 80,
            child: Text(_listProduct[index].idProduct.toString()),
          ),
        ),
        DataCell(
          SizedBox(
            width: 80,
            child: Text(_listProduct[index].name ?? ""),
          ),
        ),
        DataCell(
          SizedBox(
            width: 80,
            child: Text(_listProduct[index].category!.description ?? ""),
          ),
        ),
      ],
    );
  }

  void selectIndex(int index, bool? isSelect) {
    _listProduct.elementAt(index).isSelect = isSelect ?? false;
    refreshComponent();
  }

  bool isSelect(int index) {
    return _listProduct.elementAt(index).isSelect;
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _listProduct.length;

  @override
  int get selectedRowCount =>
      _listProduct.where((element) => element.isSelect).toList().length;
}
