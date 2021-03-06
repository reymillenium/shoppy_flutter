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

class ProductsGrid extends StatelessWidget {
  // Properties:
  final List<Product> products;
  final dynamic userId;
  final bool inFavoriteScreen;

  const ProductsGrid({
    Key key,
    this.products,
    this.userId = 1,
    this.inFavoriteScreen = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return products.isEmpty
        ? CustomEmptyWidget(
            packageImage: 1,
            title: 'We are sorry',
            subTitle: 'There is no products',
          )
        : GridView.builder(
            // gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            //   maxCrossAxisExtent: 200,
            //   childAspectRatio: 3 / 2,
            //   crossAxisSpacing: 10,
            //   mainAxisSpacing: 10,
            // ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            padding: const EdgeInsets.all(10.0),
            itemBuilder: (BuildContext context, int index) {
              // return ProductPanel(
              //   key: ValueKey(products[index].id),
              //   product: products[index],
              // );

              // Return error: A Product was used after being disposed. Once you have called dispose() on a Product, it can no longer be used.
              // return ChangeNotifierProvider(
              //   create: (context) => products[index],
              //   child: ProductGridTile(
              //     key: ValueKey(products[index].id),
              //     // product: products[index],
              //   ),
              // );

              return ChangeNotifierProvider.value(
                value: products[index],
                child: ProductGridTile(
                  key: ValueKey(products[index].id),
                  // product: products[index],
                  userId: userId,
                  inFavoriteScreen: inFavoriteScreen,
                ),
              );
            },
            itemCount: products.length,
          );
  }

  List<ProductPanel> buildProductPanels(List<Product> products) {
    return products
        .map((product) => ProductPanel(
              key: ValueKey(product.id),
              product: product,
            ))
        .toList();
  }
}
