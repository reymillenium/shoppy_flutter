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

class OrderTile extends StatelessWidget {
  // Properties:
  final int userId;

  // Constructor:
  OrderTile({
    Key key,
    this.userId,
  }) : super(key: key);

  // Runtime constants:
  final DateFormat dateFormatter = DateFormat().add_yMMMMd(); // July 6, 2021
  final DateFormat timeFormatter = DateFormat().add_jm(); // 12:04 PM
  final currencyFormat = new NumberFormat("#,##0.00", "en_US");

  @override
  Widget build(BuildContext context) {
    Order order = Provider.of<Order>(context, listen: false);

    AppData appData = Provider.of<AppData>(context, listen: false);
    Map currentCurrency = appData.currentCurrency;
    final String taxesAmountLabel = '${currentCurrency['symbol']}${currencyFormat.format(NumericHelper.roundDouble(order.taxesAmount, 2))}';
    // final double amountFontSize = (84 / perItemPriceLabel.length);
    final String createdAtDateLabel = dateFormatter.format(order.createdAt);
    final String createdAtTimeLabel = timeFormatter.format(order.createdAt);

    Color primaryColor = Theme.of(context).primaryColor;

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
              // Product image:
              // leading: CircleAvatar(
              //   backgroundColor: primaryColor,
              //   radius: 30,
              //   backgroundImage: NetworkImage(
              //     product.imageUrl,
              //   ),
              // ),
              // Order taxesAmountLabel:
              leading: CircleAvatar(
                backgroundColor: primaryColor,
                radius: 30,
                child: Text('$taxesAmountLabel'),
              ),

              // Order title:
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$createdAtDateLabel',
                    style: Theme.of(context).textTheme.headline6,
                    softWrap: true,
                    overflow: TextOverflow.fade,
                  ),
                ],
              ),

              // taxesAmountLabel label:
              subtitle: Text(taxesAmountLabel),

              // CreatedAt Label:
              trailing: Text(createdAtTimeLabel),
            ),
          ),
        ],
      ),
    );
  }
}
