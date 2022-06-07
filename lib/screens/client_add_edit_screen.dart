import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sys_ivy_frontend/config/routes_config.dart';
import 'package:sys_ivy_frontend/dialogs/contact_dialog.dart';
import 'package:sys_ivy_frontend/dialogs/person_adress_dialog.dart';
import 'package:sys_ivy_frontend/entity/person_entity.dart';
import 'package:sys_ivy_frontend/repos/person_repo.dart';
import 'package:sys_ivy_frontend/utils/functions.dart';
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

  final _formKey = GlobalKey<FormState>();
  TextEditingController _id = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _cpfCNPJ = TextEditingController();
  TextEditingController _birthday = TextEditingController();

  String _personType = 'CPF';
  String _sex = 'F';

  List<ContactEntity?> _listContact = [];
  List<PersonAdressEntity?> _listPersonAdress = [];

  // ----------------------------------------------------------
  // METHODS
  // ----------------------------------------------------------
  @override
  void initState() {
    super.initState();

    recoverEdit();
  }

  void recoverEdit() {
    if (widget.args != null) {
      PersonEntity personEntity = widget.args as PersonEntity;

      _id.text = personEntity.idPerson.toString();
      _name.text = personEntity.name!;
      _personType = personEntity.personType ?? 'CPF';
      _sex = personEntity.sex!;

      if (personEntity.birthday != null) {
        _birthday.text =
            DateFormat("ddMMyyyy").format(personEntity.birthday!.toDate());
      }

      if (_personType.contains('CPF')) {
        _cpfCNPJ.text = personEntity.cpf ?? "";
      } else {
        _cpfCNPJ.text = personEntity.cnpj ?? "";
      }

      _listContact = personEntity.listContact ?? [];
      _listPersonAdress = personEntity.listPersonAdress ?? [];
    }
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
      _personType = typePersonValue ?? 'CPF';
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
      _sex = sexValue ?? 'F';
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

    if (_personType == 'CPF' &&
        _cpfCNPJ.text.isNotEmpty &&
        !CPFValidator.isValid(_cpfCNPJ.text)) {
      showToast(context, WARNING_TYPE_TOAST, "CPF inválido!", 2, null);
      return;
    }

    if (_personType == 'CNPJ' &&
        _cpfCNPJ.text.isNotEmpty &&
        !CNPJValidator.isValid(_cpfCNPJ.text)) {
      showToast(context, WARNING_TYPE_TOAST, "CNPJ inválido!", 2, null);
      return;
    }

    if (_birthday.text.isNotEmpty && !UtilFunctions.isNumeric(_birthday.text)) {
      showToast(
          context, WARNING_TYPE_TOAST, "Data de nascimento inválida!", 2, null);
      return;
    }

    _save();
  }

  void _save() {
    DateTime? birth;
    if (_birthday.text.isNotEmpty) {
      birth = DateTime(
        int.parse(_birthday.text.substring(4, 8)),
        int.parse(_birthday.text.substring(2, 4)),
        int.parse(_birthday.text.substring(0, 2)),
      );
    }

    PersonEntity personEntity = PersonEntity(
      idPerson: int.tryParse(_id.text),
      name: _name.text,
      personType: _personType,
      sex: _sex,
      cpf: _personType == 'CPF' ? _cpfCNPJ.text : null,
      cnpj: _personType == 'CNPJ' ? _cpfCNPJ.text : null,
      birthday: birth != null ? Timestamp.fromDate(birth) : null,
      listContact: _listContact,
      listPersonAdress: _listPersonAdress,
    );

    PersonRepo().save(personEntity);

    showToast(
      context,
      SUCESS_TYPE_TOAST,
      "Cliente salvo com sucesso!",
      null,
      null,
    );

    Navigator.pushReplacementNamed(context, Routes.CLIENTS_ROUTE);
  }

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
                              value: _personType,
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
                                    labelText: _personType,
                                    suffixIcon:
                                        const Icon(Icons.text_fields_rounded),
                                  ),
                                  keyboardType: TextInputType.text,
                                  maxLength: _personType == 'CPF' ? 11 : 14,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      DropdownButtonFormField<String>(
                        items: _dropdownMenuItemsSex(),
                        value: _sex,
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
