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
  int _id;
  String _title = '';
  String _description = '';
  double _price = 0;
  // String _imageUrl = ListHelper.randomFromList(DUMMY_FOOD_IMAGE_URLS);
  String _imageUrl = PRODUCT_PLACEHOLDER_IMAGE;

  // Run time constants:
  DateTime now = DateTime.now();
  final _oneHundredYearsAgo = DateHelper.timeAgo(years: 100);
  final _oneHundredYearsFromNow = DateHelper.timeFromNow(years: 100);
  final NumberFormat _currencyFormat = new NumberFormat("#,##0.00", "en_US");

  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
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
    _imageUrlController.dispose();
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
                  onChanged: (String newText) {
                    setState(() {
                      _title = newText;
                    });
                  },
                  // onFieldSubmitted: !_hasValidData() ? null : (_) => () => _updateData(context, onUpdateProductsHandler),
                  onFieldSubmitted: (String inputValue) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
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
                  style: TextStyle(),
                  onChanged: (String newText) {
                    setState(() {
                      _price = NumericHelper.roundDouble(newText.parseDoubleOrZero, 2);
                    });
                  },
                  // onFieldSubmitted: !_hasValidData() ? null : (_) => () => _updateData(context, onUpdateProductsHandler),
                  onFieldSubmitted: (String inputValue) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
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
                  onChanged: (String newText) {
                    setState(() {
                      _description = newText;
                    });
                  },
                  // onFieldSubmitted: !_hasValidData() ? null : (_) => () => _updateData(context, onUpdateProductsHandler),
                ),

                // Update button:
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 30.0),
                  child: Material(
                    color: _hasValidData() ? primaryColor : Colors.grey,
                    elevation: 5.0,
                    child: MaterialButton(
                      disabledColor: Colors.grey,
                      onPressed: _hasValidData() ? () => _updateData(context, onUpdateProductsHandler) : null,
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
