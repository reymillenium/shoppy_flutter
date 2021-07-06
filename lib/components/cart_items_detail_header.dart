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
  final int productsInTheCartAmount;
  final double priceTotalAmountInCart;
  final int quantityTotalAmountInCart;
  final List<CartItem> cartItems;

  // Constructor:
  CartItemsDetailsHeader({
    Key key,
    this.userId,
    this.productsInTheCartAmount,
    this.priceTotalAmountInCart,
    this.quantityTotalAmountInCart,
    this.cartItems,
  }) : super(key: key);

  // Runtime constants:
  final DateFormat formatter = DateFormat().add_yMMMMd();
  final currencyFormat = new NumberFormat("#,##0.00", "en_US");

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);
    Map currentCurrency = appData.currentCurrency;
    OrdersData ordersData = Provider.of<OrdersData>(context, listen: false);
    Function addOrder = (userId, taxesAmount, cartItems) => ordersData.addOrder(userId: userId, taxesAmount: taxesAmount, cartItems: cartItems);

    ProductsData productsData = Provider.of<ProductsData>(context, listen: false);
    Function removeAllFromCart = (userId, cartItems) => productsData.removeAllFromCart(userId, cartItems);

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

    var verticalDivider = VerticalDivider(
      color: Colors.black54,
      width: 12,
      indent: 0,
      endIndent: 0,
      thickness: 2,
    );

    return Card(
      elevation: 2,
      color: Colors.white70,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Section: Total of Products, Items & Order Button:
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Total of different products in the Cart:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: Text(
                          'Products: ',
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Text(
                          '$productsInTheCartAmount',
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Total of Items in the Cart:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: Text(
                          'Items: ',
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Text(
                          '$quantityTotalAmountInCart',
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Order button:
                  ElevatedButton(
                    onPressed: () {
                      addOrder(userId, taxesAmount, cartItems).then((value) {
                        removeAllFromCart(userId, cartItems);
                      });
                    },
                    // style: TextButton.styleFrom(
                    //   padding: const EdgeInsets.all(2.0),
                    //   primary: Colors.white,
                    //   textStyle: const TextStyle(fontSize: 14),
                    // ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          // Icons.shopping_cart_outlined,
                          FontAwesomeIcons.shippingFast,
                          color: Colors.white,
                          size: 14,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'ORDER NOW',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Vertical Divider:
          Container(
            // width: 20,
            height: 80,
            // padding: EdgeInsets.all(8),
            child: verticalDivider,
          ),

          // Right Section: Subtotal, Taxes & Gran Total:
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Subtotal
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: Text(
                          'Subtotal: ',
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Text(
                          '$priceTotalAmountInCartRoundedLabel',
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Taxes:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: Text(
                          'Taxes: ',
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Text(
                          '$taxesAmountLabel',
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Divider(
                    color: Colors.black54,
                    height: 12,
                    indent: 0,
                    endIndent: 0,
                    thickness: 2,
                  ),

                  // Grand Total:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: Text(
                          'Grand Total: ',
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Text(
                          '$grandTotalPriceAmountInCartLabel',
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
