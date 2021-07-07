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

class OrderedItemsList extends StatefulWidget {
  // Properties:
  final int userId;

  // final Order order;

  // Constructor:
  OrderedItemsList({
    Key key,
    this.userId = 1,
    // this.order,
  }) : super(key: key);

  // Runtime constants:
  final DateFormat dateFormatter = DateFormat().add_yMMMMd(); // July 6, 2021
  final DateFormat timeFormatter = DateFormat().add_jm(); // 12:04 PM
  final currencyFormat = new NumberFormat("#,##0.00", "en_US");

  @override
  _OrderedItemsListState createState() => _OrderedItemsListState();
}

class _OrderedItemsListState extends State<OrderedItemsList> {
  final _listViewScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context, listen: false);
    Map currentCurrency = appData.currentCurrency;

    Order order = Provider.of<Order>(context, listen: false);

    OrderedItemsData orderedItemsData = Provider.of<OrderedItemsData>(context, listen: false);
    final String createdAtDateLabel = widget.dateFormatter.format(order.createdAt);
    final String createdAtTimeLabel = widget.timeFormatter.format(order.createdAt);

    OrdersData ordersData = Provider.of<OrdersData>(context, listen: false);

    return FutureBuilder(
      future: Future.wait([
        orderedItemsData.byOrderId(order.id),
        ordersData.priceTotalInOrderedItems(widget.userId, order.id),
        ordersData.quantityTotalInOrderedItems(widget.userId, order.id),
      ]),
      builder: (ctx, AsyncSnapshot<List<dynamic>> snapshot) {
        List<OrderedItem> orderedItems = [];
        double priceTotalInOrderedItems = 0;
        int quantityTotalInOrderedItems = 0;
        if (snapshot.data != null) {
          orderedItems = snapshot.data[0];
          priceTotalInOrderedItems = snapshot.data[1];
          quantityTotalInOrderedItems = snapshot.data[2];
        }

        final String priceTotalInOrderedItemsLabel = '${currentCurrency['symbol']}${widget.currencyFormat.format(NumericHelper.roundDouble(priceTotalInOrderedItems, 2))}';
        final String quantityTotalInOrderedItemsLabel = quantityTotalInOrderedItems.toString() + ' item${quantityTotalInOrderedItems == 1 ? '' : 's'}';

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
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    // tilePadding: EdgeInsets.only(bottom: 10, left: 2),
                    childrenPadding: EdgeInsets.only(bottom: 4),
                    // leading: Text('leading'),
                    title: Row(
                      children: [
                        Text(
                          createdAtDateLabel,
                          style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          createdAtTimeLabel,
                          style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                    subtitle: Text(priceTotalInOrderedItemsLabel),

                    trailing: Text('$quantityTotalInOrderedItemsLabel'),

                    children: <Widget>[
                      // new Column(
                      //   children: _buildExpandableContent(orders[index]),
                      // ),
                      // new Column(children: [
                      //   ChangeNotifierProvider.value(
                      //     value: orders[index],
                      //     child: OrderTile(
                      //       key: ValueKey(orders[index].id),
                      //       userId: 1,
                      //     ),
                      //   ),
                      // ]),

                      // ChangeNotifierProvider.value(
                      //   value: orders[index],
                      //   child: OrderedItemsList(
                      //     userId: 1,
                      //     // order: orders[index],
                      //     key: ValueKey(orders[index].id),
                      //   ),
                      // ),
                      new Column(
                        children: buildOrderedItemsTiles(orderedItems),
                        // children: [],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> buildOrderedItemsTiles(List<OrderedItem> orderedItems) {
    List<Widget> orderedItemsTiles = [];
    orderedItemsTiles = orderedItems
        .map((orderedItem) => ChangeNotifierProvider.value(
            value: orderedItem,
            child: OrderedItemTile(
              key: ValueKey(orderedItem.id),
              userId: widget.userId,
            )))
        .toList();

    return orderedItemsTiles;
  }

  int findChildIndexCallback(Key key, List<Order> orders) {
    final ValueKey valueKey = key as ValueKey;
    final int id = valueKey.value;
    Order order;
    try {
      order = orders.firstWhere((order) => id == order.id);
    } catch (e) {
      return null;
    }
    return orders.indexOf(order);
  }
}
