import 'package:flutter/material.dart';
import '../providers/product.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-products-screen';
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  Product _editedProduct = Product(
    id: '',
    description: '',
    title: '',
    price: 0,
    imageUrl: '',
  );

  var initValues = {
    'id': '',
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': ''
  };

  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      var argument = ModalRoute.of(context)!.settings.arguments;
      if (argument != null) {
        _editedProduct = argument as Product;
        if (!_editedProduct.isEmpty()) {
          initValues = {
            'title': _editedProduct.title,
            'price': _editedProduct.price.toString(),
            'description': _editedProduct.description,
            //'imageUrl': editedProduct.imageUrl,
            'imageUrl': '',
          };
          _imageUrlController.text = _editedProduct.imageUrl;
        }
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(onFocus);
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(onFocus);
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void onFocus() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('png') &&
              !_imageUrlController.text.endsWith('jpg') &&
              !_imageUrlController.text.endsWith('jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  void saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    if (_editedProduct.id != '') {
      await Provider.of<Products>(context, listen: false)
          .editProduct(_editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('An error occurred.'),
            content: const Text('Something went wrong.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text('Okay'),
              ),
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            splashRadius: 20,
            splashColor: Colors.amber,
            onPressed: () {
              saveForm();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: initValues['title'] as String,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                        ),
                        textInputAction: TextInputAction.next,
                        autofocus: true,
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: value as String,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                            isFavourite: _editedProduct.isFavourite,
                          );
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please provide a value';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: initValues['price'].toString(),
                        decoration: const InputDecoration(
                          labelText: 'Price',
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: double.parse(value as String),
                            imageUrl: _editedProduct.imageUrl,
                            isFavourite: _editedProduct.isFavourite,
                          );
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please provide a value.';
                          } else if (double.tryParse(value) == null) {
                            return 'Please provide a valid value.';
                          } else if (double.parse(value) <= 0) {
                            return 'Please provide a value greate than 0.';
                          } else {
                            return null;
                          }
                        },
                      ),
                      TextFormField(
                        initialValue: initValues['description'] as String,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                        ),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: value as String,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                            isFavourite: _editedProduct.isFavourite,
                          );
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a description.';
                          } else if (value.length < 10) {
                            return 'Please enter a description with atleast 10 characters.';
                          }
                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            height: 100,
                            width: 100,
                            margin: const EdgeInsets.only(
                              top: 8,
                              right: 10,
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? const Text('Add a URL.')
                                : FittedBox(
                                    fit: BoxFit.contain,
                                    child: Image.network(
                                        _imageUrlController.text,
                                        height: 100.0),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              //initialValue: initValues['imageUrl'] as String,
                              // intitValue and a controller can't be used at the same time
                              // inside a TextFormField.
                              decoration: const InputDecoration(
                                labelText: 'Image Url',
                              ),
                              keyboardType: TextInputType.url,
                              controller: _imageUrlController,
                              textInputAction: TextInputAction.done,
                              focusNode: _imageUrlFocusNode,
                              onSaved: (value) {
                                _editedProduct = Product(
                                  id: _editedProduct.id,
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  price: _editedProduct.price,
                                  imageUrl: value as String,
                                  isFavourite: _editedProduct.isFavourite,
                                );
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please provide an image URL.';
                                } else if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'Please provide a valid URL.';
                                } else if (!value.endsWith('png') &&
                                    !value.endsWith('jpg') &&
                                    !value.endsWith('jpeg')) {
                                  return 'Please provide a valid image URL.';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
