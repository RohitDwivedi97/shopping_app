import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-products-screen';
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();

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
    if(!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                  textInputAction: TextInputAction.next,
                  autofocus: true,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Price',
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
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
                                height: 100.0
                              ),
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
                        focusNode: _imageUrlFocusNode
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
