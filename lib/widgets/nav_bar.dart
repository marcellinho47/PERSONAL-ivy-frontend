import 'package:flutter/material.dart';
import 'package:sys_ivy_frontend/utils/color_pallete.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  final double _elevation = 2;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('Oflutter.com'),
            accountEmail: Text('example@gmail.com'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
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
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
