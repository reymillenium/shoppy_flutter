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

class ProductsInCartList extends StatelessWidget {
  // Properties:
  final _listViewScrollController = ScrollController();
  final int userId;

  // Constructor:
  ProductsInCartList({
    Key key,
    this.userId = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProductsData productsData = Provider.of<ProductsData>(context);
    Function removeFromCart = (userId, productId) => productsData.removeFromCart(userId, productId);

    return FutureBuilder(
        future: Future.wait([
          productsData.thoseInTheCartByUserId(userId),
        ]),
        builder: (ctx, snapshot) {
          List<Product> productsInTheCart = [];
          if (snapshot.data != null) {
            productsInTheCart = snapshot.data[0];
          }

          // Preserves the state:
          // return ListView.custom(
          //   padding: const EdgeInsets.only(left: 0, top: 0, right: 0),
          //   controller: _listViewScrollController,
          //   childrenDelegate: SliverChildBuilderDelegate(
          //     (BuildContext context, int index) {
          //       return ChangeNotifierProvider.value(
          //         value: productsInTheCart[index],
          //         child: ProductInCartTile(
          //           key: ValueKey(productsInTheCart[index].id),
          //           userId: userId,
          //         ),
          //       );
          //     },
          //     childCount: productsInTheCart.length,
          //     // This callback method is what allows to preserve the state:
          //     findChildIndexCallback: (Key key) => findChildIndexCallback(key, productsInTheCart),
          //   ),
          // );

          // Preserves the state ?:
          // return ListView.builder(
          //   padding: const EdgeInsets.only(left: 0, top: 0, right: 0),
          //   controller: _listViewScrollController,
          //   itemCount: productsInTheCart.length,
          //   itemBuilder: (BuildContext context, int index) {
          //     return ChangeNotifierProvider.value(
          //       value: productsInTheCart[index],
          //       child: ProductInCartTile(
          //         // key: ValueKey(productsInTheCart[index].id),
          //         key: UniqueKey(),
          //         userId: userId,
          //       ),
          //     );
          //   },
          // );

          return ListView.builder(
            padding: const EdgeInsets.only(left: 0, top: 0, right: 0),
            controller: _listViewScrollController,
            itemCount: productsInTheCart.length,
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                // Not blinking, but shows error:
                // key: ValueKey(productsInTheCart[index].id),
                // Not initial error, but shows blinking:
                key: UniqueKey(),
                background: Container(
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 32,
                  ),
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20),
                  margin: EdgeInsets.only(left: 8, right: 8, top: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).errorColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                ),
                onDismissed: (DismissDirection direction) {
                  removeFromCart(userId, productsInTheCart[index].id);
                },
                child: ChangeNotifierProvider.value(
                  value: productsInTheCart[index],
                  child: ProductInCartTile(
                    key: ValueKey(productsInTheCart[index].id),
                    // key: UniqueKey(),
                    userId: userId,
                  ),
                ),
              );
            },
          );

          // );
        }
        // },
        );
  }

  // This callback method is what allows to preserve the state:
  int findChildIndexCallback(Key key, List<Product> productsInTheCart) {
    final ValueKey valueKey = key as ValueKey;
    final int id = valueKey.value;
    Product product;
    try {
      product = productsInTheCart.firstWhere((productInTheCart) => id == productInTheCart.id);
    } catch (e) {
      return null;
    }
    return productsInTheCart.indexOf(product);
  }
}
