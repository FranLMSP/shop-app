import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/orders_screen.dart';
import './screens/cart_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './widgets/splash_screen.dart';
import './providers/auth.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth(),),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (context, auth, previousProducts) => Products(auth.token, auth.userId, previousProducts == null ? [] : previousProducts.items),
          create: null,
        ),
        ChangeNotifierProvider(create: (_) => Cart(),),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (context, auth, previousOrder) => Orders(auth.token, auth.userId, previousOrder == null ? [] : previousOrder.orders),
          create: null,
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              fontFamily: 'Lato',
            ),
            home: auth.isAuth ? ProductsOverviewScreen() : FutureBuilder(
              future: auth.tryAutoLogin(),
              builder: (context, authResultSnapshot) {
                if (authResultSnapshot.connectionState == ConnectionState.waiting) {
                  print('Waiting');
                  return SplashScreen();
                }
                print('Is auth: ${auth.isAuth}');
                print('Token: ${auth.token}');
                return AuthScreen();
              }
            ),
            routes: {
              ProductDetailScreen.routeName: (_) => ProductDetailScreen(),
              CartScreen.routeName: (_) => CartScreen(),
              OrdersScreen.routeName: (_) => OrdersScreen(),
              UserProductsScreen.routeName: (_) => UserProductsScreen(),
              EditProductScreen.routeName: (_) => EditProductScreen(),
            },
          );
        }
      ),
    );
  }
}