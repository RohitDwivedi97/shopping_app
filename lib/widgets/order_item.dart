import 'package:flutter/material.dart';
import '../providers/orders.dart' as ord;

class OrderItem extends StatelessWidget {
  final ord.OrderItem orderItem;

  OrderItem(this.orderItem);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${orderItem.amount}'),
      subtitle: Text(orderItem.dateTime.toString()),
    );
  }
}
