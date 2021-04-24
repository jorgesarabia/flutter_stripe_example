import 'package:flutter/material.dart';
import 'package:flutter_stripe_example/home_page.dart';
import 'package:flutter_stripe_example/stripe_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stripe Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(
        title: 'Flutter Stripe Example',
        stripeService: StripeService.instance,
      ),
    );
  }
}
