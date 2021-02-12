import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/user_products_screen.dart';
import '../screens/orders_screen.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {

  Widget _buildListTile(BuildContext context, String title, IconData icon, Function handler) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: handler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Shop'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          _buildListTile(context, 'Shop', Icons.shop, () => Navigator.of(context).pushReplacementNamed('/')),
          _buildListTile(context, 'Orders', Icons.payment, () => Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName)),
          _buildListTile(context, 'Manage products', Icons.edit, () => Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName)),
          _buildListTile(context, 'Logout', Icons.exit_to_app, () => Provider.of<Auth>(context, listen: false).logout()),
        ],
      ),
      
    );
  }
}