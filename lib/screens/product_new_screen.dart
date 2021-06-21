// Packages:
import '../_inner_packages.dart';
import '../_external_packages.dart';

// Screens:

// Models:
import '../models/_models.dart';

// Components:
import 'package:flutter/cupertino.dart';

// Helpers:
import '../helpers/_helpers.dart';

// Utilities:
import '../utilities/_utilities.dart';

class ProductNewScreen extends StatefulWidget {
  static const String screenId = 'product_new_screen';

  @override
  _ProductNewScreenState createState() => _ProductNewScreenState();
}

class _ProductNewScreenState extends State<ProductNewScreen> {
  // Local State Properties:
  String _title = '';
  String _description = '';
  double _price = 0;
  String _imageUrl = ListHelper.randomFromList(DUMMY_FOOD_IMAGE_URLS);
  Color _color = Colors.orangeAccent;

  void changeColor(Color color) => setState(() => _color = color);

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context, listen: true);

    ProductsData productsData = Provider.of<ProductsData>(context, listen: true);
    Function onAddProductHandler = (title, color) => productsData.addProduct(title: _title, description: _description, price: _price, imageUrl: _imageUrl);

    Color primaryColor = Theme.of(context).primaryColor;
    Color accentColor = Theme.of(context).accentColor;

    var foregroundColor = ColorHelper.contrastingColor(_color);

    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      onPrimary: foregroundColor,
      primary: _color,
      elevation: 3,
      textStyle: TextStyle(
        color: Colors.red,
      ),
      minimumSize: Size(double.infinity, 36),
      padding: EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
    );

    // final ButtonStyle elevatedButtonStyle = ButtonStyle(
    //   foregroundColor: MaterialStateProperty.all(foregroundColor),
    //   backgroundColor: MaterialStateProperty.all(_color),
    //   minimumSize: MaterialStateProperty.all(Size(double.infinity, 36)),
    //   padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 16)),
    //   elevation: MaterialStateProperty.all(3),
    //   textStyle: MaterialStateProperty.all(TextStyle(
    //     color: Colors.red,
    //   )),
    // );

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        child: Container(
          // padding: const EdgeInsets.only(left: 20, top: 0, right: 20),
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
                  'Add Product',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 30,
                  ),
                ),

                // Title Input
                TextField(
                  autofocus: true,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: 'Title',
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
                  style: TextStyle(),
                  onChanged: (String newText) {
                    setState(() {
                      _title = newText;
                    });
                  },
                  onSubmitted: !_hasValidData() ? null : (_) => () => _submitData(context, onAddProductHandler),
                ),

                // Price Input
                TextField(
                  autofocus: true,
                  autocorrect: false,
                  keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
                  decoration: InputDecoration(
                    hintText: 'Price',
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
                  style: TextStyle(),
                  onChanged: (String newText) {
                    setState(() {
                      _price = NumericHelper.roundDouble(newText.parseDoubleOrZero, 2);
                    });
                  },
                  onSubmitted: !_hasValidData() ? null : (_) => () => _submitData(context, onAddProductHandler),
                ),

                // Description Input
                TextField(
                  autofocus: true,
                  autocorrect: false,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Description',
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
                  style: TextStyle(),
                  onChanged: (String newText) {
                    setState(() {
                      _description = newText;
                    });
                  },
                  onSubmitted: !_hasValidData() ? null : (_) => () => _submitData(context, onAddProductHandler),
                ),

                // Add button:
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 30.0),
                  child: DeviceHelper.deviceIsIOS(context)
                      ? Container(
                          color: Colors.transparent,
                          height: 48.0,
                          width: double.infinity,
                          child: CupertinoButton(
                            color: primaryColor,
                            disabledColor: Colors.grey,
                            onPressed: !_hasValidData() ? null : () => _submitData(context, onAddProductHandler),
                            child: Text(
                              'Add',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : Material(
                          color: _hasValidData() ? primaryColor : Colors.grey,
                          // borderRadius: BorderRadius.circular(12.0),
                          elevation: 5,
                          child: MaterialButton(
                            disabledColor: Colors.grey,
                            onPressed: !_hasValidData() ? null : () => _submitData(context, onAddProductHandler),
                            // minWidth: 300.0,
                            minWidth: double.infinity,
                            height: 42.0,
                            child: Text(
                              'Add',
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
    );
  }

  bool _hasValidData() {
    bool result = false;
    if (_title.isNotEmpty && _description.isNotEmpty && _price > 0 && _imageUrl.isNotEmpty) {
      result = true;
    }
    return result;
  }

  void _submitData(BuildContext context, Function onAddProduct) {
    if (_hasValidData()) {
      // onAddProduct(_title, _description, _price, _imageUrl);
      onAddProduct();
    }
    Navigator.pop(context);
  }
}
