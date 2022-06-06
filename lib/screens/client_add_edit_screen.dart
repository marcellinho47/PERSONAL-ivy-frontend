import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:sys_ivy_frontend/dialogs/contact_dialog.dart';
import 'package:sys_ivy_frontend/dialogs/person_adress_dialog.dart';
import 'package:sys_ivy_frontend/utils/toasts.dart';

import '../entity/contact_entity.dart';
import '../entity/person_adress_entity.dart';

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
  TextEditingController _id = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _cpfCNPJ = TextEditingController();
  TextEditingController _birthday = TextEditingController();

  String typePerson = 'CPF';
  String sex = 'F';

  List<ContactEntity?> _listContact = [];
  List<PersonAdressEntity?> _listPersonAdress = [];

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
      _cpfCNPJ.clear();
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

  void _validForm() {
    if (!_formKey.currentState!.validate()) {
      showToast(
          context, WARNING_TYPE_TOAST, "Contém inconsistências!", null, null);
      return;
    }

    if (_name.text.isEmpty) {
      showToast(context, WARNING_TYPE_TOAST, "Nome obrigatório", null, null);
      return;
    }

    if (typePerson == 'CPF' &&
        _cpfCNPJ.text.isNotEmpty &&
        !CPFValidator.isValid(_cpfCNPJ.text)) {
      showToast(context, WARNING_TYPE_TOAST, "CPF inválido!", 2, null);
      return;
    }

    if (typePerson == 'CNPJ' &&
        _cpfCNPJ.text.isNotEmpty &&
        !CPFValidator.isValid(_cpfCNPJ.text)) {
      showToast(context, WARNING_TYPE_TOAST, "CNPJ inválido!", 2, null);
      return;
    }

    _save();
  }

  void _save() {}

  void _cleanForm() {
    _listContact = [];
    _listPersonAdress = [];

    setState(() {
      _formKey.currentState!.reset();
    });
  }

  void _addContact() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return const ContactDialog(null);
      },
    ).then((value) {
      ContactEntity? contact = value;
      contact?.idContact = _listContact.length + 1;

      if (value != null) {
        setState(() {
          _listContact.add(contact);
        });
      }
    });
  }

  void _editContact(int index) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return ContactDialog(_listContact[index]);
      },
    ).then((value) {
      ContactEntity? contact = value;

      if (value != null) {
        setState(() {
          _listContact[contact!.idContact! - 1] = contact;
        });
      }
    });
  }

  void _deleteConfirm(int index, int type) {
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
                Navigator.of(context).pop();
                setState(() {
                  if (type == 0) {
                    _deleteContact(index);
                  } else {
                    _deleteAdress(index);
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteContact(int index) {
    _listContact.removeAt(index);

    for (ContactEntity? contact in _listContact) {
      contact!.idContact = _listContact.indexOf(contact) + 1;
    }
  }

  void _addAdress() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return const PersonAdressDialog(null);
      },
    ).then((value) {
      PersonAdressEntity? personAdress = value;
      personAdress?.idPersonAdress = _listContact.length + 1;

      if (value != null) {
        setState(() {
          _listPersonAdress.add(personAdress);
        });
      }
    });
  }

  void _editAdress(int index) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return PersonAdressDialog(_listPersonAdress[index]);
      },
    ).then((value) {
      PersonAdressEntity? adressEntity = value;

      if (value != null) {
        setState(() {
          _listPersonAdress[adressEntity!.idPersonAdress! - 1] = adressEntity;
        });
      }
    });
  }

  void _deleteAdress(int index) {
    _listPersonAdress.removeAt(index);

    for (PersonAdressEntity? adress in _listPersonAdress) {
      adress!.idPersonAdress = _listPersonAdress.indexOf(adress) + 1;
    }
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _id,
                        decoration: const InputDecoration(
                          hintText: "",
                          labelText: "ID Cliente",
                          suffixIcon: Icon(Icons.star_border_rounded),
                        ),
                        keyboardType: TextInputType.text,
                        enabled: false,
                      ),
                      TextFormField(
                        controller: _name,
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
                                  controller: _cpfCNPJ,
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
                        controller: _birthday,
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
            Card(
              elevation: 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.contacts_rounded),
                    title: const Text(
                      'Contatos',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.add_circle_outline_rounded,
                        color: Colors.black,
                      ),
                      onPressed: _addContact,
                    ),
                  ),
                  Visibility(
                    visible: _listContact.isNotEmpty,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Expanded(
                              flex: 1,
                              child: Text(
                                'ID',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Tipo',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Text(
                                '',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Ações',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              height: 40,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      _listContact[index]!
                                          .idContact!
                                          .toString(),
                                      style: const TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      _listContact[index]!
                                          .contactType!
                                          .description!,
                                      style: const TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Text(
                                      _listContact[index]!.description!,
                                      style: const TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit_rounded),
                                    onPressed: () {
                                      _editContact(index);
                                    },
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_rounded),
                                    onPressed: () {
                                      _deleteConfirm(index, 0);
                                    },
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: _listContact.length,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Card(
              elevation: 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.location_on_rounded),
                    title: const Text(
                      'Endereços',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.add_circle_outline_rounded,
                        color: Colors.black,
                      ),
                      onPressed: _addAdress,
                    ),
                  ),
                  Visibility(
                    visible: _listPersonAdress.isNotEmpty,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Expanded(
                              flex: 1,
                              child: Text(
                                'ID',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Tipo',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Text(
                                'Logradouro',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Ações',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              height: 40,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      _listPersonAdress[index]!
                                          .idPersonAdress!
                                          .toString(),
                                      style: const TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      _listPersonAdress[index]!
                                          .adressType!
                                          .description!,
                                      style: const TextStyle(fontSize: 12),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Text(
                                      _listPersonAdress[index]!.adress!.street!,
                                      style: const TextStyle(fontSize: 12),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit_rounded),
                                    onPressed: () {
                                      _editAdress(index);
                                    },
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_rounded),
                                    onPressed: () {
                                      _deleteConfirm(index, 1);
                                    },
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: _listPersonAdress.length,
                        ),
                      ],
                    ),
                  ),
                ],
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
