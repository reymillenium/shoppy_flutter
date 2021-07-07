// Packages:
import 'package:shoppy_flutter/components/ordered_items_list.dart';

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

class OrdersExpansionPanelList extends StatelessWidget {
  // Properties:
  final List<Order> orders;

  OrdersExpansionPanelList({
    Key key,
    this.orders,
  }) : super(key: key);

  // Runtime constants:
  final DateFormat dateFormatter = DateFormat().add_yMMMMd(); // July 6, 2021
  final DateFormat timeFormatter = DateFormat().add_jm(); // 12:04 PM

  @override
  Widget build(BuildContext context) {
    // return ExpansionPanelList(
    //   expansionCallback: openOnePanelAndCloseTheRest,
    //   children: [
    //     // Expansion Panel # 1: Theme colors
    //     ExpansionPanel(
    //       canTapOnHeader: true,
    //       headerBuilder: (BuildContext context, bool isExpanded) {
    //         return ListTile(
    //           leading: Icon(
    //             Icons.palette,
    //             color: Colors.black,
    //           ),
    //           title: Text(
    //             'Theme:',
    //             style: TextStyle(
    //               color: Colors.black,
    //               fontSize: 20,
    //               fontWeight: FontWeight.bold,
    //             ),
    //           ),
    //         );
    //       },
    //       body: Column(
    //         children: availableThemeColors.asMap().entries.map((entry) {
    //           int index = entry.key;
    //           Map value = entry.value;
    //           // Each Theme Color List Tile:
    //           return ListTile(
    //             title: Text(
    //               value['name'],
    //               style: TextStyle(
    //                 color: value['theme']['primaryColor'],
    //                 fontSize: 16,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             ),
    //             onTap: () {
    //               setCurrentThemeColorHandler(index);
    //               // closeAllThePanels();
    //               // Navigator.pop(context);
    //             },
    //             tileColor: _getActiveTileColor(currentThemeColors['name'], value['name']),
    //           );
    //         }).toList(),
    //       ),
    //       isExpanded: expansionPanelListStatus[0]['isOpened'],
    //     ),
    //   ],
    // );

    return ListView.builder(
      itemCount: orders.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final String createdAtDateLabel = dateFormatter.format(orders[index].createdAt);
        final String createdAtTimeLabel = timeFormatter.format(orders[index].createdAt);

        return ExpansionTile(
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

            ChangeNotifierProvider.value(
              value: orders[index],
              child: OrderedItemsList(
                userId: 1,
                // order: orders[index],
                key: ValueKey(orders[index].id),
              ),
            ),
          ],
        );
      },
    );
  }

  // _buildExpandableContent(Order order) {
  //   List<Widget> columnContent = [];
  //
  //   for (String content in orderedItem.contents)
  //     columnContent.add(
  //       new ListTile(
  //         // Product image:
  //         // leading: CircleAvatar(
  //         //   backgroundColor: primaryColor,
  //         //   radius: 30,
  //         //   backgroundImage: NetworkImage(
  //         //     product.imageUrl,
  //         //   ),
  //         // ),
  //         // Order taxesAmountLabel:
  //         leading: CircleAvatar(
  //           backgroundColor: primaryColor,
  //           radius: 30,
  //           child: Text('$taxesAmountLabel'),
  //         ),
  //
  //         // Order title:
  //         title: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               '$createdAtDateLabel',
  //               style: Theme.of(context).textTheme.headline6,
  //               softWrap: true,
  //               overflow: TextOverflow.fade,
  //             ),
  //           ],
  //         ),
  //
  //         // taxesAmountLabel label:
  //         subtitle: Text(taxesAmountLabel),
  //
  //         // CreatedAt Label:
  //         trailing: Text(createdAtTimeLabel),
  //       ),
  //     );
  //
  //   return columnContent;
  // }
}
