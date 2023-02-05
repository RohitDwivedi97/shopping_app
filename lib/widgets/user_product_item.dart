import 'package:flutter/material.dart';
import '../providers/product.dart';

class UserProductItem extends StatelessWidget {
  final Product userProduct;
  UserProductItem({required this.userProduct});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(userProduct.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(userProduct.imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit),
                color: Theme.of(context).primaryColor),
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.delete),
                color: Theme.of(context).errorColor),
          ],
        ),
      ),
    );
  }
}
