// Packages:
import '../_inner_packages.dart';
import '../_external_packages.dart';

// Screens:
import '../screens/_screens.dart';

// Models:
import '../models/_models.dart';

// Components:
import '../components/_components.dart';

// Helpers:
import '../helpers/_helpers.dart';

// Utilities:
import '../utilities/_utilities.dart';

class ProductDetailsHeader extends StatefulWidget {
  // Properties:
  final Product product;
  final bool isFavorite;

  // Constructor:
  ProductDetailsHeader({
    Key key,
    this.product,
    this.isFavorite,
  }) : super(key: key);

  @override
  _ProductDetailsHeaderState createState() => _ProductDetailsHeaderState();
}

class _ProductDetailsHeaderState extends State<ProductDetailsHeader> {
  // State Properties:
  bool _isFavorite;

  // Runtime constants:
  final DateFormat formatter = DateFormat().add_yMMMMd();
  final currencyFormat = new NumberFormat("#,##0.00", "en_US");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  void toggleLocallyFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context, listen: true);
    Map currentCurrency = appData.currentCurrency;
    final String formattedDate = formatter.format(widget.product.createdAt);
    final String amountLabel = '${currentCurrency['symbol']}${currencyFormat.format(widget.product.price)}';
    final double amountFontSize = (84 / amountLabel.length);
    Color primaryColor = Theme.of(context).primaryColor;
    // Color accentColor = Theme.of(context).accentColor;
    int userId = 1;

    ProductsData productsData = Provider.of<ProductsData>(context, listen: true);
    // Function onDeleteFoodRecipeHandler = (id, context) => foodRecipesData.deleteFoodRecipeWithConfirm(id, context);
    // Function onUpdateFoodRecipeHandler = (id, title, imageUrl, duration, complexity, affordability, isGlutenFree, isLactoseFree, isVegan, isVegetarian) => foodRecipesData.updateFoodRecipe(id, title, imageUrl, duration, complexity, affordability, isGlutenFree, isLactoseFree, isVegan, isVegetarian);
    Function toggleFavorite = (userId, productId) => productsData.toggleFavorite(userId, productId);

    return Card(
      // shadowColor: Colors.purpleAccent,
      elevation: 2,
      color: Colors.white70,
      // margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // FoodRecipe Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Image.network(
                  widget.product.imageUrl,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              ...[
                Positioned(
                  top: 20,
                  right: 10,
                  child: IconButton(
                    iconSize: 32,
                    icon: Icon(
                      // _isFavorite ? Icons.favorite : Icons.favorite_border,
                      // color: _isFavorite ? Colors.yellow : Colors.white,
                      widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: widget.isFavorite ? Colors.yellow : Colors.white,
                    ),
                    tooltip: 'Favorite',
                    // onPressed: () => toggleFavorite(userId, widget.foodRecipe.id),
                    onPressed: () {
                      // toggleLocallyFavorite();
                      toggleFavorite(userId, widget.product.id);
                    },
                  ),
                ),
              ],
            ],
          ),

          // Tile with data: Duration, etc
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.title,
                    style: Theme.of(context).textTheme.headline6,
                    softWrap: true,
                    overflow: TextOverflow.fade,
                  ),

                  // Nested Row with duration, complexity & affordability:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Text(
                          '$amountLabel',
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      ),

                      // Add to cart button:
                      Tooltip(
                        padding: EdgeInsets.all(0),
                        message: 'Add to cart',
                        child: IconButton(
                          padding: EdgeInsets.all(0),
                          icon: Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.black,
                            size: 18,
                          ),
                          onPressed: () => {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              subtitle: Text(formattedDate),
            ),
          ),
        ],
      ),
    );
  }
}
