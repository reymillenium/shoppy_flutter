// Packages:
import '../_inner_packages.dart';
import '../_external_packages.dart';
// Screens:

// Models:
import '../models/_models.dart';
// Components:
import './_components.dart';
// Helpers:
import '../helpers/_helpers.dart';
// Utilities:

class ProductsList extends StatelessWidget {
  // Properties:
  final _listViewScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    ProductsData productsData = Provider.of<ProductsData>(context, listen: true);
    List<Product> products = productsData.products;

    return Container(
      child: products.isEmpty
          ? CustomEmptyWidget(
              packageImage: 1,
              title: 'We are sorry',
              subTitle: 'There is no categories',
            )
          : ListView.custom(
              padding: const EdgeInsets.only(left: 0, top: 0, right: 0),
              controller: _listViewScrollController,
              childrenDelegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return ProductTile(
                    key: ValueKey(products[index].id),
                    id: products[index].id,
                    index: index,
                    product: products[index],
                  );
                },
                childCount: products.length,

                // This callback method is what allows to preserve the state:
                findChildIndexCallback: (Key key) => findChildIndexCallback(key, products),
              ),
            ),
    );
  }

  // This callback method is what allows to preserve the state:
  int findChildIndexCallback(Key key, List<Product> products) {
    final ValueKey valueKey = key as ValueKey;
    final int id = valueKey.value;
    // final int id = int.parse(productWidgetID.substring(0, 12));
    Product product;
    try {
      product = products.firstWhere((product) => id == product.id);
    } catch (e) {
      return null;
    }
    return products.indexOf(product);
  }
}
