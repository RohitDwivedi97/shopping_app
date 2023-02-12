import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../widgets/app_drawer.dart';
import '../providers/products.dart';

enum FiltersOption { FavouritesOnly, ShowAll }

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavouritesOnly = false;

  @override
  void initState() {
    //Provider.of<Products>(context,listen: false).fetchAndSetProducts();
    // 2nd way of using context things inside initState and the 3rd way is to use 
    // DidChangeDependencies
    Future.delayed(Duration.zero).then((value) =>
        Provider.of<Products>(context, listen: false).fetchAndSetProducts());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //add a flutter drawer and show options to open Orders
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('My shop app'),
        actions: [
          Consumer<Cart>(
            builder: (context, cart, ch) => Badge(
              value: cart.totalItems.toString(),
              color: Theme.of(context).accentColor,
              child: ch as Widget,
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed('/cart-screen');
              },
            ),
          ),
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
