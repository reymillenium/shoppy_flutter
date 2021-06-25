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
  // final Product product;

  ProductGridTile({
    Key key,
    // this.product,
  }) : super(key: key);

  // Runtime constants:
  final DateFormat formatter = DateFormat().add_yMMMMd();
  final currencyFormat = new NumberFormat("#,##0.00", "en_US");

  // void selectProduct(BuildContext context, bool isFavorite) {
  //   Navigator.pushNamed(context, ProductShowScreen.screenId, arguments: {'product': product});
  // }

  void selectProduct(BuildContext context, bool isFavorite, Product product) {
    Navigator.pushNamed(context, ProductShowScreen.screenId, arguments: {'product': product});
  }

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);
    Map currentCurrency = appData.currentCurrency;

    ProductsData productsData = Provider.of<ProductsData>(context);
    Function onDeleteProductHandler = (productId, context, userId) => productsData.deleteProductWithConfirm(productId, context, userId);
    // Function toggleFavorite = (userId, productId) => productsData.toggleFavorite(userId, productId);
    Product productData = Provider.of<Product>(context);
    Function toggleFavorite = (userId) => productData.toggleFavorite(userId);

    // final String formattedDate = formatter.format(product.createdAt);
    // final String amountLabel = '${currentCurrency['symbol']}${currencyFormat.format(product.price)}';
    final String amountLabel = '${currentCurrency['symbol']}${currencyFormat.format(productData.price)}';
    final double priceFontSize = (84 / amountLabel.length);

    Color primaryColor = Theme.of(context).primaryColor;
    // var foregroundColor = ColorHelper.contrastingColor(primaryColor);
    int userId = 1;

    return FutureBuilder(
        // future: productsData.isFavorite(userId, product.id),
        future: productData.isFavorite(userId),
        builder: (ctx, AsyncSnapshot<bool> snapshot) {
          bool isFavorite;
          if (snapshot.data != null) {
            isFavorite = snapshot.data;
          }

          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Material(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                elevation: 2,
                child: GridTile(
                  child: Stack(
                    children: [
                      // Product Image:
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: GestureDetector(
                          child: Image.network(
                            // product.imageUrl,
                            productData.imageUrl,
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          onTap: () {
                            // selectProduct(context, isFavorite);
                            selectProduct(context, isFavorite, productData);
                          },
                        ),
                      ),

                      // Product Price:
                      ...[
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                            height: 26,
                            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            child: FittedBox(
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
                      ],

                      // Action Buttons (Delete & Edit):
                      ...[
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            height: 26,
                            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Tooltip(
                                    message: 'Delete',
                                    child: GestureDetector(
                                      child: Container(
                                        margin: EdgeInsets.only(right: 8),
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                      ),
                                      // onTap: () => onDeleteProductHandler(product.id, context, userId),
                                      onTap: () => onDeleteProductHandler(productData.id, context, userId),
                                    )),
                                Tooltip(
                                  message: 'Edit',
                                  child: GestureDetector(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 8),
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                    ),
                                    onTap: () {
                                      showModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) => ProductEditScreen(
                                          // product: product,
                                          product: productData,
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

                  // Footer: Favorite icon, Title & Add to cart icon
                  footer: ClipRRect(
                    borderRadius: BorderRadius.only(
                      // topLeft: Radius.circular(10),
                      // topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    child: GridTileBar(
                      backgroundColor: Colors.black38,

                      // Favorite icon:
                      leading: IconButton(
                        // iconSize: 24,
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.yellow : Colors.white,
                          size: 14,
                        ),
                        tooltip: 'Favorite',
                        // onPressed: () => toggleFavorite(userId, product.id),
                        onPressed: () => toggleFavorite(userId),
                      ),

                      // Product Title:
                      title: Text(
                        // product.title,
                        productData.title,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Add to cart icon:
                      trailing: Tooltip(
                        padding: EdgeInsets.all(0),
                        message: 'Add to cart',
                        child: IconButton(
                          padding: EdgeInsets.all(0),
                          icon: Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white,
                            size: 14,
                          ),
                          onPressed: () => {},
                        ),
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
