import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sys_ivy_frontend/config/routes.dart';
import 'package:sys_ivy_frontend/utils/color_pallete.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final double _elevation = 2;
  FirebaseAuth _auth = FirebaseAuth.instance;

  bool hasUserPhoto() {
    if (_auth.currentUser != null && _auth.currentUser!.photoURL != null) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              _auth.currentUser == null
                  ? 'Dev'
                  : _auth.currentUser!.displayName!,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            accountEmail: Text(
              _auth.currentUser == null
                  ? 'javaaplication.alves@gmail.com'
                  : _auth.currentUser!.email!,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: hasUserPhoto()
                    ? Image(
                        image: CachedNetworkImageProvider(
                            _auth.currentUser!.photoURL!),
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
