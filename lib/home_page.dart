import 'package:flutter/material.dart';
import 'package:flutter_stripe_example/stripe_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    @required this.title,
    @required this.stripeService,
  });

  final String title;
  final StripeService stripeService;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    widget.stripeService.init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            final price = 100.00 + index * 20.5;

            return _ListItem(
              item: 'Item $index',
              price: price,
              description: 'Esta es la descripción del item $index',
              onTap: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text('Va comprar el item $index por CAD $price'),
                        content: Text('Seleccionar método de pago'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              widget.stripeService.payWithNewCard(
                                amount: (price * 100).toInt(),
                                currency: 'CAD',
                              );
                              Navigator.of(context).pop();
                            },
                            child: Text('Pagar con tarjeta'),
                          ),
                          TextButton(
                            onPressed: () {
                              widget.stripeService.payWithToken(
                                amount: (price * 100).toInt(),
                                currency: 'CAD',
                              );
                              Navigator.of(context).pop();
                            },
                            child: Text('Pagar con token'),
                          ),
                          TextButton(
                            onPressed: () {
                              widget.stripeService.saveInfo(
                                amount: (price * 100).toInt(),
                                currency: 'CAD',
                              );
                              Navigator.of(context).pop();
                            },
                            child: Text('Pagar y registrar customer'),
                          ),
                        ],
                      );
                    });
              },
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
    @required this.onTap,
  });

  final String item;
  final String description;
  final double price;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[300],
      elevation: 3.0,
      child: GestureDetector(
        onTap: onTap,
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
