import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartListItem extends StatelessWidget {
  final CartItem cartItem;

  CartListItem(this.cartItem);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItem.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(cartItem.product.id);
      },
      confirmDismiss: (direction) {
        return showDialog(context: context, builder: (context) => AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you want to remove the item from the cart?'),
          actions: <Widget>[
            FlatButton(onPressed: () => Navigator.of(context).pop(false), child: Text('No')),
            FlatButton(onPressed: () => Navigator.of(context).pop(true), child: Text('Yes')),
          ],
        ));
      },
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      child: Card(
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
      ),
    );
  }
}