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
  const ProductsGrid({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProductsData productsData = Provider.of<ProductsData>(context, listen: true);
    List<Product> products = productsData.products;

    return products.isEmpty
        ? CustomEmptyWidget(
            packageImage: 1,
            title: 'We are sorry',
            subTitle: 'There is no categories',
          )
        : GridView(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            padding: EdgeInsets.all(10),
            children: buildProductPanels(products),
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
