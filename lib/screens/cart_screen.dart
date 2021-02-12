import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/cart_list_item.dart';
import '../providers/cart.dart';
import '../providers/orders.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = false;

  Future<void> _saveOrder(Orders ordersProvider, Cart cart) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await ordersProvider.addOrder(cart.items.values.toList(), cart.totalAmount);
      cart.clear();
    } catch(error) {
      setState(() {
        _isLoading = false;
      });
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error ocurred!'),
          content: Text('Something went wrong...'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        )
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final ordersProvider = Provider.of<Orders>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: const TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$ ${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.headline6.color
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
                    textColor: Theme.of(context).primaryColor,
                    onPressed: _isLoading || cart.itemCount <= 0 ? null : () {
                      _saveOrder(ordersProvider, cart);
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final key = cart.items.keys.elementAt(index);
                return CartListItem(cart.items[key]);
              },
            ),
          ),
        ],
      ),
    );
  }
}