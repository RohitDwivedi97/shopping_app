import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart'
    show Cart; // avoiding name class of ClassItem in cart with CartItem widget.
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            elevation: 6,
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    'Total: ',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalPrice}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton(
                    child: const Text('Order Now'),
                    onPressed: () {
                      Provider.of<Orders>(context, listen: false).addOrder(cart.items.values.toList(), cart.totalPrice);
                      cart.clear();
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.totalItems,
              itemBuilder: (ctx, i) {
                var cartItems = cart.items.values.toList();
                var productIds = cart.items.keys.toList();

                var id = cartItems[i].id;
                var productId = productIds[i];
                var price = cartItems[i].price;
                var quantity = cartItems[i].quantity;
                var title = cartItems[i].title;

                return CartItem(
                  id: id,
                  productId: productId,
                  price: price,
                  quantity: quantity,
                  title: title,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
