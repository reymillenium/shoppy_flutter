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
  final int userId;
  final bool inFavoriteScreen;

  ProductGridTile({
    Key key,
    this.userId = 1,
    this.inFavoriteScreen = false,
  }) : super(key: key);

  // Runtime constants:
  final DateFormat formatter = DateFormat().add_yMMMMd();
  final currencyFormat = new NumberFormat("#,##0.00", "en_US");

  void selectProduct(BuildContext context, Product product, int userId) {
    Navigator.pushNamed(context, ProductShowScreen.screenId, arguments: {'product': product, 'userId': userId});
  }

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);
    Map currentCurrency = appData.currentCurrency;

    ProductsData productsData = Provider.of<ProductsData>(context);
    Function onDeleteProductHandler = (productId, context, userId) => productsData.deleteProductWithConfirm(productId, context, userId);

    Product productData = Provider.of<Product>(context, listen: false);
    // Function toggleFavorite = (userId) => productData.toggleFavorite(userId);

    final String amountLabel = '${currentCurrency['symbol']}${currencyFormat.format(productData.price)}';
    final double priceFontSize = (84 / amountLabel.length);

    Color primaryColor = Theme.of(context).primaryColor;

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
                  productData.imageUrl,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                onTap: () {
                  selectProduct(context, productData, userId);
                },
              ),
            ),

            // Product Price:
            ...[
              Positioned(
                top: 0,
                left: 0,
                child: AddProductToCartUpperLeftStyled(),
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
                    color: Colors.black26,
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
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          child: GridTileBar(
            backgroundColor: Colors.black26,

            // Favorite icon:
            leading: FavoriteProductSmallButton(
              userId: userId,
              inFavoriteScreen: inFavoriteScreen,
            ),

            // Product Title:
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productData.title,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                FittedBox(
                  child: Text(
                    '$amountLabel',
                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
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
}
