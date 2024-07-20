
import 'package:Inkspire/screens/HomeScreen.dart';
import 'package:Inkspire/screens/ProductDetailScreen.dart';
import 'package:Inkspire/screens/ThankyouScreen.dart';
import 'package:flutter/material.dart';

import 'screens/CartScreen.dart';


void main() {
  runApp(InkspireApp());
}

class InkspireApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inkspire',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        // '/product_detail': (context) => ProductDetailScreen(),
        '/cart': (context) => CartScreenn(),
        '/thank_you': (context) => ThankYouScreen(),
      },
    );
  }
}