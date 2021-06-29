// Packages:
import 'package:shoppy_flutter/components/_components.dart';

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

class CartItemsDetailsHeader extends StatelessWidget {
  // Properties:
  final int userId;

  // Constructor:
  CartItemsDetailsHeader({
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

    ProductsData productsData = Provider.of<ProductsData>(context);

    return FutureBuilder(
        future: Future.wait([
          productsData.thoseInTheCartByUserId(userId),
          productsData.priceTotalAmountInCart(userId),
          productsData.quantityTotalAmountInCart(userId),
        ]),
        builder: (ctx, AsyncSnapshot<List<dynamic>> snapshot) {
          List<Product> productsInTheCart = [];
          double priceTotalAmountInCart = 0;
          int quantityTotalAmountInCart = 0;
          if (snapshot.data != null) {
            productsInTheCart = snapshot.data[0];
            priceTotalAmountInCart = snapshot.data[1];
            quantityTotalAmountInCart = snapshot.data[2];
          }
          int productsInTheCartAmount = productsInTheCart.length;

          // Subtotal:
          double priceTotalAmountInCartRounded = NumericHelper.roundDouble(priceTotalAmountInCart, 2);
          final String priceTotalAmountInCartRoundedLabel = '${currentCurrency['symbol']}${currencyFormat.format(priceTotalAmountInCartRounded)}';
          // Taxes:
          double taxesPercentageFactor = 0.07;
          double taxesAmount = NumericHelper.roundDouble(priceTotalAmountInCart * taxesPercentageFactor, 2);
          final String taxesAmountLabel = '${currentCurrency['symbol']}${currencyFormat.format(taxesAmount)}';
          // Gran Total:
          double grandTotalPriceAmountInCart = NumericHelper.roundDouble(priceTotalAmountInCart, 2) + taxesAmount;
          final String grandTotalPriceAmountInCartLabel = '${currentCurrency['symbol']}${currencyFormat.format(grandTotalPriceAmountInCart)}';

          return Card(
            elevation: 2,
            color: Colors.white70,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white70, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Some data: Tile, price
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Total products in the Cart:
                        Row(
                          children: [
                            Text(
                              'Total products: ',
                              style: Theme.of(context).textTheme.headline6,
                              softWrap: true,
                              overflow: TextOverflow.fade,
                            ),
                            Text(
                              '$productsInTheCartAmount',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),

                        // Total Items in the Cart:
                        Row(
                          children: [
                            Text(
                              'Total items: ',
                              style: Theme.of(context).textTheme.headline6,
                              softWrap: true,
                              overflow: TextOverflow.fade,
                            ),
                            Text(
                              '$quantityTotalAmountInCart',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),

                        // Subtotal & Add to cart button:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Price
                            Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: Text(
                                'Subtotal: $priceTotalAmountInCartRoundedLabel',
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

                        // Taxes:
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Text(
                            'Taxes: $taxesAmountLabel',
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ),

                        // Grand Total:
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Text(
                            'Grand Total: $grandTotalPriceAmountInCartLabel',
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // subtitle: Text(formattedDate),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
