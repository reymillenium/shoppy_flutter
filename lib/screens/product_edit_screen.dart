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

class ProductEditScreen extends StatefulWidget {
  static const String screenId = 'food_product_edit_screen';

  // Properties:
  final int id;

  // final int index;
  final String title;
  final Color color;
  final Function onUpdateProductHandler;

  // Constructor:
  ProductEditScreen({
    this.id,
    // this.index,
    this.title,
    this.color,
    this.onUpdateProductHandler,
  });

  @override
  _ProductEditScreenState createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  // State Properties:
  int _id;

  // int _index;
  String _title;
  Color _color;

  // Run time constants:
  DateTime now = DateTime.now();
  final _oneHundredYearsAgo = DateHelper.timeAgo(years: 100);
  final _oneHundredYearsFromNow = DateHelper.timeFromNow(years: 100);
  final NumberFormat _currencyFormat = new NumberFormat("#,##0.00", "en_US");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _id = widget.id;
    // _index = widget.index;
    _title = widget.title;
    _color = widget.color;
  }

  void changeColor(Color color) => setState(() => _color = color);

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context, listen: true);
    Map currentCurrency = appData.currentCurrency;

    ProductsData productsData = Provider.of<ProductsData>(context, listen: true);
    Function onUpdateProductsHandler = (id, title, color) => productsData.updateProduct(id, title, color);

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
                  'Update Food Category',
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
                    hintText: 'Title',
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        // color: kLightBlueBackground,
                        color: Colors.red,
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
                  onFieldSubmitted: _hasValidData() ? (_) => () => _updateData(context, onUpdateProductsHandler) : null,
                ),

                // Color Input:
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: ElevatedButton(
                    // elevation: 3.0,
                    style: raisedButtonStyle,
                    // style: elevatedButtonStyle,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            titlePadding: const EdgeInsets.all(0.0),
                            contentPadding: const EdgeInsets.all(0.0),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: _color,
                                onColorChanged: changeColor,
                                colorPickerWidth: 300.0,
                                pickerAreaHeightPercent: 0.7,
                                enableAlpha: true,
                                displayThumbColor: true,
                                showLabel: true,
                                paletteType: PaletteType.hsv,
                                pickerAreaBorderRadius: const BorderRadius.only(
                                  topLeft: const Radius.circular(2.0),
                                  topRight: const Radius.circular(2.0),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Text(
                      'Color',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        // color: Colors.white,
                      ),
                    ),
                    // color: _color,
                    // textColor: useWhiteForeground(currentColor) ? const Color(0xffffffff) : const Color(0xff000000),
                  ),
                ),

                // Update button:
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 30.0),
                  child: Material(
                    color: _hasValidData() ? primaryColor : Colors.grey,
                    // borderRadius: BorderRadius.circular(12.0),
                    elevation: 5.0,
                    child: MaterialButton(
                      disabledColor: Colors.grey,
                      onPressed: _hasValidData() ? () => _updateData(context, onUpdateProductsHandler) : null,
                      // minWidth: 300.0,
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
    bool result = false;
    if (_title.isNotEmpty) {
      result = true;
    }
    return result;
  }

  void _updateData(BuildContext context, Function onUpdateProductsHandler) {
    if (_title.isNotEmpty) {
      onUpdateProductsHandler(_id, _title, _color);
    }
    Navigator.pop(context);
  }
}
