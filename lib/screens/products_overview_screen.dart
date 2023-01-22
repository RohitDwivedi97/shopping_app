import 'package:flutter/material.dart';
import '../providers/product.dart';
import '../widgets/products_grid.dart';

enum FiltersOption { FavouritesOnly, ShowAll }

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavouritesOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My shop app'),
        actions: [
          PopupMenuButton(
            onSelected: (FiltersOption selectedValue) {
              setState(() {
                if (selectedValue == FiltersOption.FavouritesOnly) {
                  _showFavouritesOnly = true;
                } else {
                  _showFavouritesOnly = false;
                }
              });
            },
            icon: const Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              const PopupMenuItem(
                child: Text('Favourites Only'),
                value: FiltersOption.FavouritesOnly,
              ),
              const PopupMenuItem(
                child: Text('Show All'),
                value: FiltersOption.ShowAll,
              ),
            ],
          )
        ],
      ),
      body: ProductsGrid(_showFavouritesOnly),
    );
  }
}
