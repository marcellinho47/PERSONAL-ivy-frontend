import 'package:flutter/material.dart';
import 'package:sys_ivy_frontend/entity/contact_entity.dart';
import 'package:sys_ivy_frontend/enums/contact_type_enum.dart';
import 'package:sys_ivy_frontend/utils/toasts.dart';

import '../entity/contact_type_entity.dart';
import '../utils/functions.dart';

class ContactDialog extends StatefulWidget {
  final ContactEntity? _contactEntity;

  const ContactDialog(
    this._contactEntity, {
    Key? key,
  }) : super(
          key: key,
        );

  @override
  State<ContactDialog> createState() => _ContactDialogState();
}

class _ContactDialogState extends State<ContactDialog> {
  // ----------------------------------------------------------
  // VARIABLES
  // ----------------------------------------------------------
  ContactEntity? _contact;
  TextEditingController _description = TextEditingController();

  int _maxLength = 11;
  String _hintText = "";
  TextInputType _inputType = TextInputType.phone;
  IconData _icon = Icons.phone_enabled_rounded;
  // ----------------------------------------------------------
  // METHODS
  // ----------------------------------------------------------
  @override
  void initState() {
    super.initState();

    _contact = widget._contactEntity ?? ContactEntity();
    _contact!.contactType = null;
  }

  List<DropdownMenuItem<ContactTypeEntity>> _dropdownMenuItemsTypeContact() {
    List<DropdownMenuItem<ContactTypeEntity>> items = [];
    for (ContactType element in ContactType.values) {
      items.add(
        DropdownMenuItem(
          value: ContactTypeEntity(
            idContactType: element.index,
            description: element.name,
          ),
          child: Text(element.name),
          alignment: Alignment.centerLeft,
        ),
      );
    }

    return items;
  }

  void _onChangedDropdownTypeContact(ContactTypeEntity contactType) {
    switch (contactType.description) {
      case "CELULAR_WHATSAPP":
      case "CELULAR":
        _hintText = "62988887777";
        _icon = Icons.phone_enabled_rounded;
        _maxLength = 11;
        _inputType = TextInputType.phone;
        break;
      case "TELEFONE":
        _hintText = "6288887777";
        _icon = Icons.mobile_friendly_rounded;
        _maxLength = 10;
        _inputType = TextInputType.phone;
        break;
      case "EMAIL":
        _hintText = "6288887777";
        _icon = Icons.email_rounded;
        _maxLength = 10;
        _inputType = TextInputType.emailAddress;
        break;
      default:
    }

    setState(() {
      _description.clear();
    });
  }

  void _valid() {
    if (_description.text.isEmpty) {
      showToast(
          context, WARNING_TYPE_TOAST, "Descrição é obrigatória", 2, null);
    }

    switch (_contact!.contactType!.description) {
      case "CELULAR_WHATSAPP":
      case "CELULAR":
        if (_description.text.length != _maxLength) {
          showToast(context, WARNING_TYPE_TOAST, "Celular inválido", 2, null);
          return;
        }
        break;
      case "TELEFONE":
        if (_description.text.length != _maxLength) {
          showToast(context, WARNING_TYPE_TOAST, "Telefone inválido", 2, null);
          return;
        }
        break;
      case "EMAIL":
        if (!UtilFunctions.isValidEmail(_description.text)) {
          showToast(context, WARNING_TYPE_TOAST, "Email inválido", 2, null);
          return;
        }
        break;
      default:
    }

    _save();
  }

  void _save() {
    _contact!.description = _description.text;
    Navigator.of(context).pop(_contact);
  }

  // ----------------------------------------------------------
  // BUILD
  // ----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Cadastro / Edição de Contato"),
      content: SizedBox(
        width: 300,
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            DropdownButton<ContactTypeEntity>(
              items: _dropdownMenuItemsTypeContact(),
              onChanged: (value) {
                _onChangedDropdownTypeContact(value!);
              },
              value: _contact!.contactType,
            ),
            TextField(
              decoration: InputDecoration(
                hintText: _hintText,
                labelText: "Descrição",
                suffixIcon: Icon(_icon),
              ),
              keyboardType: _inputType,
              controller: _description,
              maxLength: _maxLength,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text("Cancelar"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text("Salvar"),
          onPressed: () {
            _valid();
          },
        ),
      ],
    );
  }
}
