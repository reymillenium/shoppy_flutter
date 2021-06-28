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

class ProductIndexScreen extends StatefulWidget {
  static const String screenId = 'product_index_screen';

  // Properties:
  final String appTitle;

  const ProductIndexScreen({Key key, this.appTitle}) : super(key: key);

  @override
  _ProductIndexScreenState createState() => _ProductIndexScreenState();
}

class _ProductIndexScreenState extends State<ProductIndexScreen> with RouteAware, RouteObserverMixin {
  final String _screenId = ProductIndexScreen.screenId;
  int _activeTab = 0;
  List<String> availableFilters = ["favoriteProducts"];
  List<String> selectedFilters = [];
  final int userId = 1;

  void onApplyButtonClick(list, BuildContext context) {
    if (list != null) {
      setState(() {
        selectedFilters = List.from(list);
      });
    }
    Navigator.pop(context);
  }

  /// Called when the top route has been popped off, and the current route
  /// shows up.
  @override
  void didPopNext() {
    print('didPopNext => Emerges: $_screenId');
    setState(() {
      _activeTab = 0;
    });
  }

  /// Called when the current route has been pushed.
  @override
  void didPush() {
    print('didPush => Arriving to: $_screenId');
    setState(() {
      _activeTab = 0;
    });
  }

  /// Called when the current route has been popped off.
  @override
  void didPop() {
    print('didPop => Popping of: $_screenId');
  }

  /// Called when a new route has been pushed, and the current route is no
  /// longer visible.
  @override
  void didPushNext() {
    print('didPushNext => Covering: $_screenId');
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   print("Back To old Screen");
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    ProductsData productsData = Provider.of<ProductsData>(context);
    List<Product> products = productsData.products;
    int amountTotalProducts = products.length;

    return CustomScaffold(
      activeIndex: _activeTab,
      appTitle: widget.appTitle,
      innerWidgets: [
        // Food Categories Grid:
        if (!selectedFilters.contains('favoriteProducts')) ...[
          Expanded(
            flex: 5,
            child: ProductsGrid(
              products: products,
            ),
          ),
        ] else ...[
          FutureBuilder(
              future: productsData.thoseFavoritesByUserId(userId),
              builder: (ctx, AsyncSnapshot<List<Product>> snapshot) {
                List<Product> products = [];
                if (snapshot.data != null) {
                  products = snapshot.data;
                }
                return Expanded(
                  flex: 5,
                  child: ProductsGrid(
                    products: products,
                  ),
                );
              }),
        ],
      ],
      objectsLength: amountTotalProducts,
      objectName: 'product',
      onPressedBarActionIcon: () => DialogHelper.openFilterDialog(context, availableFilters, selectedFilters, onApplyButtonClick),
      appBarActionIcon: Icons.filter_alt_outlined,
      onPressedFAB: () => _showModalNewProduct(context),
    );
  }

  // It shows the AddTransactionScreen widget as a modal:
  void _showModalNewProduct(BuildContext context) {
    SoundHelper().playSmallButtonClick();
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (context) => ProductNewScreen(),
    );
  }
}
