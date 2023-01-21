import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = 'product-details-page';


  @override
  Widget build(BuildContext context) {
    var productId = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(title: Text(productId)),
    );
  }
}