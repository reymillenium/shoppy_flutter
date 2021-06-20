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

class ProductGridTile extends StatelessWidget {
  // Properties:
  final Product product;

  ProductGridTile({
    Key key,
    this.product,
  }) : super(key: key);

  // Runtime constants:
  final DateFormat formatter = DateFormat().add_yMMMMd();
  final currencyFormat = new NumberFormat("#,##0.00", "en_US");

  void selectProduct(BuildContext context) {
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => ProductShowScreen(
    //       appTitle: 'Feeddy',
    //       product: product,
    //     ),
    //   ),
    // );

    //  Named route:
    // Navigator.pushNamed(context, ProductShowScreen.screenId, arguments: ProductShowScreenArguments(product));
    // It can even use a Map instead:
    Navigator.pushNamed(context, ProductShowScreen.screenId, arguments: {'product': product});
  }

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context, listen: true);
    Map currentCurrency = appData.currentCurrency;

    ProductsData productsData = Provider.of<ProductsData>(context, listen: true);
    Function onDeleteProductHandler = (id, context) => productsData.deleteProductWithConfirm(id, context);
    Function toggleFavorite = (userId, productId) => productsData.toggleFavorite(userId, productId);

    final String formattedDate = formatter.format(product.createdAt);
    final String amountLabel = '${currentCurrency['symbol']}${currencyFormat.format(product.price)}';
    final double priceFontSize = (84 / amountLabel.length);

    Color primaryColor = Theme.of(context).primaryColor;
    var foregroundColor = ColorHelper.contrastingColor(primaryColor);

    return FutureBuilder(
        future: productsData.isFavorite(1, product.id),
        builder: (ctx, AsyncSnapshot<bool> snapshot) {
          bool isFavorite;
          if (snapshot.data != null) {
            isFavorite = snapshot.data;
          }

          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return GridTile(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: Image.network(
                        product.imageUrl,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    ...[
                      Positioned(
                        top: 10,
                        left: 10,
                        child: CircleAvatar(
                          backgroundColor: Colors.black38,
                          radius: 16,
                          child: FittedBox(
                            child: Container(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                '$amountLabel',
                                style: TextStyle(
                                  color: ColorHelper.contrastingColor(primaryColor),
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  fontSize: priceFontSize,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    ...[
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Tooltip(
                                padding: EdgeInsets.all(0),
                                message: 'Delete',
                                child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.black,
                                    size: 18,
                                  ),
                                  onPressed: () => onDeleteProductHandler(product.id, context),
                                ),
                              ),
                              Tooltip(
                                padding: EdgeInsets.all(0),
                                message: 'Edit',
                                child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                    size: 18,
                                  ),
                                  onPressed: () {
                                    showModalBottomSheet(
                                      backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) => ProductEditScreen(
                                        product: product,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                footer: ClipRRect(
                  borderRadius: BorderRadius.only(
                    // topLeft: Radius.circular(10),
                    // topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  child: GridTileBar(
                    backgroundColor: Colors.black38,

                    leading: IconButton(
                      // iconSize: 24,
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.yellow : Colors.white,
                        size: 18,
                      ),
                      tooltip: 'Favorite',
                      onPressed: () => toggleFavorite(1, product.id),
                    ),

                    title: Text(
                      product.title,
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),

                    // Trailing with actions:
                    trailing: Tooltip(
                      padding: EdgeInsets.all(0),
                      message: 'Add to cart',
                      child: IconButton(
                        padding: EdgeInsets.all(0),
                        icon: Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                        onPressed: () => {},
                      ),
                    ),
                  ),
                ),
              );
            default:
              return Text('Loading...');
          }
        });
  }
}
