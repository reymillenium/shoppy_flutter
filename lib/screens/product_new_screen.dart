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
  String _imageUrl = PRODUCT_PLACEHOLDER_IMAGE;
  Color _color = Colors.orangeAccent;

  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
  }
  // void changeColor(Color color) => setState(() => _color = color);

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      print('_imageUrlFocusNode lost the focus');
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);

    ProductsData productsData = Provider.of<ProductsData>(context, listen: false);
    Function onAddProductHandler = (title, description, price, imageUrl) => productsData.addProduct(title: _title, description: _description, price: _price, imageUrl: _imageUrl);

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
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom), // !important
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
                  textInputAction: TextInputAction.next,
                  style: TextStyle(),
                  onChanged: (String newText) {
                    setState(() {
                      _title = newText;
                    });
                  },
                  // onSubmitted: !_hasValidData() ? null : (_) => () => _submitData(context, onAddProductHandler),
                ),

                // Price Input
                TextField(
                  autofocus: true,
                  autocorrect: false,
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
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
                  style: TextStyle(),
                  onChanged: (String newText) {
                    setState(() {
                      _price = NumericHelper.roundDouble(newText.parseDoubleOrZero, 2);
                    });
                  },
                  // onSubmitted: !_hasValidData() ? null : (_) => () => _submitData(context, onAddProductHandler),
                ),

                // Description Input
                TextField(
                  autofocus: true,
                  autocorrect: false,
                  maxLines: 3,
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
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(),
                  onChanged: (String newText) {
                    setState(() {
                      _description = newText;
                    });
                  },
                  // onSubmitted: !_hasValidData() ? null : (_) => () => _submitData(context, onAddProductHandler),
                ),

                // imageUrl Input & Image Preview:
                Column(
                  children: [
                    // imageUrl Input:
                    TextField(
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
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      style: TextStyle(),
                      onChanged: (String newText) {
                        setState(() {
                          _imageUrl = newText;
                        });
                        // setState(() {});
                      },
                      onEditingComplete: () {
                        setState(() {});
                      },
                      // onSubmitted: !_hasValidData() ? null : (_) => () => _submitData(context, onAddProductHandler),
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
                        // child: buildCachedNetworkImage(imageUrl: _imageUrlController.text),
                        child: buildCachedNetworkImage(imageUrl: _imageUrl),
                      ),
                    ),
                  ],
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

  Widget buildCachedNetworkImage({
    String imageUrl,
    String defaultUrl = PRODUCT_PLACEHOLDER_IMAGE,
  }) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => CircularProgressIndicator(
        color: Colors.blue,
      ),
      // errorWidget: (context, url, error) => new Icon(Icons.error),
      errorWidget: (context, url, error) {
        print('Inside buildCachedNetworkImage error = $error');
        _imageUrl = defaultUrl;
        return Image.network(defaultUrl);
      },
    );
  }

  bool _hasValidData() {
    bool result = false;
    // bool isValidUrl = Uri.parse(_imageUrl).isAbsolute;
    // _imageUrl = isValidUrl ? _imageUrl : PRODUCT_PLACEHOLDER_IMAGE;
    if (_title.isNotEmpty && _description.isNotEmpty && _price > 0 && _imageUrl.isNotEmpty) {
      result = true;
    }
    return result;
  }

//   Future<bool> isValidImageUrl(String imageIUrl) async {
//     print('Inside isValidImageUrl');
//     bool isValidUrl = Uri.parse(_imageUrl).isAbsolute;
//     // bool isImage = true;
//     // var image = CachedNetworkImage(
//     //   imageUrl: _imageUrl,
//     //   placeholder: (context, url) => CircularProgressIndicator(),
//     //   errorWidget: (context, url, error) {
//     //     print('the error is: $error');
//     //     isImage = false;
//     //     return Icon(Icons.error);
//     //   },
//     // );
//
//     final ByteData imageData = await NetworkAssetBundle(Uri.parse(imageIUrl)).load("");
//     final bytes = imageData.buffer.asUint8List();
// // display it with the Image.memory widget
//     Image.memory(bytes);
//     // print('bytes = $bytes');
//     print('Image.memory(bytes) = ${Image.memory(bytes)}');
//     print('imageData.buffer.lengthInBytes = ${imageData.buffer.lengthInBytes}');
//
//     // return (isValidUrl & isImage);
//     return (isValidUrl);
//   }

  void _submitData(BuildContext context, Function onAddProduct) {
    print('Inside _submitData');
    if (_hasValidData()) {
      onAddProduct(_title, _description, _price, _imageUrl);
    }
    Navigator.pop(context);
  }
}
