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

class OrderedItemsExpansionList extends StatefulWidget {
  // Properties:
  final int userId;

  // final Order order;

  // Constructor:
  OrderedItemsExpansionList({
    Key key,
    this.userId = 1,
    // this.order,
  }) : super(key: key);

  // Runtime constants:
  final DateFormat dateFormatter = DateFormat().add_yMMMMd(); // July 6, 2021
  final DateFormat timeFormatter = DateFormat().add_jm(); // 12:04 PM
  final currencyFormat = new NumberFormat("#,##0.00", "en_US");

  @override
  _OrderedItemsExpansionListState createState() => _OrderedItemsExpansionListState();
}

class _OrderedItemsExpansionListState extends State<OrderedItemsExpansionList> {
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

    Color primaryColor = Theme.of(context).primaryColor;
    Color accentColor = Theme.of(context).accentColor;

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
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                    unselectedWidgetColor: accentColor, // Color of the arrow icon, when not expanded
                  ),
                  child: ExpansionTile(
                    // tilePadding: EdgeInsets.only(bottom: 10, left: 2),
                    childrenPadding: EdgeInsets.only(bottom: 4),
                    // leading: Text('leading'),
                    title: Row(
                      children: [
                        Text(
                          createdAtDateLabel,
                          style: new TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          createdAtTimeLabel,
                          style: new TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    // subtitle: Text('$priceTotalInOrderedItemsLabel ($quantityTotalInOrderedItemsLabel)'),
                    subtitle: Text(
                      // '$priceTotalInOrderedItemsLabel ($quantityTotalInOrderedItemsLabel)',
                      '$priceTotalInOrderedItemsLabel  /  $quantityTotalInOrderedItemsLabel',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),

                    // children: <Widget>[
                    //   new Column(
                    //     children: buildOrderedItemsTiles(orderedItems),
                    //     // children: [],
                    //   ),
                    // ],

                    // children: buildOrderedItemsTiles(orderedItems),
                    children: [buildOrderedItemsTilesList(orderedItems)],
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

  Widget buildOrderedItemsTilesList(List<OrderedItem> orderedItems) {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 0, top: 0, right: 0),
      controller: _listViewScrollController,
      itemCount: orderedItems.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return ChangeNotifierProvider.value(
            value: orderedItems[index],
            child: OrderedItemTile(
              key: ValueKey(orderedItems[index].id),
              userId: widget.userId,
            ));
      },
    );
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
