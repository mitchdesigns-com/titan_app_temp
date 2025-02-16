import 'package:flutter/material.dart';

import 'category_tree_widget.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // padding: EdgeInsets.zero,
        children: <Widget>[
          const CategoryTreeWidget(),
          const Divider(),
          ExpansionTile(
            title: const Text("Corporate Pages"),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            children: [
              _buildCorporateTile('Corporate 1', Icons.business),
              _buildCorporateTile('Corporate 2', Icons.business),
              _buildCorporateTile('Corporate 3', Icons.business),
              _buildCorporateTile('Corporate 4', Icons.business),
            ],
          ),
          const Divider(),
          ListTile(
            title: const Text("Settings"),
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          ExpansionTile(
            title: const Text("My Account"),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            children: [
              _buildMyAccountTile(
                  context, 'Dashboard', Icons.dashboard, '/dashboard'),
              _buildMyAccountTile(
                  context, 'My Orders', Icons.shopping_cart, '/my_orders'),
              _buildMyAccountTile(
                  context, 'Edit Profile', Icons.edit, '/edit_profile'),
              _buildMyAccountTile(context, 'Logout', Icons.logout, '/logout'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCorporateTile(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {},
    );
  }

  Widget _buildMyAccountTile(
      BuildContext context, String title, IconData icon, String route) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
    );
  }
}
