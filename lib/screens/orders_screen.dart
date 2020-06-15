import 'package:flutter/material.dart';
import 'package:flutter_proj/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = "/orders";

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My orders"),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapshot.error != null) {
              } else {
                return Consumer<Orders>(
                    builder: (BuildContext context, ordersData, _) =>
                        ListView.builder(
                            itemBuilder: (_, index) {
                              return OrderItem(ordersData.orders[index]);
                            },
                            itemCount: ordersData.orders.length));
              }
            }
          },
        ));
  }
}
