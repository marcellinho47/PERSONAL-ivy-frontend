// ignore_for_file: prefer_final_fields

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sys_ivy_frontend/config/routes_config.dart';
import 'package:sys_ivy_frontend/entity/operator_entity.dart';
import 'package:sys_ivy_frontend/repos/operator_repo.dart';
import 'package:sys_ivy_frontend/utils/toasts.dart';

class Operator extends StatefulWidget {
  const Operator({Key? key}) : super(key: key);

  @override
  _OperatorState createState() => _OperatorState();
}

class _OperatorState extends State<Operator> {
  // ----------------------------------------------------------
  // VARIABLES
  // ----------------------------------------------------------
  FirebaseAuth _auth = FirebaseAuth.instance;
  OperatorRepo _operatorRepo = OperatorRepo();

  List<OperatorEntity> _listOperators = [];

  // ----------------------------------------------------------
  // METHODS
  // ----------------------------------------------------------
  @override
  void initState() {
    super.initState();

    _listAllOperators();
  }

  void _listAllOperators() async {
    _listOperators = [];

    List<OperatorEntity> list = await _operatorRepo.findAll();

    setState(() {
      _listOperators.addAll(list);
    });
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
    if (!_isAdmin()) {
      showToast(
          context, WARNING_TYPE_TOAST, "Usuário sem permissão!", null, null);
      return;
    }

    Navigator.pushReplacementNamed(context, Routes.OPERATOR_ADD_EDIT_ROUTE);
  }

  bool _isAdmin() {
    OperatorEntity op = _listOperators
        .where((element) => element.idOperator == _auth.currentUser!.uid)
        .toList()
        .first;

    if (op.isAdmin == null) {
      return false;
    }

    return op.isAdmin!;
  }

  void _editOperator() {
    if (_countSelectOperators() != 1) {
      showToast(context, WARNING_TYPE_TOAST,
          "Para a edição escolha 1 registro!", null, null);
      return;
    } else {
      OperatorEntity op =
          _listOperators.where((element) => element.isSelect).toList().first;

      if (op.idOperator != _auth.currentUser!.uid) {
        showToast(context, WARNING_TYPE_TOAST,
            "Só é possível alterar o seu cadastro!", null, null);
        return;
      }

      Navigator.pushReplacementNamed(context, Routes.OPERATOR_ADD_EDIT_ROUTE,
          arguments: op.idOperator);
    }
  }

  Future<void> _deleteOperator() async {
    if (_countSelectOperators() < 1) {
      showToast(context, WARNING_TYPE_TOAST,
          "Para a exlusão escolha ao menos 1 registro!", null, null);
      return;
    }

    // Only admin can delete
    if (!_isAdmin()) {
      showToast(
          context, WARNING_TYPE_TOAST, "Usuário sem permissão!", null, null);
      return;
    }

    // Confirmation
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Atenção"),
          content: const Text("Deseja realmente excluir o registro?"),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text("Excluir"),
              onPressed: () {
                _delete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _delete() async {
    // get ids
    List<String> list = _listOperators
        .where((element) => element.isSelect)
        .toList()
        .map((e) => e.idOperator!)
        .toList();

    // delete
    _operatorRepo.deleteAll(list);

    _listAllOperators();

    showToast(context, SUCESS_TYPE_TOAST, "Registros excluídos com sucesso.",
        null, null);
  }

  int _countSelectOperators() {
    return _listOperators.where((element) => element.isSelect).toList().length;
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
            PaginatedDataTable(
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
                    padding: WidgetStateProperty.all(const EdgeInsets.all(20)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
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
                    _editOperator();
                  },
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(const EdgeInsets.all(20)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
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
                    padding: WidgetStateProperty.all(const EdgeInsets.all(20)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
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

// ----------------------------------------------------------
// AUXILIAR CLASS
// ----------------------------------------------------------
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
