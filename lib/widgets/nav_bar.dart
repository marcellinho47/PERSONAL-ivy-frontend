import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sys_ivy_frontend/utils/color_pallete.dart';

class NavBar extends StatelessWidget {
  NavBar({Key? key}) : super(key: key);

  final double _elevation = 2;
  FirebaseAuth _auth = FirebaseAuth.instance;

  bool hasUserImage() {
    if (_auth.currentUser != null && _auth.currentUser!.photoURL != null) {
      return true;
    }
    return false;
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
                child: hasUserImage()
                    ? Image.network(
                        _auth.currentUser!.photoURL!,
                        fit: BoxFit.cover,
                        width: 90,
                        height: 90,
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
              onTap: () {},
            ),
          ),
          Card(
            elevation: _elevation,
            child: ListTile(
              title: const Text("Compras"),
              leading: const Icon(Icons.shopping_cart_rounded),
              onTap: () {},
            ),
          ),
          Card(
            elevation: _elevation,
            child: ListTile(
              title: const Text("Vendas"),
              leading: const Icon(Icons.monetization_on_rounded),
              onTap: () {},
            ),
          ),
          Card(
            elevation: _elevation,
            child: ListTile(
              title: const Text("Produtos"),
              leading: const Icon(Icons.tag_rounded),
              onTap: () {},
            ),
          ),
          Card(
            elevation: _elevation,
            child: ListTile(
              title: const Text("Categorias"),
              leading: const Icon(Icons.label_outline_rounded),
              onTap: () {},
            ),
          ),
          Card(
            elevation: _elevation,
            child: ListTile(
              title: const Text("Estoque"),
              leading: const Icon(Icons.storage_rounded),
              onTap: () {},
            ),
          ),
          Card(
            elevation: _elevation,
            child: ListTile(
              title: const Text("Sair"),
              leading: const Icon(Icons.exit_to_app_rounded),
              onTap: () async {
                await _auth.signOut();
                Navigator.pushReplacementNamed(context, "");
              },
            ),
          ),
        ],
      ),
    );
  }
}
