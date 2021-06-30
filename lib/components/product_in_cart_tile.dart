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

  // final int id;
  // final int index;

  // Constructor:
  ProductInCartTile({
    Key key,
    this.userId,
    // this.id,
    // this.index,
  }) : super(key: key);

  // Runtime constants:
  final DateFormat formatter = DateFormat().add_yMMMMd();
  final currencyFormat = new NumberFormat("#,##0.00", "en_US");

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context, listen: true);
    Product product = Provider.of<Product>(context);

    Map currentCurrency = appData.currentCurrency;
    final String perItemPriceLabel = '${currentCurrency['symbol']}${currencyFormat.format(NumericHelper.roundDouble(product.price, 2))}';
    // final double amountFontSize = (84 / perItemPriceLabel.length);
    Color primaryColor = Theme.of(context).primaryColor;

    return Card(
      elevation: 2,
      color: Colors.white70,
      // margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white70, width: 1),
        // side: BorderSide(color: Colors.red, width: 1),
        // borderRadius: BorderRadius.circular(10),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // ListTile with data: title, duration and date
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              // visualDensity: VisualDensity.standard,
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
              // subtitle: Text('testing'),
              trailing: AddProductToCartSmallButton(),
            ),
          ),
        ],
      ),
    );
  }
}
