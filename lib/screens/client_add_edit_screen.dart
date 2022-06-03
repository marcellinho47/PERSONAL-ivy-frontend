import 'package:flutter/material.dart';
import 'package:sys_ivy_frontend/dialogs/contact_dialog.dart';

import '../entity/contact_entity.dart';

class ClientAddEditScreen extends StatefulWidget {
  final Object? args;

  const ClientAddEditScreen(this.args, {Key? key}) : super(key: key);

  @override
  State<ClientAddEditScreen> createState() => _ClientAddEditScreenState();
}

class _ClientAddEditScreenState extends State<ClientAddEditScreen> {
  // ----------------------------------------------------------
  // VARIABLES
  // ----------------------------------------------------------
  Object? _args;
  final _formKey = GlobalKey<FormState>();

  String typePerson = 'CPF';
  String sex = 'F';

  // ----------------------------------------------------------
  // METHODS
  // ----------------------------------------------------------
  @override
  void initState() {
    super.initState();

    _args = widget.args;
  }

  double _boxWidth(double _screenWidth) {
    double loginBoxWidth = _screenWidth;

    if (_screenWidth > 750) {
      loginBoxWidth = 650;
    }

    return loginBoxWidth;
  }

  void _onChangedDropdownTaxId(String? typePersonValue) {
    setState(() {
      typePerson = typePersonValue ?? 'CPF';
    });
  }

  List<DropdownMenuItem<String>> _dropdownMenuItemsTaxId() {
    return [
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
      sex = sexValue ?? 'F';
    });
  }

  List<DropdownMenuItem<String>> _dropdownMenuItemsSex() {
    return [
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

  void _validForm() {}

  _save() {}

  _cleanForm() {}

  void _addContact() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return const ContactDialog(null);
      },
    ).then((value) {
      print("then");
      if (value != null) {
        print(value);
      }
    });
    ;
  }

  _editContact() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return ContactDialog(ContactEntity());
      },
    );
  }

  _deleteContact() {}

  _addAddress() {}

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
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: "",
                          labelText: "ID Cliente",
                          suffixIcon: Icon(Icons.star_border_rounded),
                        ),
                        keyboardType: TextInputType.text,
                        enabled: false,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: "",
                          labelText: "Nome",
                          suffixIcon: Icon(Icons.text_fields_rounded),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: DropdownButtonFormField<String>(
                              items: _dropdownMenuItemsTaxId(),
                              value: typePerson,
                              onChanged: (value) {
                                _onChangedDropdownTaxId(value);
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 10,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 18,
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintText: "",
                                    labelText: typePerson,
                                    suffixIcon:
                                        const Icon(Icons.text_fields_rounded),
                                  ),
                                  keyboardType: TextInputType.text,
                                  maxLength: typePerson == 'CPF' ? 11 : 14,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      DropdownButtonFormField<String>(
                        items: _dropdownMenuItemsSex(),
                        value: sex,
                        hint: const Text("Sexo:"),
                        onChanged: (value) {
                          _onChangedDropdownSex(value);
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.datetime,
                        decoration: const InputDecoration(
                          hintText: "01/01/2000",
                          labelText: "Data de Nascimento",
                          suffixIcon: Icon(Icons.calendar_month_rounded),
                        ),
                        maxLength: 10,
                      ),
                    ],
                  ),
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
                      _addContact();
                    });
                  },
                  style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Text("+ Contato"),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.whatsapp_rounded,
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
                      _addAddress();
                    });
                  },
                  style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Text("+ Endereço"),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.home_rounded,
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
