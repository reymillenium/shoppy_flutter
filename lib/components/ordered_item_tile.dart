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

class OrderedItemTile extends StatelessWidget {
  // Properties:
  final dynamic userId;

  // Constructor:
  OrderedItemTile({
    Key key,
    this.userId,
  }) : super(key: key);

  // Runtime constants:
  final DateFormat dateFormatter = DateFormat().add_yMMMMd(); // July 6, 2021
  final DateFormat timeFormatter = DateFormat().add_jm(); // 12:04 PM
  final currencyFormat = new NumberFormat("#,##0.00", "en_US");

  @override
  Widget build(BuildContext context) {
    OrderedItem orderedItem = Provider.of<OrderedItem>(context, listen: false);

    AppData appData = Provider.of<AppData>(context, listen: false);
    Map currentCurrency = appData.currentCurrency;
    final String priceLabel = '${currentCurrency['symbol']}${currencyFormat.format(NumericHelper.roundDouble(orderedItem.price, 2))}';

    final int quantity = orderedItem.quantity;
    final String quantityLabel = quantity.toString() + ' item${quantity == 1 ? '' : 's'}';

    Color primaryColor = Theme.of(context).primaryColor;

    return Card(
      elevation: 2,
      color: Colors.white70,
      margin: EdgeInsets.only(left: 0, right: 0, top: 4),
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
              // OrderedItem Image:
              leading: CircleAvatar(
                backgroundColor: primaryColor,
                radius: 30,
                backgroundImage: NetworkImage(
                  orderedItem.imageUrl,
                ),
              ),

              // OrderedItem Title:
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    orderedItem.title,
                    style: Theme.of(context).textTheme.headline6,
                    softWrap: true,
                    overflow: TextOverflow.fade,
                  ),
                ],
              ),

              // OrderedItem Price label:
              subtitle: Text(priceLabel),

              // OrderedItem Quantity label:
              trailing: Text(quantityLabel),
            ),
          ),
        ],
      ),
    );
  }
}
