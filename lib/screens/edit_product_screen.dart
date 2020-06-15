import 'package:flutter/material.dart';
import 'package:flutter_proj/providers/product.dart';
import 'package:flutter_proj/providers/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit-produtcs";

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  final _imageUrlController = TextEditingController();
  bool _isInit = false;
  bool _isLoading = false;
  var _editedProduct = Product(
      id: null,
      title: "",
      description: "",
      imageUrl: "",
      price: 0,
      isFavorite: false);
  var _initValues = {
    "title": "",
    "description": "",
    "price": 0,
    "imageUrl": ""
  };

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      final productId = ModalRoute.of(context).settings.arguments;
      print(productId);
      if (productId != null) {
        final product =
            Provider.of<Products>(context, listen: false).findById(productId);
        _editedProduct = product;
        _initValues = {
          "title": product.title,
          "price": product.price,
          "description": product.description,
          "imageUrl": product.imageUrl,
        };
        _imageUrlController.text = product.imageUrl;
      }
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    final productsProvider = Provider.of<Products>(context, listen: false);
    if (_editedProduct.id != null) {
      try {
        await productsProvider.updateProduct(_editedProduct.id, _editedProduct);
        Navigator.of(context).pop();
      } catch (e) {}
    } else {
      try {
        await productsProvider.addProduct(_editedProduct);
      } catch (e) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("An error occured!"),
            content: Text("Something went wrong"),
            actions: <Widget>[
              FlatButton(
                child: Text("Okay"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveForm,
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(6.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues["title"],
                      decoration: InputDecoration(labelText: "Title"),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = _editedProduct.copyWith(title: value);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please provide a title";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues["price"].toString(),
                      decoration: InputDecoration(labelText: "Price"),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct =
                            _editedProduct.copyWith(price: double.parse(value));
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please provide a price";
                        }
                        if (double.tryParse(value) == null ||
                            value == 0 ||
                            value == "0") {
                          return "Please enter a valid number";
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues["description"],
                      maxLines: 3,
                      decoration: InputDecoration(labelText: "Description"),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      onFieldSubmitted: (_) {},
                      onSaved: (value) {
                        _editedProduct =
                            _editedProduct.copyWith(description: value);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please provide a price";
                        }
                        if (value.length < 10) {
                          return "Should be at least 10 characters";
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: Container(
                            child: _imageUrlController.text.isNotEmpty
                                ? Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Add URL",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: "Image URL"),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            focusNode: _imageUrlFocusNode,
                            controller: _imageUrlController,
                            onSaved: (value) {
                              _editedProduct =
                                  _editedProduct.copyWith(imageUrl: value);
                            },
                            onFieldSubmitted: (_) {
                              saveForm();
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter an image URL.';
                              }
                              if (!value.startsWith("http")) {
                                return 'Please enter a valid URL.';
                              }
                              if (!value.endsWith("png") &&
                                  !value.endsWith("jpg")) {
                                print("here2");
                                return 'Please enter a valid URL.';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
