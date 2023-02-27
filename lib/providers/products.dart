import 'package:flutter/widgets.dart';
import 'package:shopping_app/models/http_exception.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Mixins is used for sharing properties and methods with classes even if there isn't
// any logical connection. We can extend only one class but can use any number of mixins.

class Products with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> getFavourites() {
    return _items.where((item) => item.isFavourite).toList();
  }

  List<Product> get items {
    return [..._items];
  }

  Future<void> fetchAndSetProducts() async {
    final response = await http.get(Uri.parse(
        'https://shopapp-25e97-default-rtdb.firebaseio.com/products.json'));
    final products = json.decode(response.body);
    final List<Product> extractedProducts = [];
    products.forEach((productId, productItem) {
      final item = Product(
          id: productId,
          description: productItem['description'],
          title: productItem['title'],
          price: productItem['price'],
          imageUrl: productItem['imageUrl'],
          isFavourite: productItem['isFavourite']);
      extractedProducts.add(item);
    });
    _items = extractedProducts;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    try {
      Uri url = Uri.parse(
          'https://shopapp-25e97-default-rtdb.firebaseio.com/products.json');
      String productId;
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavourite': product.isFavourite,
          }));

      productId = json.decode(response.body)['name'];
      product.id = productId;
      _items.add(product);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> editProduct(Product product) async {
    var index = _items.indexWhere((ele) => ele.id == product.id);
    if (index != -1) {
      await http.patch(
          Uri.parse(
              'https://shopapp-25e97-default-rtdb.firebaseio.com/products/${product.id}.json'),
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'isFavourite': product.isFavourite,
          }));
      _items[index] = product;
      notifyListeners();
    }
    return Future.value();
  }

  void deleteProductById(String productId) {
    final existingProductIndex = _items.indexWhere((item) => item.id == productId);
    var existingProduct = _items[existingProductIndex];

    http.delete(
      Uri.parse(
          'https://shopapp-25e97-default-rtdb.firebaseio.com/products/'),
    ).then((response) {
      if(response.statusCode >= 400) {
        throw HttpException('could not delete the product.');
      }
      existingProduct = null as Product;
    }).catchError((erro) {
      _items.insert(existingProductIndex,existingProduct);
       notifyListeners();
    });
     _items.removeAt(existingProductIndex);
    notifyListeners();
  }

  Product getProductById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }
}
