import 'package:flutter/material.dart';

class ProductAddEditScreen extends StatefulWidget {
  final Object? args;

  const ProductAddEditScreen(this.args, {Key? key}) : super(key: key);

  @override
  State<ProductAddEditScreen> createState() => _ProductAddEditScreenState();
}

class _ProductAddEditScreenState extends State<ProductAddEditScreen> {
  // ----------------------------------------------------------
  // VARIABLES
  // ----------------------------------------------------------
  TextEditingController _id = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _description = TextEditingController();

  Object? _args;

  // ----------------------------------------------------------
  // METHODS
  // ----------------------------------------------------------
  @override
  void initState() {
    super.initState();

    _args = widget.args;

    _cleanForm();

    _recoverProduct();
  }

  void _cleanForm() {
    _id.text = '';
    _name.text = '';
    _description.text = '';
  }

  void _recoverProduct() {
    if (_args != null && _args.toString().isNotEmpty) {
      
    }
  }

  double _boxWidth(double _screenWidth) {
    double loginBoxWidth = _screenWidth;

    if (_screenWidth > 750) {
      loginBoxWidth = 650;
    }

    return loginBoxWidth;
  }

  void _validForm() {}

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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _id,
                      keyboardType: TextInputType.text,
                      enabled: false,
                      decoration: const InputDecoration(
                        hintText: "",
                        labelText: "ID Produto",
                        suffixIcon: Icon(Icons.star_border_rounded),
                      ),
                    ),
                    TextField(
                      controller: _name,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        hintText: "",
                        labelText: "Nome / Título",
                        suffixIcon: Icon(Icons.text_fields_rounded),
                      ),
                    ),
                    TextField(
                      controller: _description,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: "",
                        labelText: "Descrição",
                        suffixIcon: Icon(Icons.text_fields_rounded),
                      ),
                    ),
                  ],
                ),
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
