import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../widgets/order_list_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your orders'),
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (context, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(),);
          }
          if (dataSnapshot.error != null) {
            return Center(
              child: Text('An error ocurred!'),
            );
          }
          return Consumer<Orders>(
            builder: (context, orderData, child) => ListView.builder(
              itemCount: orderData.orders.length,
              itemBuilder: (context, index) => OrderListItem(orderData.orders[index]),
            ),
          );
        },
      ),
      drawer: AppDrawer(),
    );
  }
}