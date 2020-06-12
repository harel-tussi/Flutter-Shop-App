import 'package:flutter/material.dart';
import 'package:flutter_proj/providers/cart.dart' show Cart;
import 'package:flutter_proj/providers/orders.dart';
import 'package:flutter_proj/widgets/cart_item.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Cart"),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "Total",
                        style: TextStyle(fontSize: 22),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Chip(
                        label: Text(
                          "\$${cart.totalAmount.toStringAsFixed(2)}",
                          style: TextStyle(
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .headline6
                                  .color),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: RaisedButton(
                      child: Text("ORDER NOW"),
                      onPressed: () {
                        Provider.of<Orders>(context, listen: false).addOrder(
                            cart.items.values.toList(), cart.totalAmount);
                        cart.clearCart();
                      },
                      textColor:
                          Theme.of(context).primaryTextTheme.headline6.color,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
                itemBuilder: (ctx, index) {
                  final cartItem = cart.items.values.toList()[index];
                  return CartItem(
                    productId: cart.items.keys.toList()[index],
                    id: cartItem.id,
                    title: cartItem.title,
                    price: cartItem.price,
                    quantity: cartItem.quantity,
                  );
                },
                itemCount: cart.itemsCount),
          )
        ],
      ),
    );
  }
}
