// ignore_for_file: prefer_final_fields

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sys_ivy_frontend/config/routes_config.dart';
import 'package:sys_ivy_frontend/entity/operator_entity.dart';
import 'package:sys_ivy_frontend/repos/operator_repo.dart';
import 'package:sys_ivy_frontend/utils/color_pallete.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  // ----------------------------------------------------------
  // VARIABLES
  // ----------------------------------------------------------
  static const double _elevation = 2;
  OperatorEntity? _operatorEntity =
      OperatorEntity(name: "", login: "", imageURL: "");

  FirebaseAuth _auth = FirebaseAuth.instance;
  OperatorRepo _operatorRepo = OperatorRepo();

  // ----------------------------------------------------------
  // METHODS
  // ----------------------------------------------------------
  bool hasUserPhoto() {
    if (_operatorEntity != null &&
        _operatorEntity!.imageURL != null &&
        _operatorEntity!.imageURL!.isNotEmpty) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();

    _recoverOperator();
  }

  void _recoverOperator() {
    _operatorRepo.findById(_auth.currentUser!.uid).then((operator) {
      setState(() {
        _operatorEntity = operator;
      });
    });
  }

  // ----------------------------------------------------------
  // BUILD
  // ----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              _operatorEntity!.name!,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            accountEmail: Text(
              _operatorEntity!.login!,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: hasUserPhoto()
                    ? AspectRatio(
                        aspectRatio: 200 / 200,
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fitWidth,
                                alignment: FractionalOffset.topCenter,
                                image: NetworkImage(
                                  _operatorEntity!.imageURL!,
                                  scale: 4,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : const Icon(
                        Icons.person_outline_rounded,
                        size: 45,
                      ),
              ),
            ),
            decoration: const BoxDecoration(
              color: ColorPallete.primaryColor,
            ),
          ),
          Card(
            elevation: _elevation,
            child: ListTile(
              title: const Text("Dashboard"),
              leading: const Icon(Icons.dashboard_rounded),
              onTap: () {
                Navigator.pushReplacementNamed(context, Routes.DASHBOARD_ROUTE);
              },
            ),
          ),
          Card(
            elevation: _elevation,
            child: ListTile(
              title: const Text("Compras"),
              leading: const Icon(Icons.shopping_cart_rounded),
              onTap: () {
                Navigator.pushReplacementNamed(context, Routes.PURCHASES_ROUTE);
              },
            ),
          ),
          Card(
            elevation: _elevation,
            child: ListTile(
              title: const Text("Vendas"),
              leading: const Icon(Icons.monetization_on_rounded),
              onTap: () {
                Navigator.pushReplacementNamed(context, Routes.SALES_ROUTE);
              },
            ),
          ),
          Card(
            elevation: _elevation,
            child: ListTile(
              title: const Text("Produtos"),
              leading: const Icon(Icons.tag_rounded),
              onTap: () {
                Navigator.pushReplacementNamed(context, Routes.PRODUCTS_ROUTE);
              },
            ),
          ),
          Card(
            elevation: _elevation,
            child: ListTile(
              title: const Text("Categorias"),
              leading: const Icon(Icons.label_outline_rounded),
              onTap: () {
                Navigator.pushReplacementNamed(
                    context, Routes.CATEGORIES_ROUTE);
              },
            ),
          ),
          Card(
            elevation: _elevation,
            child: ListTile(
              title: const Text("Estoque"),
              leading: const Icon(Icons.storage_rounded),
              onTap: () {
                Navigator.pushReplacementNamed(context, Routes.STOCK_ROUTE);
              },
            ),
          ),
          Card(
            elevation: _elevation,
            child: ListTile(
              title: const Text("Clientes"),
              leading: const Icon(Icons.people_rounded),
              onTap: () {
                Navigator.pushReplacementNamed(context, Routes.CLIENTS_ROUTE);
              },
            ),
          ),
          Card(
            elevation: _elevation,
            child: ListTile(
              title: const Text("Operadores"),
              leading: const Icon(Icons.person_pin_circle_rounded),
              onTap: () {
                Navigator.pushReplacementNamed(context, Routes.OPERATOR_ROUTE);
              },
            ),
          ),
          Card(
            elevation: _elevation,
            child: ListTile(
              title: const Text("Sair"),
              leading: const Icon(Icons.exit_to_app_rounded),
              onTap: () async {
                await _auth.signOut();
                Navigator.pushReplacementNamed(context, Routes.INITAL_ROUTE);
              },
            ),
          ),
        ],
      ),
    );
  }
}
