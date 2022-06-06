// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:sys_ivy_frontend/entity/adress_entity.dart';
import 'package:sys_ivy_frontend/entity/adress_type_entity.dart';
import 'package:sys_ivy_frontend/entity/person_adress_entity.dart';
import 'package:sys_ivy_frontend/entity/street_type_entity.dart';
import 'package:sys_ivy_frontend/enums/adress_type_enum.dart';
import 'package:sys_ivy_frontend/enums/street_type_enum.dart';
import 'package:sys_ivy_frontend/utils/functions.dart';
import 'package:sys_ivy_frontend/utils/toasts.dart';

class PersonAdressDialog extends StatefulWidget {
  final PersonAdressEntity? _adressEntity;

  const PersonAdressDialog(
    this._adressEntity, {
    Key? key,
  }) : super(
          key: key,
        );

  @override
  State<PersonAdressDialog> createState() => _PersonAdressDialog();
}

class _PersonAdressDialog extends State<PersonAdressDialog> {
  // ----------------------------------------------------------
  // VARIABLES
  // ----------------------------------------------------------
  TextEditingController _street = TextEditingController();
  TextEditingController _number = TextEditingController();
  TextEditingController _complement = TextEditingController();
  TextEditingController _district = TextEditingController();
  TextEditingController _zipcode = TextEditingController();

  int _streetTypeId = 0;
  int _adressTypeId = 0;

  PersonAdressEntity _personAdressEntity = PersonAdressEntity();

  // ----------------------------------------------------------
  // METHODS
  // ----------------------------------------------------------
  @override
  void initState() {
    super.initState();

    recoverEdit();
  }

  void recoverEdit() {
    if (widget._adressEntity == null) {
      _personAdressEntity.adress = AdressEntity();
      _personAdressEntity.adress!.streetType = StreetTypeEntity();
      _personAdressEntity.adressType = AdressTypeEntity();
    } else {
      _personAdressEntity = widget._adressEntity!;
      _street.text = _personAdressEntity.adress!.street!;

      _number.text = _personAdressEntity.adress!.number == null
          ? ""
          : _personAdressEntity.adress!.number!.toString();

      _complement.text = _personAdressEntity.adress!.complement == null
          ? ""
          : _personAdressEntity.adress!.complement!;

      _district.text = _personAdressEntity.adress!.district!;
      _zipcode.text = _personAdressEntity.adress!.zipCode!;
      _streetTypeId = _personAdressEntity.adress!.streetType!.idStreetType!;
      _adressTypeId = _personAdressEntity.adressType!.idAdressType!;
    }
  }

  void _valid() {
    if (_street.text.isEmpty) {
      showToast(
          context, WARNING_TYPE_TOAST, "O Logradouro é obrigatório!", 2, null);
      return;
    }

    if (_number.text.isNotEmpty &&
        (int.parse(_number.text) == 0) &&
        !UtilFunctions.isNumeric(_number.text)) {
      showToast(context, WARNING_TYPE_TOAST,
          "O Número deve ser numérico positivo!", 2, null);
      return;
    }

    if (_number.text.isEmpty && _complement.text.isEmpty) {
      showToast(context, WARNING_TYPE_TOAST,
          "Necessário preencher o Número e/ou Complemento!", 2, null);
      return;
    }

    if (_district.text.isEmpty) {
      showToast(context, WARNING_TYPE_TOAST,
          "Necessário preencher o Bairro/Setor!", 2, null);
      return;
    }

    if (_zipcode.text.isEmpty) {
      showToast(
          context, WARNING_TYPE_TOAST, "Necessário preencher o CEP!", 2, null);
      return;
    } else if (!UtilFunctions.isNumeric(_zipcode.text)) {
      showToast(context, WARNING_TYPE_TOAST, "CEP inválido!", 2, null);
      return;
    }

    _save();
  }

