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

class OrdersList extends StatefulWidget {
  // Properties:
  final int userId;
  final List<Order> orders;

  // Constructor:
  OrdersList({
    Key key,
    this.userId = 1,
    this.orders,
  }) : super(key: key);

  @override
  _OrdersListState createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  final _listViewScrollController = ScrollController();
  bool _isSwapping = false;

  @override
  Widget build(BuildContext context) {
    // ProductsData productsData = Provider.of<ProductsData>(context, listen: false);

    return ListView.builder(
      padding: const EdgeInsets.only(left: 0, top: 0, right: 0),
      controller: _listViewScrollController,
      itemCount: widget.orders.length,
      itemBuilder: (BuildContext context, int index) {
        return ChangeNotifierProvider.value(
          value: widget.orders[index],
          child: OrderTile(
            key: ValueKey(widget.orders[index].id),
            userId: widget.userId,
          ),
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
