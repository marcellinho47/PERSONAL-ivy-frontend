// ignore_for_file: sized_box_for_whitespace, prefer_final_fields

import 'dart:async';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sys_ivy_frontend/config/roles_config.dart';
import 'package:sys_ivy_frontend/config/routes_config.dart';
import 'package:sys_ivy_frontend/config/storage_config.dart';
import 'package:sys_ivy_frontend/entity/operator_entity.dart';
import 'package:sys_ivy_frontend/repos/operator_repo.dart';
import 'package:sys_ivy_frontend/utils/functions.dart';
import 'package:sys_ivy_frontend/utils/toasts.dart';

class OperatorAddEditScreen extends StatefulWidget {
  final Object? args;
  const OperatorAddEditScreen(
    this.args, {
    Key? key,
  }) : super(key: key);

  @override
  _OperatorAddEditScreenState createState() => _OperatorAddEditScreenState();
}

class _OperatorAddEditScreenState extends State<OperatorAddEditScreen> {
  // ----------------------------------------------------------
  // VARIABLES
  // ----------------------------------------------------------
  FirebaseStorage _storage = FirebaseStorage.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  Object? _args;
  OperatorRepo _operatorRepo = OperatorRepo();

  TextEditingController _uid = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _passwordConfirmation = TextEditingController();
  TextEditingController _isAdmin = TextEditingController();
  String? _imageURL;
  Uint8List? _imageTEMP;

  StringBuffer _toastMsg = StringBuffer("");
  String? dropdownRoleValue;
  OperatorEntity? op;

  // ----------------------------------------------------------
  // METHODS
  // ----------------------------------------------------------
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
      op = await _operatorRepo.findById(_args as String);

