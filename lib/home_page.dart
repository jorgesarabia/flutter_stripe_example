import 'package:flutter/material.dart';
import 'package:flutter_stripe_example/stripe_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return _ListItem(
              item: 'Item $index',
              price: 100.00 + index * 20.5,
              description: 'Esta es la descripción del item $index',
            );
          },
        ),
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  const _ListItem({
    @required this.item,
    @required this.price,
    @required this.description,
  });

  final String item;
  final String description;
  final double price;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[300],
      elevation: 3.0,
      child: GestureDetector(
        onTap: () {
          print('pagar');
          StripeService.payWithNewCard(
            amount: (price * 100).toInt(),
            currency: 'CAD',
          );
        },
        child: ListTile(
          title: Text(item),
          subtitle: Text(description),
          trailing: Text(
            'CAD $price',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
