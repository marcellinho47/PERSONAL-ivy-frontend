import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sys_ivy_frontend/config/dao_config.dart';
import 'package:sys_ivy_frontend/config/roles.dart';
import 'package:sys_ivy_frontend/entity/operator_entity.dart';
import 'package:sys_ivy_frontend/utils/functions.dart';
import 'package:sys_ivy_frontend/utils/toasts.dart';

class OperatorAddEdit extends StatefulWidget {
  final Object? args;
  const OperatorAddEdit(this.args, {Key? key}) : super(key: key);

  @override
  _OperatorAddEditState createState() => _OperatorAddEditState();
}

class _OperatorAddEditState extends State<OperatorAddEdit> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  Object? _args;

  TextEditingController _uid = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _passwordConfirmation = TextEditingController();
  TextEditingController _isAdmin = TextEditingController();
  StringBuffer _toastMsg = StringBuffer("");
  String? dropdownRoleValue;
  OperatorEntity? op;

  double _boxWidth(double _screenWidth) {
    double loginBoxWidth = _screenWidth;

    if (_screenWidth > 750) {
      loginBoxWidth = 650;
    }

    return loginBoxWidth;
  }

  void _getDataEdit() async {
    _cleanForm();

    if (_args != null) {
      DocumentSnapshot doc = await _firestore
          .collection(DaoConfig.OPERATOR_COLLECTION)
          .doc(_args.toString())
          .get();

      op = OperatorEntity.fromDocument(doc);

      setState(() {
        _setEntitytoForm();
      });
    }
  }

  void _cleanForm() {
    op = OperatorEntity();
    dropdownRoleValue = Roles.ROLE_OPERADOR;
    _uid.text = "";
    _email.text = "";
    _password.text = "";
    _passwordConfirmation.text = "";
    _isAdmin.text = Roles.ROLE_OPERADOR;
  }

  void _setEntitytoForm() {
    _uid.text = op!.idOperator!;
    _email.text = op!.login!;
    _password.text = op!.password!;
    _passwordConfirmation.text = op!.password!;

    if (op!.isAdmin!) {
      dropdownRoleValue = Roles.ROLE_ADMIN;
    } else {
      dropdownRoleValue = Roles.ROLE_OPERADOR;
    }
  }

  void _setFormToEntity() {
    op!.idOperator = _uid.text;
    op!.login = _email.text;
    op!.password = _password.text;

    if (dropdownRoleValue == Roles.ROLE_ADMIN) {
      op!.isAdmin = true;
    } else {
      op!.isAdmin = false;
    }
  }

  void _validForm() {
    bool isValidForm = true;
    _toastMsg = StringBuffer("");

    // EMAIL - LOGIN
    if (_email.text.isEmpty) {
      _toastMsg.write("E-mail não informado.\n");
      isValidForm = false;
    } else if (!UtilFunctions.isValidEmail(_email.text)) {
      _toastMsg.write("E-mail inválido.\n");
      isValidForm = false;
    }

    // PASSWORD
    if (_password.text.isEmpty) {
      _toastMsg.write("Senha não informada.\n");

      isValidForm = false;
    } else if (_password.text.length < 8) {
      _toastMsg.write("Senha deve conter pelo menos 8 caracteres.\n");
      _password.text = "";
      isValidForm = false;
    }

    // PASSWORD CONFIRMATION
    if (_passwordConfirmation.text.isEmpty) {
      _toastMsg.write("Confirmação de senha não informada.\n");
      isValidForm = false;
    } else if (_passwordConfirmation.text.length < 8) {
      _toastMsg.write("Senha deve conter pelo menos 8 caracteres.\n");
      _passwordConfirmation.text = "";
      isValidForm = false;
    }

    // PASSWORD and PASSWORD CONFIRMATION
    if (_passwordConfirmation.text.isEmpty) {
      _toastMsg.write("Senha e Confirmação de senha devem ser iguais.\n");
      _password.text = "";
      _passwordConfirmation.text = "";
      isValidForm = false;
    }

    if (isValidForm) {
      _saveUpdateOperator();
    } else {
      showWarningToast(context, _toastMsg.toString());
    }
  }

  void _saveUpdateOperator() async {
    _setFormToEntity();

    if (op!.idOperator == null || op!.idOperator!.isEmpty) {
      // CREATE
      op!.idOperatorInclusion = _auth.currentUser!.uid;
      op!.inclusionDate = Timestamp.now();
      op!.exclusionDate = Timestamp.fromMillisecondsSinceEpoch(1);

      UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: op!.login!, password: op!.password!);

      user.user!.uid;

      await _firestore
          .collection(DaoConfig.OPERATOR_COLLECTION)
          .doc(user.user!.uid)
          .set(op!.toJson());
    } else {
      // UPDATE
      await _firestore
          .collection(DaoConfig.OPERATOR_COLLECTION)
          .doc(op!.idOperator)
          .update(op!.toJson());
    }

    _cleanForm();
    showSuccessToast(context, "Operador cadastrado com sucesso!");
  }

  @override
  void initState() {
    super.initState();

    _args = widget.args;
    _getDataEdit();
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        width: _boxWidth(_screenWidth),
        padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
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
                    // TODO add file picker
                    // TODO add name of operator

                    TextField(
                      controller: _uid,
                      keyboardType: TextInputType.text,
                      enabled: false,
                      decoration: const InputDecoration(
                        hintText: "",
                        labelText: "ID Operador",
                        suffixIcon: Icon(Icons.star_border_rounded),
                      ),
                    ),
                    TextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      enabled: true,
                      decoration: const InputDecoration(
                        hintText: "example@com.br",
                        labelText: "E-mail",
                        suffixIcon: Icon(Icons.mail_outline_rounded),
                      ),
                    ),
                    TextField(
                      controller: _password,
                      keyboardType: TextInputType.text,
                      enabled: true,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: "*******",
                        labelText: "Senha",
                        suffixIcon: Icon(Icons.lock_outline_rounded),
                      ),
                    ),
                    TextField(
                      controller: _passwordConfirmation,
                      keyboardType: TextInputType.text,
                      enabled: true,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: "*******",
                        labelText: "Confirmação de Senha",
                        suffixIcon: Icon(Icons.lock_outline_rounded),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text(
                          "Permissão: ",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        DropdownButton(
                          hint: const Text("Selecão de Permissão"),
                          borderRadius: BorderRadius.circular(10),
                          value: dropdownRoleValue,
                          items: List<DropdownMenuItem<String>>.generate(
                            Roles.ALL_ROLES.length,
                            (index) => DropdownMenuItem<String>(
                              value: Roles.ALL_ROLES.elementAt(index),
                              child: Text(Roles.ALL_ROLES.elementAt(index)),
                            ),
                          ),
                          onChanged: (String? role) {
                            setState(() {
                              dropdownRoleValue = role;
                            });
                          },
                        ),
                      ],
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
                    _validForm();
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
