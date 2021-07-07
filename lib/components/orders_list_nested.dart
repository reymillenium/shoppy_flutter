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

class OrdersListNested extends StatelessWidget {
  // Properties:
  final List<Order> orders;
  final _listViewScrollController = ScrollController();

  OrdersListNested({
    Key key,
    this.orders,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 0, top: 0, right: 0),
      controller: _listViewScrollController,
      itemCount: orders.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return ChangeNotifierProvider.value(
          value: orders[index],
          child: OrderedItemsExpansionList(
            userId: 1,
            key: ValueKey(orders[index].id),
          ),
        );
      },
    );
  }
}
