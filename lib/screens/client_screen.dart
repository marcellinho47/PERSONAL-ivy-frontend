// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:sys_ivy_frontend/entity/person_entity.dart';
import 'package:sys_ivy_frontend/repos/person_repo.dart';

import '../config/routes_config.dart';
import '../utils/toasts.dart';

class ClientScreen extends StatefulWidget {
  const ClientScreen({Key? key}) : super(key: key);

  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  // ----------------------------------------------------------
  // VARIABLES
  // ----------------------------------------------------------
  TextEditingController _name = TextEditingController();
  TextEditingController _initialAge = TextEditingController();
  TextEditingController _finalAge = TextEditingController();

  List<PersonEntity> _listPerson = [];
  String _personType = '';
  String _sex = '';

  PersonRepo _personRepo = PersonRepo();

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
    if (_name.text.isNotEmpty) {
      _listPerson = await _personRepo.findByLikeName(_name.text);
    } else if (_personType.isNotEmpty) {
      _listPerson = await _personRepo.findByTaxID(_personType);
    } else if (_sex.isNotEmpty) {
      _listPerson = await _personRepo.findBySex(_sex);
    } else if (_initialAge.text.isNotEmpty || _finalAge.text.isNotEmpty) {
      _listPerson = await _personRepo.findBetweenAge(
          int.tryParse(_initialAge.text), int.tryParse(_finalAge.text));
    } else {
      _listPerson = await _personRepo.findAll();
    }

    setState(() {
      _listPerson;
    });
  }

  void _addPerson() {
    Navigator.pushReplacementNamed(context, Routes.CLIENTS_ADD_EDIT_ROUTE);
  }

  void _editPerson() {
    if (_countSelectPerson() != 1) {
      showToast(context, WARNING_TYPE_TOAST, "Selecione 1 cliente para editar.",
          null, null);
      return;
    }

    Navigator.pushReplacementNamed(
      context,
      Routes.CLIENTS_ADD_EDIT_ROUTE,
      arguments: _listPerson.where((element) => element.isSelect).first,
    );
  }

  void _deletePerson() {
    if (_countSelectPerson() < 1) {
      showToast(context, WARNING_TYPE_TOAST,
          "Selecione ao menos um cliente para excluir.", null, null);
      return;
    }

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

  void _delete() {
    _personRepo.deleteAll(
      _listPerson
          .where((element) => element.isSelect)
          .map((e) => e.idPerson!)
          .toList(),
    );

    showToast(
      context,
      SUCESS_TYPE_TOAST,
      "Registros excluídos com sucesso!",
      null,
      null,
    );

    _search();
  }

  void refreshComponent() {
    setState(() {
      _listPerson;
    });
  }

  int _countSelectPerson() {
    return _listPerson.where((element) => element.isSelect).length;
  }

  void _onChangedDropdownTaxId(String? typePersonValue) {
    setState(() {
      _personType = typePersonValue ?? 'CPF';
    });
  }

  List<DropdownMenuItem<String>> _dropdownMenuItemsTaxId() {
    return [
      const DropdownMenuItem(
        child: Text(''),
        value: '',
      ),
      const DropdownMenuItem(
        child: Text('CPF'),
        value: 'CPF',
      ),
      const DropdownMenuItem(
        child: Text('CNPJ'),
        value: 'CNPJ',
      ),
    ];
  }

  void _onChangedDropdownSex(String? sexValue) {
    setState(() {
      _sex = sexValue ?? '';
    });
  }

  List<DropdownMenuItem<String>> _dropdownMenuItemsSex() {
    return [
      const DropdownMenuItem(
        child: Text(''),
        value: '',
      ),
      const DropdownMenuItem(
        child: Text('Feminino'),
        value: 'F',
      ),
      const DropdownMenuItem(
        child: Text('Masculino'),
        value: 'M',
      ),
    ];
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
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 8,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 18,
                              ),
                              TextField(
                                controller: _name,
                                keyboardType: TextInputType.text,
                                enabled: true,
                                decoration: const InputDecoration(
                                  hintText: "",
                                  labelText: "Nome",
                                ),
                                maxLength: 100,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<String>(
                            items: _dropdownMenuItemsTaxId(),
                            value: _personType,
                            onChanged: (value) {
                              _onChangedDropdownTaxId(value);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 18,
                              ),
                              TextField(
                                controller: _initialAge,
                                keyboardType: TextInputType.number,
                                enabled: true,
                                decoration: const InputDecoration(
                                  hintText: "18",
                                  labelText: "Faixa Etária",
                                ),
                                maxLength: 2,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 18,
                              ),
                              TextField(
                                controller: _finalAge,
                                keyboardType: TextInputType.text,
                                enabled: true,
                                maxLength: 2,
                                decoration: const InputDecoration(
                                  hintText: "26",
                                  labelText: "",
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<String>(
                            items: _dropdownMenuItemsSex(),
                            value: _sex,
                            hint: const Text("Sexo:"),
                            onChanged: (value) {
                              _onChangedDropdownSex(value);
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () {
                              _search();
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
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Visibility(
              visible: _listPerson.isNotEmpty,
              child: Column(
                children: [
                  PaginatedDataTable(
                    rowsPerPage: 5,
                    showFirstLastButtons: true,
                    showCheckboxColumn: true,
                    checkboxHorizontalMargin: 20,
                    columnSpacing: 20,
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text(
                          'Código',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Nome',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Sexo',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Contatos',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Endereços',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                    source: ClientDataTableSource(
                      _listPerson,
                      refreshComponent,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _addPerson();
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
                    _editPerson();
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
                    _deletePerson();
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

// ----------------------------------------------------------
// AUXILIAR CLASS
// ----------------------------------------------------------
class ClientDataTableSource extends DataTableSource {
  final List<PersonEntity> _listPerson;
  void Function() refreshComponent;

  ClientDataTableSource(
    this._listPerson,
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
          Center(
            child: Text(
              _listPerson[index].idPerson.toString(),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 280,
            child: Text(
              _listPerson[index].name!,
              textAlign: TextAlign.start,
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              _listPerson[index].sex!,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              _listPerson[index].listContact!.length.toString(),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              _listPerson[index].listPersonAdress!.length.toString(),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  void selectIndex(int index, bool? isSelect) {
    _listPerson.elementAt(index).isSelect = isSelect ?? false;
    refreshComponent();
  }

  bool isSelect(int index) {
    return _listPerson.elementAt(index).isSelect;
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _listPerson.length;

  @override
  int get selectedRowCount =>
      _listPerson.where((element) => element.isSelect).toList().length;
}
