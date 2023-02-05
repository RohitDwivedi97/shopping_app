import 'package:flutter/material.dart';
import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-products-screen';
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  Product _product = Product(
    id: '',
    description: '',
    title: '',
    price: 0,
    imageUrl: '',
  );

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

  void saveForm() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    print(_product.id);
    print(_product.title);
    print(_product.description);
    print(_product.price);
    print(_product.imageUrl);
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
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                  textInputAction: TextInputAction.next,
                  autofocus: true,
                  onSaved: (value) {
                    _product = Product(
                        id: _product.id,
                        title: value as String,
                        description: _product.description,
                        price: _product.price,
                        imageUrl: _product.imageUrl);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please provide a value';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Price',
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    _product = Product(
                        id: _product.id,
                        title: _product.title,
                        description: _product.description,
                        price: double.parse(value as String),
                        imageUrl: _product.imageUrl);
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
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  onSaved: (value) {
                    _product = Product(
                        id: _product.id,
                        title: _product.title,
                        description: value as String,
                        price: _product.price,
                        imageUrl: _product.imageUrl);
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
                              child: Image.network(_imageUrlController.text,
                                  height: 100.0),
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Image Url',
                        ),
                        keyboardType: TextInputType.url,
                        controller: _imageUrlController,
                        textInputAction: TextInputAction.done,
                        focusNode: _imageUrlFocusNode,
                        onSaved: (value) {
                          _product = Product(
                            id: _product.id,
                            title: _product.title,
                            description: _product.description,
                            price: _product.price,
                            imageUrl: value as String,
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