  void _save() {
    _personAdressEntity.adress!.number =
        _number.text.isEmpty ? null : int.parse(_number.text);

    _personAdressEntity.adress!.zipCode = _zipcode.text;

    _personAdressEntity.adress!.street = _street.text;
    _personAdressEntity.adress!.complement = _complement.text;
    _personAdressEntity.adress!.district = _district.text;

    _personAdressEntity.adress!.streetType!.idStreetType = _streetTypeId;
    _personAdressEntity.adress!.streetType!.description =
        _getStreetTypeDescription(_streetTypeId);

    _personAdressEntity.adressType!.idAdressType = _adressTypeId;
    _personAdressEntity.adressType!.description =
        _getAdressTypeDescription(_adressTypeId);

    Navigator.pop(context, _personAdressEntity);
  }

  String _getAdressTypeDescription(int id) {
    return AdressTypeEnum.values
        .where((element) => element.index == id)
        .map((e) => e.name)
        .first;
  }

  String _getStreetTypeDescription(int id) {
    return StreetTypeEnum.values
        .where((element) => element.index == id)
        .map((e) => e.name)
        .first;
  }

  List<DropdownMenuItem<int>>? _dropdownMenuItemAdressType() {
    List<DropdownMenuItem<int>> items = [];

    for (AdressTypeEnum element in AdressTypeEnum.values) {
      items.add(
        DropdownMenuItem<int>(
          value: element.index,
          child: DropdownMenuItem(
            value: element.index,
            child: Text(element.name),
            alignment: Alignment.centerLeft,
          ),
        ),
      );
    }

    return items;
  }

  void _onChangedDropdownAdressType(int value) {
    setState(() {
      _adressTypeId = value;
    });
  }

  List<DropdownMenuItem<int>>? _dropdownMenuItemStreetType() {
    List<DropdownMenuItem<int>> items = [];

    for (StreetTypeEnum element in StreetTypeEnum.values) {
      items.add(
        DropdownMenuItem<int>(
          value: element.index,
          child: DropdownMenuItem(
            value: element.index,
            child: Text(element.name),
            alignment: Alignment.centerLeft,
          ),
        ),
      );
    }

    return items;
  }

  void _onChangedDropdownStreetType(int value) {
    setState(() {
      _streetTypeId = value;
    });
  }

  // ----------------------------------------------------------
  // BUILD
  // ----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Cadastro / Edição de Endereço"),
      content: SizedBox(
        width: 400,
        height: 350,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<int>(
                items: _dropdownMenuItemAdressType(),
                onChanged: (value) {
                  _onChangedDropdownAdressType(value!);
                },
                value: _adressTypeId,
                isExpanded: true,
                menuMaxHeight: 300,
                hint: const Text("Tipo de Endereço"),
              ),
              DropdownButton<int>(
                items: _dropdownMenuItemStreetType(),
                onChanged: (value) {
                  _onChangedDropdownStreetType(value!);
                },
                value: _streetTypeId,
                isExpanded: true,
                menuMaxHeight: 300,
                hint: const Text("Tipo de Logradouro"),
              ),
              TextField(
                decoration: const InputDecoration(
                  hintText: "Paulista",
                  labelText: "Logradouro",
                  suffixIcon: Icon(Icons.location_on),
                ),
                keyboardType: TextInputType.text,
                controller: _street,
                maxLength: 40,
              ),
              TextField(
                decoration: const InputDecoration(
                  hintText: "123",
                  labelText: "Número",
                  suffixIcon: Icon(Icons.location_city_rounded),
                ),
                keyboardType: TextInputType.number,
                controller: _number,
                maxLength: 5,
              ),
              TextField(
                decoration: const InputDecoration(
                  hintText: "Cs. 1",
                  labelText: "Complemento",
                  suffixIcon: Icon(Icons.location_city_rounded),
                ),
                keyboardType: TextInputType.text,
                controller: _complement,
                maxLength: 100,
              ),
              TextField(
                decoration: const InputDecoration(
                  hintText: "Centro",
                  labelText: "Bairro",
                  suffixIcon: Icon(Icons.location_on),
                ),
                keyboardType: TextInputType.text,
                controller: _district,
                maxLength: 100,
              ),
              TextField(
                decoration: const InputDecoration(
                  hintText: "00000000",
                  labelText: "CEP",
                  suffixIcon: Icon(Icons.location_city_rounded),
                ),
                keyboardType: TextInputType.number,
                controller: _zipcode,
                maxLength: 8,
              ),
            ],
          ),
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
