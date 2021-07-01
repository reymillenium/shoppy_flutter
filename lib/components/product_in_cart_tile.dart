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

class ProductInCartTile extends StatelessWidget {
  // Properties:
  final int userId;

  // Constructor:
  ProductInCartTile({
    Key key,
    this.userId,
  }) : super(key: key);

  // Runtime constants:
  final DateFormat formatter = DateFormat().add_yMMMMd();
  final currencyFormat = new NumberFormat("#,##0.00", "en_US");

  @override
  Widget build(BuildContext context) {
    Product product = Provider.of<Product>(context, listen: false);

    AppData appData = Provider.of<AppData>(context, listen: true);
    Map currentCurrency = appData.currentCurrency;
    final String perItemPriceLabel = '${currentCurrency['symbol']}${currencyFormat.format(NumericHelper.roundDouble(product.price, 2))}';
    // final double amountFontSize = (84 / perItemPriceLabel.length);

    Color primaryColor = Theme.of(context).primaryColor;
    var uuid = Uuid();
    ProductsData productsData = Provider.of<ProductsData>(context, listen: false);
    Function removeFromCart = (userId, productId) => productsData.removeFromCart(userId, productId);

    // return Dismissible(
    //   // Shows error: A dismissed Dismissible widget is still part of the tree.
    //   // but does not blinks when adding or decreasing quantity
    //   key: key,
    //   // Shows error: A dismissed Dismissible widget is still part of the tree.
    //   // but does not blinks when adding or decreasing quantity
    //   // key: ValueKey(product.id),
    //   // Shows error: A dismissed Dismissible widget is still part of the tree.
    //   // but does not blinks when adding or decreasing quantity
    //   // key: ValueKey(key),
    //   // Error: It blinks when adding or decreasing quantity
    //   // But does not shows error: A dismissed Dismissible widget is still part of the tree.
    //   // key: UniqueKey(),
    //   // Error: It blinks when adding or decreasing quantity
    //   // But does not shows error: A dismissed Dismissible widget is still part of the tree.
    //   // key: ValueKey(UniqueKey()),
    //   // Error: It blinks when adding or decreasing quantity
    //   // But does not shows error: A dismissed Dismissible widget is still part of the tree.
    //   // key: ValueKey(uuid.v4()),
    //   // Error: It blinks when adding or decreasing quantity
    //   // But does not shows error: A dismissed Dismissible widget is still part of the tree.
    //   // key: ValueKey(uuid.v1()),
    //   // Test: Nope
    //   // key: Key(product.id.toString()),
    //
    //   background: Container(
    //     child: Icon(
    //       Icons.delete,
    //       color: Colors.white,
    //       size: 32,
    //     ),
    //     alignment: Alignment.centerRight,
    //     padding: EdgeInsets.only(right: 20),
    //     margin: EdgeInsets.only(left: 8, right: 8, top: 4),
    //     decoration: BoxDecoration(
    //       color: Theme.of(context).errorColor,
    //       borderRadius: BorderRadius.only(
    //         topLeft: Radius.circular(10),
    //         topRight: Radius.circular(10),
    //         bottomLeft: Radius.circular(20),
    //         bottomRight: Radius.circular(20),
    //       ),
    //     ),
    //   ),
    //   onDismissed: (DismissDirection direction) {
    //     removeFromCart(userId, product.id);
    //   },
    //   child: Card(
    //     elevation: 2,
    //     color: Colors.white70,
    //     margin: EdgeInsets.only(left: 8, right: 8, top: 4),
    //     shape: RoundedRectangleBorder(
    //       side: BorderSide(color: Colors.white70, width: 1),
    //       borderRadius: BorderRadius.only(
    //         topLeft: Radius.circular(10),
    //         topRight: Radius.circular(10),
    //         bottomLeft: Radius.circular(20),
    //         bottomRight: Radius.circular(20),
    //       ),
    //     ),
    //     child: Column(
    //       children: [
    //         Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: ListTile(
    //             leading: CircleAvatar(
    //               backgroundColor: primaryColor,
    //               radius: 30,
    //               backgroundImage: NetworkImage(
    //                 product.imageUrl,
    //               ),
    //             ),
    //             title: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Text(
    //                   product.title,
    //                   style: Theme.of(context).textTheme.headline6,
    //                   softWrap: true,
    //                   overflow: TextOverflow.fade,
    //                 ),
    //               ],
    //             ),
    //             subtitle: Text(perItemPriceLabel),
    //             trailing: AddProductToCartSmallButton(
    //               key: ValueKey(product.id),
    //               // key: UniqueKey(),
    //               // key: widget.key,
    //               // userId: widget.userId,
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );

    return Card(
      elevation: 2,
      color: Colors.white70,
      margin: EdgeInsets.only(left: 8, right: 8, top: 4),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: primaryColor,
                radius: 30,
                backgroundImage: NetworkImage(
                  product.imageUrl,
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: Theme.of(context).textTheme.headline6,
                    softWrap: true,
                    overflow: TextOverflow.fade,
                  ),
                ],
              ),
              subtitle: Text(perItemPriceLabel),
              trailing: AddProductToCartSmallButton(),
            ),
          ),
        ],
      ),
    );
  }
}
