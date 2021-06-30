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

    return FutureBuilder(
        future: Future.wait([
          productsData.thoseInTheCartByUserId(userId),
          // productsData.priceTotalAmountInCart(widget.userId),
        ]),
        builder: (ctx, snapshot) {
          List<Product> productsInTheCart = [];
          // double priceTotalAmountInCart = 0;
          if (snapshot.data != null) {
            productsInTheCart = snapshot.data[0];
            // priceTotalAmountInCart = snapshot.data[1];
          }

          // Preserves the state:
          return ListView.custom(
            padding: const EdgeInsets.only(left: 0, top: 0, right: 0),
            controller: _listViewScrollController,
            childrenDelegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return ChangeNotifierProvider.value(
                  value: productsInTheCart[index],
                  child: ProductInCartTile(
                    key: ValueKey(productsInTheCart[index].id),
                    userId: userId,
                  ),
                );
              },
              childCount: productsInTheCart.length,
              // This callback method is what allows to preserve the state:
              findChildIndexCallback: (Key key) => findChildIndexCallback(key, productsInTheCart),
            ),
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
