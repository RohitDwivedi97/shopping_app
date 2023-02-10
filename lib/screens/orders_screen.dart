import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/widgets/app_drawer.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = 'orders-screen';

  @override
  Widget build(BuildContext context) {
    var ordersData = Provider.of<Orders>(context).orders;

    return Scaffold(
      drawer: const AppDrawer() ,
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        height: double.infinity,
        child: ListView.builder(
          itemBuilder: (ctx, i) => OrderItem(ordersData[i]),
          itemCount: ordersData.length,
        ),
      ),
    );
  }
}
