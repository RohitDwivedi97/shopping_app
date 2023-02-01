import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = 'orders-screen';
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var ordersData = Provider.of<Orders>(context).orders;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: Card(
          margin: const EdgeInsets.all(15),
          child: Column(
            children: [
              ListView.builder(
                itemBuilder: (ctx, i) => OrderItem(ordersData[i]),
                itemCount: ordersData.length,
              )
            ],
          )),
    );
  }
}
