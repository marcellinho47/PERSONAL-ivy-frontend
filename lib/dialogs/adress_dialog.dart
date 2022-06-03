import 'package:flutter/material.dart';
import 'package:sys_ivy_frontend/entity/adress_entity.dart';

class AdressDialog extends StatefulWidget {
  final AdressEntity _adressEntity;

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
  @override
  void initState() {
    super.initState();

    widget._adressEntity;
  }

  void _valid() {
    _save();
  }

  void _save() {}

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Cadastro / Edição de Contato"),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [],
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
