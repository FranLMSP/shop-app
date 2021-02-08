import 'package:flutter/material.dart';

import '../providers/cart.dart';

class CartListItem extends StatelessWidget {
  final CartItem cartItem;

  CartListItem(this.cartItem);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 4,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          leading: CircleAvatar(
            child: FittedBox(
              child: Text('\$${cartItem.product.price}'),
            ),
          ),
          title: Text(cartItem.product.title),
          subtitle: Text('Total: \$ ${cartItem.product.price * cartItem.quantity}'),
          trailing: Text('x ${cartItem.quantity}'),
        ),
      ),
    );
  }
}