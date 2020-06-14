import 'package:flutter/material.dart';
import 'package:flutter_proj/providers/cart.dart';
import 'package:flutter_proj/providers/orders.dart';
import 'package:flutter_proj/screens/cart_screen.dart';
import 'package:flutter_proj/screens/edit_product_screen.dart';
import 'package:flutter_proj/screens/orders_screen.dart';
import 'package:flutter_proj/screens/user_prosucts_screen.dart';
import 'package:provider/provider.dart';

import './screens/product_details_screen.dart';
import './screens/products_overview_screen.dart';
import './providers/products.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Products(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => Orders(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          accentColor: Colors.red,
          fontFamily: "Lato",
        ),
        initialRoute: "/",
        home: ProductsOverviewScreen(),
        // setting routes
        routes: {
          ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen()
        },
      ),
    );
  }
}
