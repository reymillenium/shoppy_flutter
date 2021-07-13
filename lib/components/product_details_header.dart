// Packages:
import 'package:shoppy_flutter/components/_components.dart';

import '../_inner_packages.dart';
import '../_external_packages.dart';

// Screens:
// import '../screens/_screens.dart';

// Models:
import '../models/_models.dart';

// Components:
// import '../components/_components.dart';

// Helpers:
// import '../helpers/_helpers.dart';

// Utilities:
// import '../utilities/_utilities.dart';

class ProductDetailsHeader extends StatelessWidget {
  // Properties:
  final int userId;

  // Constructor:
  ProductDetailsHeader({
    Key key,
    this.userId,
  }) : super(key: key);

  // Runtime constants:
  final DateFormat formatter = DateFormat().add_yMMMMd();
  final currencyFormat = new NumberFormat("#,##0.00", "en_US");

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);
    Map currentCurrency = appData.currentCurrency;

    Product product = Provider.of<Product>(context, listen: false);

    final String formattedDate = formatter.format(product.createdAt);
    final String amountLabel = '${currentCurrency['symbol']}${currencyFormat.format(product.price)}';

    return Card(
      elevation: 2,
      color: Colors.white70,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Product Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
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
                  top: 20,
                  right: 10,
                  child: FavoriteProductBigButton(userId: userId),
                ),
              ],
            ],
          ),

          // Some data: Tile, price
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    product.title,
                    style: Theme.of(context).textTheme.headline6,
                    softWrap: true,
                    overflow: TextOverflow.fade,
                  ),

                  // Nested Row with Price & Add to cart button:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Product price:
                      Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: Text(
                          '$amountLabel',
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      ),

                      // Add to cart button:
                      ChangeNotifierProvider.value(
                        value: product,
                        child: AddProductToCartSmallButton(
                          userId: userId,
                          listenProductsData: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Created_at field:
              subtitle: Text(formattedDate),
            ),
          ),
        ],
      ),
    );
  }
}
