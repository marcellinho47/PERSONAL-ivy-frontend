import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sys_ivy_frontend/config/dao_config.dart';
import 'package:sys_ivy_frontend/entity/operator_entity.dart';

class Operator extends StatefulWidget {
  const Operator({Key? key}) : super(key: key);

  @override
  _OperatorState createState() => _OperatorState();
}

class _OperatorState extends State<Operator> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<OperatorEntity> _listOperators = [];

  @override
  void initState() {
    super.initState();

    _listAllOperators();
  }

  void _listAllOperators() async {
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
    double loginBoxWidth = double.infinity;

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
                    'ID Operador',
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
                  onPressed: () {},
                  style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Icon(
                        Icons.person_add_alt_rounded,
                        size: 15,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text("Adicionar"),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Icon(
                        Icons.mode_edit_outline_rounded,
                        size: 15,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text("Editar"),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Icon(
                        Icons.delete_outline_rounded,
                        size: 15,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text("Excluir"),
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
          Text(_listOperators[index].idOperator ?? ""),
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
