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

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(

    );
  }
}
