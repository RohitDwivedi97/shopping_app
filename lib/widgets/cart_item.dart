import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final String id;
  final double price;
  final int quantity;
  final String title;

  CartItem({
    required this.id,
    required this.price,
    required this.quantity,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: ListTile(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    '\$$price',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
          title: Text('$title'),
          subtitle: Text('Total: ${quantity * price}'),
          trailing: Text('$quantity x'),
        ),
      ),
    );
  }
}
