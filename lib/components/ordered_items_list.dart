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
  // bool _isSwapping = false;

  @override
  Widget build(BuildContext context) {
    Order order = Provider.of<Order>(context, listen: false);
    // OrdersData ordersData = Provider.of<OrdersData>(context, listen: false);
    OrderedItemsData orderedItemsData = Provider.of<OrderedItemsData>(context, listen: false);
    // final String createdAtDateLabel = widget.dateFormatter.format(order.createdAt);
    // final String createdAtTimeLabel = widget.timeFormatter.format(order.createdAt);

    return FutureBuilder(
      future: Future.wait([
        // orderedItemsData.byUserId(widget.userId),
        orderedItemsData.byOrderId(order.id),
      ]),
      builder: (ctx, AsyncSnapshot<List<dynamic>> snapshot) {
        // bool isInCart = false;
        // int quantityAmountInCart = 0;
        List<OrderedItem> orderedItems = [];
        if (snapshot.data != null) {
          // isInCart = snapshot.data[0];
          // quantityAmountInCart = snapshot.data[1];
          orderedItems = snapshot.data[0];
        }

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
              ),
            );
          },
        );
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
