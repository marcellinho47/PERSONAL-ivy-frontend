import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sys_ivy_frontend/config/firestore_config.dart';
import 'package:sys_ivy_frontend/config/routes.dart';
import 'package:sys_ivy_frontend/entity/operator_entity.dart';
import 'package:sys_ivy_frontend/utils/toasts.dart';

class Operator extends StatefulWidget {
  const Operator({Key? key}) : super(key: key);

  @override
  _OperatorState createState() => _OperatorState();
}

class _OperatorState extends State<Operator> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  List<OperatorEntity> _listOperators = [];

  @override
  void initState() {
    super.initState();

    _listAllOperators();
  }

  void _listAllOperators() async {
    // TODO remove exclusion operator
    _listOperators = [];

    CollectionReference operatorRef =
        _firestore.collection(DaoConfig.OPERATOR_COLLECTION);

    QuerySnapshot snapshot = await operatorRef.get();

    for (DocumentSnapshot item in snapshot.docs) {
      OperatorEntity op = OperatorEntity.fromDocument(item);
      setState(() {
        _listOperators.add(op);
      });
    }
  }

  double _boxWidth(double _screenWidth) {
    double loginBoxWidth = _screenWidth;

    if (_screenWidth > 750) {
      loginBoxWidth = 700;
    }

    return loginBoxWidth;
  }

  void refreshComponent() {
    setState(() {
      _listOperators;
    });
  }

  void _addOperator() {
    OperatorEntity op = _listOperators
        .where((element) => element.idOperator == _auth.currentUser!.uid)
        .toList()
        .first;
    if (op.isAdmin != null && !op.isAdmin!) {
      showWarningToast(context, "Usuário sem permissão para cadastro.");
    }

    Navigator.pushReplacementNamed(context, Routes.OPERATOR_ADD_EDIT_ROUTE);
  }

  void _editOperator() {
    if (_countSelectOperators() != 1) {
      showWarningToast(context, "Para a edição escolha 1 registro!");
    } else {
      OperatorEntity op =
          _listOperators.where((element) => element.isSelect).toList().first;

      if (op.idOperator != _auth.currentUser!.uid) {
        showWarningToast(context, "Só é possível alterar o seu cadastro!");
        return;
      }

      Navigator.pushReplacementNamed(context, Routes.OPERATOR_ADD_EDIT_ROUTE,
          arguments: op.idOperator);
    }
  }

  Future<void> _deleteOperator() async {
    if (_countSelectOperators() < 1) {
      showWarningToast(context, "Para a exlusão escolha ao menos 1 registro!");
    } else {
      // TODO - ADD CONFIRMATION

      // execute delete
      List<OperatorEntity> list =
          _listOperators.where((element) => element.isSelect).toList();

      for (var i = 0; i < list.length; i++) {
        list.elementAt(i).idOperatorExclusion = _auth.currentUser!.uid;
        list.elementAt(i).exclusionDate = Timestamp.now();

        await _firestore
            .collection(DaoConfig.OPERATOR_COLLECTION)
            .doc(list.elementAt(i).idOperator)
            .update(list.elementAt(i).toJson());
      }
      setState(() {
        showSuccessToast(context, "Registros excluídos com sucesso.");
        _listAllOperators();
      });
    }
  }

  int _countSelectOperators() {
    return _listOperators.where((element) => element.isSelect).toList().length;
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        width: _boxWidth(_screenWidth),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            PaginatedDataTable(
              header: const Text(
                "Lista de Operadores",
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
              rowsPerPage: 5,
              showCheckboxColumn: true,
              columns: const <DataColumn>[
                DataColumn(
                  label: Text(
                    'Operador',
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Login',
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Admin',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              source: OperatorDataTableSource(_listOperators, refreshComponent),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _addOperator();
                  },
                  style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Text("Adicionar"),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.person_add_alt_rounded,
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
                    _editOperator();
                  },
                  style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(20)),
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
                    _deleteOperator();
                  },
                  style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(20)),
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
    );
  }
}

class OperatorDataTableSource extends DataTableSource {
  List<OperatorEntity> _listOperators;
  void Function() refreshComponent;

  OperatorDataTableSource(this._listOperators, this.refreshComponent);

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
          Text(_listOperators[index].name ?? ""),
        ),
        DataCell(
          Text(_listOperators[index].login ?? ""),
        ),
        DataCell(_listOperators[index].isAdmin!
            ? const Icon(Icons.check_circle_outline_rounded)
            : const Text("")),
      ],
    );
  }

  void selectIndex(int index, bool? isSelect) {
    _listOperators.elementAt(index).isSelect = isSelect ?? false;
    refreshComponent();
  }

  bool isSelect(int index) {
    return _listOperators.elementAt(index).isSelect;
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _listOperators.length;

  @override
  int get selectedRowCount =>
      _listOperators.where((element) => element.isSelect).toList().length;
}
