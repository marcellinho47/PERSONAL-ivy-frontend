// ignore_for_file: prefer_final_fields

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
  String _hintText = "62988887777";
  TextInputType _inputType = TextInputType.phone;
  IconData _icon = Icons.phone_enabled_rounded;
  // ----------------------------------------------------------
  // METHODS
  // ----------------------------------------------------------
  @override
  void initState() {
    super.initState();

    _contact = widget._contactEntity ?? ContactEntity();

    _contact!.contactType = ContactTypeEntity(
      idContactType: ContactTypeEnum.WHATSAPP.index,
      description: ContactTypeEnum.WHATSAPP.name,
    );
  }

  List<DropdownMenuItem<int>> _dropdownMenuItemsTypeContact() {
    List<DropdownMenuItem<int>> items = [];
    for (ContactTypeEnum element in ContactTypeEnum.values) {
      items.add(
        DropdownMenuItem(
          value: element.index,
          child: Text(element.name),
          alignment: Alignment.centerLeft,
        ),
      );
    }

    return items;
  }

  void _onChangedDropdownTypeContact(int? id) {
    String desc = ContactTypeEnum.values
        .where((element) => element.index == id)
        .first
        .name;

    _contact!.contactType!.idContactType = id;
    _contact!.contactType!.description = desc;

    switch (desc) {
      case "WHATSAPP":
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
        _hintText = "email@exemplo.com.br";
        _icon = Icons.email_rounded;
        _maxLength = 50;
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
      case "WHATSAPP":
      case "CELULAR":
        if (_description.text.length != _maxLength ||
            !UtilFunctions.isNumeric(_description.text)) {
          showToast(context, WARNING_TYPE_TOAST, "Celular inválido", 2, null);
          return;
        }
        break;
      case "TELEFONE":
        if (_description.text.length != _maxLength ||
            !UtilFunctions.isNumeric(_description.text)) {
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
    switch (_contact!.contactType!.description) {
      case "WHATSAPP":
      case "CELULAR":
      case "TELEFONE":
        _contact!.description = formatMobile();
        break;
      case "EMAIL":
        _contact!.description = _description.text.toLowerCase().trim();
        break;
    }

    Navigator.of(context).pop(_contact);
  }

  String formatMobile() {
    String mobile = _description.text;
    if (mobile.length == 10) {
      mobile =
          "(${mobile.substring(0, 2)}) ${mobile.substring(2, 6)}-${mobile.substring(6, 10)}";
    } else {
      mobile =
          "(${mobile.substring(0, 2)}) ${mobile.substring(2, 7)}-${mobile.substring(7, 11)}";
    }
    return mobile;
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<int>(
              items: _dropdownMenuItemsTypeContact(),
              onChanged: (value) {
                _onChangedDropdownTypeContact(value);
              },
              value: _contact!.contactType!.idContactType,
              isExpanded: true,
              hint: const Text("Tipo de Contato"),
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
