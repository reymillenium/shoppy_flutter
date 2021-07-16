// Packages:
import '../_inner_packages.dart';
import '../_external_packages.dart';

// Screens:

// Models:
import '../models/_models.dart';

// Components:

// Helpers:
import '../helpers/_helpers.dart';

// Utilities:
import '../utilities/_utilities.dart';

class ProductEditScreen extends StatefulWidget {
  static const String screenId = 'food_product_edit_screen';

  // Properties:
  final Product product;

  // final Function onUpdateProductHandler;

  // Constructor:
  ProductEditScreen({
    this.product,
    // this.onUpdateProductHandler,
  });

  @override
  _ProductEditScreenState createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  // Local State Properties:
  final _formGlobalKey = GlobalKey<FormState>();
  int _id;
  String _title = '';
  String _description = '';
  double _price = 0;
  String _imageUrl = '';
  String _imageUrlErrors = '';

  // Run time constants:
  DateTime now = DateTime.now();
  final _oneHundredYearsAgo = DateHelper.timeAgo(years: 100);
  final _oneHundredYearsFromNow = DateHelper.timeFromNow(years: 100);
  final NumberFormat _currencyFormat = new NumberFormat("#,##0.00", "en_US");

  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _id = widget.product.id;
    _title = widget.product.title;
    _description = widget.product.description;
    _price = widget.product.price;
    _imageUrl = widget.product.imageUrl;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // Frees up the memory. Prevents the focusNodes to stick around in memory and to lead to a memory leak):
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
  }

  void _saveForm(BuildContext context, Function onUpdateProductsHandler) {
    final isValid = _formGlobalKey.currentState.validate();
    // If is not valid the form's content it stops the function execution
    if (!isValid) {
      print('Is not valid. We have errors');
      return;
    }
    print('Is valid. We do not have errors!!');
    _formGlobalKey.currentState.save();

    onUpdateProductsHandler(_id, _title, _description, _price, _imageUrl);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);
    Map currentCurrency = appData.currentCurrency;

    ProductsData productsData = Provider.of<ProductsData>(context, listen: false);
    Function onUpdateProductsHandler = (productId, title, description, price, imageUrl) => productsData.updateProduct(productId, title, description, price, imageUrl);

    Color primaryColor = Theme.of(context).primaryColor;
    Color accentColor = Theme.of(context).accentColor;

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom), // !important
        child: Form(
          key: _formGlobalKey,
          autovalidateMode: AutovalidateMode.always,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Column(
                children: [
                  Text(
                    'Update Product',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 30,
                    ),
                  ),

                  // Title Input
                  TextFormField(
                    initialValue: _title,
                    autofocus: true,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: primaryColor,
                          width: 4.0,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: accentColor,
                          width: 6.0,
                        ),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    style: TextStyle(),
                    onFieldSubmitted: (String inputValue) {
                      FocusScope.of(context).requestFocus(_priceFocusNode);
                    },
                    onChanged: (String value) {
                      setState(() {
                        _title = value;
                      });
                    },
                    onSaved: (String value) {
                      setState(() {
                        _title = value;
                      });
                    },
                    validator: (String value) {
                      List<dynamic> errors = [];
                      if (value.isEmpty) {
                        errors.add('The title can not be empty');
                      }
                      if (value.length < 2) {
                        errors.add('The title can not be smaller that 2 letters');
                      }
                      return (errors.isEmpty ? null : errors.first);
                    },
                  ),

                  // Price Input
                  TextFormField(
                    initialValue: _price.toString(),
                    autofocus: true,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'Price',
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: primaryColor,
                          width: 4.0,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: accentColor,
                          width: 6.0,
                        ),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
                    focusNode: _priceFocusNode,
                    // inputFormatters: [WhitelistingTextInputFormatter.digitsOnly], // deprecated and allows only digits (no dots)
                    // inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Only numbers. No dots = no doubles (NOT)
                    // inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]+'))], // Allows many dots (wrong)
                    // inputFormatters: [FilteringTextInputFormatter.allow(RegExp('^([0-9]+(\.[0-9]+)?)'))], // Do not allows any dot
                    // inputFormatters: [FilteringTextInputFormatter.allow(RegExp('([0-9]+(\.[0-9]+)?)'))], // Nope. Do not allows dots
                    // inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^ ?\d*'))], // testing (nope) Do not allows dots
                    // inputFormatters: [WhitelistingTextInputFormatter(RegExp("[0-9]+.[0-9]"))], // Not working. Does not allows to type anything new
                    // inputFormatters: [FilteringTextInputFormatter(RegExp("[0-9]+.[0-9]"))], // Not working. IT BREAKS THE APP!
                    // inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))], // Not properly
                    // inputFormatters: [WhitelistingTextInputFormatter(RegExp(r'/^\d{0,2}(\.\d{1,2})?$/'))], // Do not allows anything
                    // More or less:
                    // inputFormatters: [WhitelistingTextInputFormatter(RegExp(r'(^\d*\.?\d*)'))], // Works more or less (But at some point allows a dot at the beginning)
                    // inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))], // Works more or less (But at some point allows a dot at the beginning)
                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^(\d+)\.?\d{0,2}'))], // Works more or less. Allows up to two digits after the comma (not a bad thing really)
                    // inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'(^\-?\d*\.?\d*)'))], // test. More or less Allows negative numbers. (But at some point allows a dot at the beginning)
                    // inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))], // test.  (But at some point allows a dot at the beginning)

                    style: TextStyle(),
                    onChanged: (String value) {
                      setState(() {
                        _price = NumericHelper.roundDouble(value.parseDoubleOrZero, 2);
                      });
                    },
                    onFieldSubmitted: (String inputValue) {
                      FocusScope.of(context).requestFocus(_descriptionFocusNode);
                    },
                    onSaved: (String value) {
                      setState(() {
                        _price = NumericHelper.roundDouble(value.parseDoubleOrZero, 2);
                      });
                    },
                    validator: (String value) {
                      double price = NumericHelper.roundDouble(value.parseDoubleOrZero, 2);
                      List<dynamic> errors = [];
                      if (price.isNaN) {
                        errors.add('The price mus be a number');
                      }
                      if (price == 0) {
                        errors.add('The price can not be zero');
                      }
                      return (errors.isEmpty ? null : errors.first);
                    },
                  ),

                  // Description Input
                  TextFormField(
                    initialValue: _description,
                    autofocus: true,
                    autocorrect: false,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: primaryColor,
                          width: 4.0,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: accentColor,
                          width: 6.0,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.multiline,
                    focusNode: _descriptionFocusNode,
                    style: TextStyle(),
                    // onFieldSubmitted: !_hasValidData() ? null : (_) => () => _updateData(context, onUpdateProductsHandler),
                    onChanged: (String value) {
                      setState(() {
                        _description = value;
                      });
                    },
                    onSaved: (String value) {
                      setState(() {
                        _description = value;
                      });
                    },
                    validator: (String value) {
                      List<dynamic> errors = [];
                      if (value.isEmpty) {
                        errors.add('The description can not be empty');
                      }
                      if (value.length < 2) {
                        errors.add('The description can not be smaller that 2 letters');
                      }
                      return (errors.isEmpty ? null : errors.first);
                    },
                  ),

                  // imageUrl Input & Image Preview:
                  Column(
                    children: [
                      // imageUrl Input:
                      TextFormField(
                        initialValue: _imageUrl,
                        autofocus: true,
                        autocorrect: false,
                        // maxLines: null,
                        decoration: InputDecoration(
                          labelText: 'Image',
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                                // color: kLightBlueBackground,
                                // width: 30,
                                ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: primaryColor,
                              width: 4.0,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: accentColor,
                              // color: Colors.red,
                              width: 6.0,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        // controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        style: TextStyle(),
                        onChanged: (String newText) {
                          if (_imageUrlErrors.isEmpty) {
                            setState(() {
                              _imageUrl = newText;
                            });
                          }
                        },
                        onEditingComplete: () {
                          setState(() {});
                        },
                        // onSubmitted: !_hasValidData() ? null : (_) => () => _submitData(context, onAddProductHandler),
                        // onSaved: (String value) {
                        //   setState(() {
                        //     _imageUrl = value;
                        //   });
                        // },
                        // validator: (String value) {
                        //   List<dynamic> errors = [];
                        //   // bool isValidUrl = Uri.parse(value).isAbsolute;
                        //   // if (!isValidUrl) {
                        //   //   errors.add('The url must be valid');
                        //   // }
                        //   if (_imageUrlErrors.isNotEmpty) {
                        //     errors.add(_imageUrlErrors);
                        //   }
                        //   print('And here _imageUrlErrors = $_imageUrlErrors');
                        //   return (errors.isEmpty ? null : errors.first);
                        // },
                      ),

                      // imageUrl Preview:
                      Container(
                        height: 100,
                        // width: 100,
                        margin: EdgeInsets.only(
                          top: 8,
                          right: 10,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.grey,
                          ),
                        ),
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: buildCachedNetworkImage(imageUrl: _imageUrl),
                          // child: buildNetworkImagePlus(imageUrl: _imageUrlController.text),
                        ),
                      ),
                    ],
                  ),

                  // Update button:
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 30.0),
                    child: Material(
                      color: _hasValidData() ? primaryColor : Colors.grey,
                      elevation: 5.0,
                      child: MaterialButton(
                        disabledColor: Colors.grey,
                        // onPressed: _hasValidData() ? () => _updateData(context, onUpdateProductsHandler) : null,
                        // onPressed: _saveForm,
                        onPressed: () => _saveForm(context, onUpdateProductsHandler),
                        minWidth: double.infinity,
                        height: 42.0,
                        child: Text(
                          'Update',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCachedNetworkImage({
    String imageUrl,
    String defaultUrl = PRODUCT_PLACEHOLDER_IMAGE,
  }) {
    print('Inside buildCachedNetworkImage: _imageUrlErrors = $_imageUrlErrors');
    // setState(() {
    //   _imageUrlErrors = '';
    // });
    _imageUrlErrors = '';
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => CircularProgressIndicator(
        color: Colors.blue,
      ),
      errorWidget: (context, url, error) {
        _imageUrlErrors = error.toString();
        print('Inside buildCachedNetworkImage error = $error');
        _imageUrl = defaultUrl;
        print('_imageUrlErrors = $_imageUrlErrors');
        return Image.network(defaultUrl);
      },
    );
  }

  bool _hasValidData() {
    return (_title.isNotEmpty && _description.isNotEmpty && _price > 0 && _imageUrl.isNotEmpty);
  }

  void _updateData(BuildContext context, Function onUpdateProductsHandler) {
    if (_hasValidData()) {
      onUpdateProductsHandler(_id, _title, _description, _price, _imageUrl);
    }
    Navigator.pop(context);
  }
}
