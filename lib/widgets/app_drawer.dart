import 'package:flutter/material.dart';

import '../screens/orders_screen.dart';

class AppDrawer extends StatelessWidget {

  Widget _buildListTile(BuildContext context, String title, IconData icon, Function handler) {
    return ListTile(
      leading: Icon(Icons.shop),
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
        ],
      ),
      
    );
  }
}