      setState(() {
        _setEntitytoForm();
      });
    }
  }

  void _cleanForm() {
    op = OperatorEntity();
    dropdownRoleValue = Roles.ROLE_OPERADOR;
    _uid.clear();
    _name.clear();
    _email.clear();
    _password.clear();
    _passwordConfirmation.clear();
    _isAdmin.text = Roles.ROLE_OPERADOR;
    _imageURL = "";
    _imageTEMP = null;
  }

  void _setEntitytoForm() {
    _uid.text = op!.idOperator!;
    _email.text = op!.login!;
    _password.text = op!.password!;
    _passwordConfirmation.text = op!.password!;
    _name.text = op!.name!;
    _imageURL = op!.imageURL!;

    if (op!.isAdmin!) {
      dropdownRoleValue = Roles.ROLE_ADMIN;
    } else {
      dropdownRoleValue = Roles.ROLE_OPERADOR;
    }
  }

  void _setFormToEntity() {
    op!.idOperator = _uid.text.trim();
    op!.login = _email.text.trim();
    op!.password = _password.text.trim();
    op!.name = _name.text.trim();
    op!.imageURL = _imageURL != null ? _imageURL!.trim() : "";

    if (dropdownRoleValue == Roles.ROLE_ADMIN) {
      op!.isAdmin = true;
    } else {
      op!.isAdmin = false;
    }
  }

  void _validForm() async {
    bool isValidForm = true;
    _toastMsg = StringBuffer("");

    // NAME
    if (_name.text.isEmpty || _name.text.length < 2) {
      _toastMsg.write("Nome não informado.\n");
      isValidForm = false;
    }

    // EMAIL - LOGIN
    if (_email.text.isEmpty) {
      _toastMsg.write("E-mail não informado.\n");
      isValidForm = false;
    } else if (!UtilFunctions.isValidEmail(_email.text)) {
      _toastMsg.write("E-mail inválido.\n");
      isValidForm = false;
    }

    if (_isCreate()) {
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
        _toastMsg.write("Confirmação de Senha não informada.\n");
        isValidForm = false;
      } else if (_passwordConfirmation.text.length < 8) {
        _toastMsg.write("Senha deve conter pelo menos 8 caracteres.\n");
        _passwordConfirmation.text = "";
        isValidForm = false;
      }

      // PASSWORD and PASSWORD CONFIRMATION
      if (_password.text.compareTo(_passwordConfirmation.text) != 0) {
        _toastMsg.write("Senha e Confirmação de Senha devem ser iguais.\n");
        _password.text = "";
        _passwordConfirmation.text = "";
        isValidForm = false;
      }
    }

    if (isValidForm) {
      // ANOTHER USER WITH THIS EMAIL
      List<OperatorEntity?> listEmail =
          await _operatorRepo.findByLogin(_email.text);

      if (listEmail.isNotEmpty &&
          listEmail.first != null &&
          (_uid.text.isEmpty || listEmail.first!.idOperator != _uid.text)) {
        _toastMsg.write("E-mail já cadastrado.\n");
        isValidForm = false;
      }
    }

    if (isValidForm) {
      _createUpdateOperator();
    } else {
      showToast(context, WARNING_TYPE_TOAST, _toastMsg.toString(), null, null);
    }
  }

  void _createUpdateOperator() async {
    _setFormToEntity();

    OperatorEntity save = await _operatorRepo.save(op!);
    String urlImg = await _uploadImagem(save.idOperator!, op!.imageURL);
    _operatorRepo.updateimageURL(save.idOperator!, urlImg);

    // Return
    _auth.signOut();
    showToast(
        context, SUCESS_TYPE_TOAST, "Operador salvo com sucesso!", null, null);
    Navigator.pushReplacementNamed(context, Routes.LOGIN_ROUTE);
  }

  Widget _hasImage() {
    if (_imageTEMP != null && _imageTEMP!.isNotEmpty) {
      // Upload

      return CircleAvatar(
        radius: 45,
        child: ClipOval(
          child: Image.memory(
            _imageTEMP!,
            scale: 0.5,
            fit: BoxFit.cover,
            alignment: FractionalOffset.topCenter,
            filterQuality: FilterQuality.high,
          ),
        ),
      );
    } else if (_imageURL != null && _imageURL!.isNotEmpty) {
      // Cloud

      return CircleAvatar(
        radius: 45,
        child: ClipOval(
          child: Image.network(
            _imageURL!,
            fit: BoxFit.fitWidth,
            alignment: FractionalOffset.topCenter,
            filterQuality: FilterQuality.high,
          ),
        ),
      );
    } else {
      // Default
      return const Icon(
        Icons.person_rounded,
      );
    }
  }

  void _selectImage() async {
    // image
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    // recover the bytes
    setState(() {
      _imageTEMP = result?.files.single.bytes;
    });
  }

  Future<String> _uploadImagem(String idUser, String? url) async {
    if (_imageTEMP != null) {
      Reference imagemPerfilRef =
          _storage.ref(StorageConfig.USERS_IMAGE_PATH + "$idUser.jpg");

      UploadTask uploadTask = imagemPerfilRef.putData(
        _imageTEMP!,
        SettableMetadata(
          contentType: 'image/jpeg',
        ),
      );

      String downloadURL = await uploadTask.snapshot.ref.getDownloadURL();
      return downloadURL;
    }

    return url ?? "";
  }

  @override
  void initState() {
    super.initState();

    _args = widget.args;
    _getDataEdit();
  }

  bool _isCreate() {
    return _uid.text.isEmpty;
  }

  // ----------------------------------------------------------
  // BUILD
  // ----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        width: _boxWidth(_screenWidth),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    IconButton(
                      onPressed: _selectImage,
                      iconSize: 100,
                      padding: EdgeInsets.zero,
                      splashRadius: 55,
                      icon: _hasImage(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
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
                      controller: _name,
                      keyboardType: TextInputType.text,
                      enabled: true,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        hintText: "",
                        labelText: "Nome",
                        suffixIcon: Icon(Icons.person_outline_rounded),
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
                    Visibility(
                      visible: _isCreate(),
                      child: TextField(
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
                    ),
                    Visibility(
                      visible: _isCreate(),
                      child: TextField(
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
                          enableFeedback: op!.isAdmin,
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
                    padding: WidgetStateProperty.all(const EdgeInsets.all(20)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
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
                    padding: WidgetStateProperty.all(const EdgeInsets.all(20)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
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
