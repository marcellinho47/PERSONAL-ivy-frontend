import 'package:flutter/material.dart';

class ConfirmationDialog extends StatefulWidget {
  final String? title;
  final String? content;
  final String? confirmText;

  const ConfirmationDialog(
    this.title,
    this.content,
    this.confirmText, {
    Key? key,
  }) : super(key: key);

  @override
  State<ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  String _title = "Atenção";
  String _content = "Deseja realmente excluir o registro?";
  String _confirmText = "Excluir";

  @override
  void initState() {
    _title = widget.title ?? _title;
    _content = widget.content ?? _content;
    _confirmText = widget.confirmText ?? _confirmText;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_title),
      content: Text(_content),
      actions: <Widget>[
        ElevatedButton(
          child: const Text("Cancelar"),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        ElevatedButton(
          child: Text(_confirmText),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
