import 'package:flutter/material.dart';

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

  String typePerson = 'CPF';
  String sex = 'F';

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

  _onChangedDropdownTaxId(String? typePersonValue) {
    setState(() {
      typePerson = typePersonValue ?? 'CPF';
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

  _onChangedDropdownSex(String? sexValue) {
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

  // ----------------------------------------------------------
  // BUILD
  // ----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: SizedBox(
          width: _boxWidth(_screenWidth),
          child: Card(
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
                      decoration: const InputDecoration(
                        hintText: "",
                        labelText: "ID Cliente",
                        suffixIcon: Icon(Icons.star_border_rounded),
                      ),
                      keyboardType: TextInputType.text,
                      enabled: false,
                    ),
                    TextFormField(
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
                    InputDatePickerFormField(
                      fieldLabelText: "Data de Nascimento",
                      firstDate: DateTime.parse("1930-01-01"),
                      lastDate: DateTime.now(),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
