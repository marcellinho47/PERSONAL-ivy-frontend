import 'package:flutter/material.dart';
import 'package:sys_ivy_frontend/entity/adress_entity.dart';
import 'package:sys_ivy_frontend/enums/adress_type_enum.dart';
import 'package:sys_ivy_frontend/enums/street_type_enum.dart';

class AdressDialog extends StatefulWidget {
  final AdressEntity? _adressEntity;

  const AdressDialog(
    this._adressEntity, {
    Key? key,
  }) : super(
          key: key,
        );

  @override
  State<AdressDialog> createState() => _AdressDialogState();
}

class _AdressDialogState extends State<AdressDialog> {
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

  // ----------------------------------------------------------
  // METHODS
  // ----------------------------------------------------------
  @override
  void initState() {
    super.initState();

    widget._adressEntity;
  }

  void _valid() {
    _save();
  }

  void _save() {}

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
              hint: const Text("Tipo de Endereço"),
            ),
            DropdownButton<int>(
              items: _dropdownMenuItemStreetType(),
              onChanged: (value) {
                _onChangedDropdownStreetType(value!);
              },
              value: _streetTypeId,
              isExpanded: true,
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
                hintText: "00000-000",
                labelText: "CEP",
                suffixIcon: Icon(Icons.location_city_rounded),
              ),
              keyboardType: TextInputType.number,
              controller: _zipcode,
              maxLength: 9,
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
