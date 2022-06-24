// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:sys_ivy_frontend/entity/adress_entity.dart';
import 'package:sys_ivy_frontend/entity/adress_type_entity.dart';
import 'package:sys_ivy_frontend/entity/city_entity.dart';
import 'package:sys_ivy_frontend/entity/person_adress_entity.dart';
import 'package:sys_ivy_frontend/entity/street_type_entity.dart';
import 'package:sys_ivy_frontend/enums/adress_type_enum.dart';
import 'package:sys_ivy_frontend/enums/country_enum.dart';
import 'package:sys_ivy_frontend/enums/state_enum.dart';
import 'package:sys_ivy_frontend/enums/street_type_enum.dart';
import 'package:sys_ivy_frontend/utils/functions.dart';
import 'package:sys_ivy_frontend/utils/toasts.dart';

import '../repos/city_repo.dart';

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
  int? _cityId;
  String _stateId = StateEnum.GO.name;
  int _countryId = 0;

  PersonAdressEntity _personAdressEntity = PersonAdressEntity();
  CityRepo _cityRepo = CityRepo();

  List<CityEntity> _cities = [];

  // ----------------------------------------------------------
  // METHODS
  // ----------------------------------------------------------
  @override
  void initState() {
    super.initState();

    _recoverEdit();
  }

  void _recoverEdit() {
    if (widget._adressEntity == null) {
      // CREATE

      // Creating entities
      _personAdressEntity.adress = AdressEntity();
      _personAdressEntity.adress!.streetType = StreetTypeEntity();
      _personAdressEntity.adressType = AdressTypeEntity();

      // Sets the default
      _cityId = 5420;
      _stateId = StateEnum.GO.name;
      _countryId = CountryEnum.BRAZIL.index;

      _filterCities(_stateId);
    } else {
      // UPDATE

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

      _cityId = _personAdressEntity.adress!.idCity;
      _stateId = _personAdressEntity.adress!.state!;
      _countryId = _personAdressEntity.adress!.country!;

      _filterCities(StateEnum.GO.name);
    }
  }

  _filterCities(String state) {
    _cities = _cityRepo.findAllByState(state);
  }

  void _valid() {
    if (_street.text.isEmpty) {
      showToast(
          context, WARNING_TYPE_TOAST, "O Logradouro é obrigatório!", 2, null);
      return;
    }

    if (_number.text.isNotEmpty &&
        (!UtilFunctions.isNumeric(_number.text) ||
            (int.parse(_number.text) == 0))) {
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

    if (_cityId == null) {
      showToast(context, WARNING_TYPE_TOAST, "Necessário preencher a Cidade!",
          2, null);
      return;
    }

    if (_stateId.isEmpty) {
      showToast(context, WARNING_TYPE_TOAST, "Necessário preencher o Estado!",
          2, null);
      return;
    }

    if (_countryId < 0) {
      showToast(
          context, WARNING_TYPE_TOAST, "Necessário preencher o País!", 2, null);
      return;
    }

    _save();
  }

  void _save() {
    // Adress
    _personAdressEntity.adress!.number =
        _number.text.isEmpty ? null : int.parse(_number.text);

    _personAdressEntity.adress!.zipCode = _zipcode.text;
    _personAdressEntity.adress!.street = _street.text;
    _personAdressEntity.adress!.complement = _complement.text;
    _personAdressEntity.adress!.district = _district.text;

    // Street Type
    _personAdressEntity.adress!.streetType!.idStreetType = _streetTypeId;
    _personAdressEntity.adress!.streetType!.description =
        _getStreetTypeDescription(_streetTypeId);

    // Adress Type
    _personAdressEntity.adressType!.idAdressType = _adressTypeId;
    _personAdressEntity.adressType!.description =
        _getAdressTypeDescription(_adressTypeId);

    // City
    _personAdressEntity.adress!.idCity = _cityId;
    _personAdressEntity.adress!.state = _stateId;
    _personAdressEntity.adress!.country = _countryId;

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
        DropdownMenuItem(
          value: element.index,
          child: Text(element.name),
          alignment: Alignment.centerLeft,
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
        DropdownMenuItem(
          value: element.index,
          child: Text(element.name),
          alignment: Alignment.centerLeft,
        ),
      );
    }

    return items;
  }

  void _onChangedDropdownCity(int value) {
    setState(() {
      _cityId = value;
    });
  }

  List<DropdownMenuItem<int>>? _dropdownMenuItemCity() {
    List<DropdownMenuItem<int>> items = [];

    for (CityEntity element in _cities) {
      items.add(
        DropdownMenuItem<int>(
          value: element.idCity,
          child: Text(element.name!),
          alignment: Alignment.centerLeft,
        ),
      );
    }

    return items;
  }

  void _onChangedDropdownState(String value) {
    setState(() {
      _stateId = value;
      _cityId = null;
      _filterCities(value);
    });
  }

  List<DropdownMenuItem<String>>? _dropdownMenuItemState() {
    List<DropdownMenuItem<String>> items = [];

    for (StateEnum element in StateEnum.values) {
      items.add(
        DropdownMenuItem<String>(
          value: element.name,
          child: Text(element.name),
          alignment: Alignment.centerLeft,
        ),
      );
    }

    return items;
  }

  void _onChangedDropdownCountry(int value) {
    setState(() {
      _countryId = value;
    });
  }

  List<DropdownMenuItem<int>>? _dropdownMenuItemCountry() {
    List<DropdownMenuItem<int>> items = [];

    for (CountryEnum element in CountryEnum.values) {
      items.add(
        DropdownMenuItem<int>(
          value: element.index,
          child: Text(element.name),
          alignment: Alignment.centerLeft,
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
              DropdownButton<int>(
                items: _dropdownMenuItemCountry(),
                onChanged: (value) {
                  _onChangedDropdownCountry(value!);
                },
                value: _countryId,
                isExpanded: true,
                menuMaxHeight: 300,
                hint: const Text("País"),
              ),
              DropdownButton<String>(
                items: _dropdownMenuItemState(),
                onChanged: (value) {
                  _onChangedDropdownState(value!);
                },
                value: _stateId,
                isExpanded: true,
                menuMaxHeight: 300,
                hint: const Text("Estado"),
              ),
              DropdownButton<int>(
                items: _dropdownMenuItemCity(),
                onChanged: (value) {
                  _onChangedDropdownCity(value!);
                },
                value: _cityId,
                isExpanded: true,
                menuMaxHeight: 300,
                hint: const Text("Cidade"),
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
