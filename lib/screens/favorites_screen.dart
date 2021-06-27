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

class FavoritesScreen extends StatefulWidget {
  static const String screenId = 'favorites_screen';

  const FavoritesScreen({Key key}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> with RouteAware, RouteObserverMixin {
  final String _screenId = FavoritesScreen.screenId;
  int _activeTab = 1;
  List<String> availableFilters = ["isGlutenFree", "isLactoseFree", "isVegan", "isVegetarian"];
  List<String> selectedFilters = [];

  /// Called when the top route has been popped off, and the current route
  /// shows up.
  @override
  void didPopNext() {
    print('didPopNext => Emerges: $_screenId');
    setState(() {
      _activeTab = 1;
    });
  }

  /// Called when the current route has been pushed.
  @override
  void didPush() {
    print('didPush => Arriving to: $_screenId');
    setState(() {
      _activeTab = 1;
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

  void _openFilterDialog(BuildContext context) async {
    await FilterListDialog.display<String>(
      context,
      listData: availableFilters,
      selectedListData: selectedFilters,
      height: 300,
      headlineText: "Show me the Food Recipes:",
      searchFieldHintText: "Search Here",
      choiceChipLabel: (item) {
        return item.toCamelCase.readable;
      },
      validateSelectedItem: (list, val) {
        return list.contains(val);
      },
      onItemSearch: (list, text) {
        if (list.any((element) => element.toLowerCase().contains(text.toLowerCase().removeWhiteSpaces))) {
          return list.where((element) => element.toLowerCase().contains(text.toLowerCase().removeWhiteSpaces)).toList();
        } else {
          return [];
        }
      },
      onApplyButtonClick: (list) {
        if (list != null) {
          setState(() {
            selectedFilters = List.from(list);
          });
        }
        Navigator.pop(context);
      },
      useRootNavigator: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    ProductsData productsData = Provider.of<ProductsData>(context);
    // FavoriteProductsData favoriteProductsData = Provider.of<FavoriteProductsData>(context);
    int userId = 1;

    return FutureBuilder(
        future: productsData.thoseFavoritesByUserId(userId, filtersList: selectedFilters),
        // future: Future.wait([productsData.thoseFavoritesByUserId(userId, filtersList: selectedFilters)]),
        builder: (ctx, AsyncSnapshot<List<dynamic>> snapshot) {
          List<Product> products = [];
          if (snapshot.data != null) {
            products = snapshot.data ?? [];
            // products = snapshot.data[0] ?? [];
          }

          return CustomScaffold(
            activeIndex: _activeTab,
            appTitle: 'Favorite Products',
            innerWidgets: [
              Expanded(
                flex: 5,
                child: ProductsGrid(
                  products: products,
                  inFavoriteScreen: true,
                ),
              ),
            ],
            objectsLength: products.length,
            objectName: 'product',
            appBarActionIcon: Icons.filter_alt_outlined,
            onPressedBarActionIcon: () => _openFilterDialog(context),
            onPressedFAB: () => _showModalNewFavorite(context),
          );
        });
  }

  void _showModalNewFavorite(BuildContext context) {
    SoundHelper().playSmallButtonClick();
    // showModalBottomSheet(
    //   backgroundColor: Colors.transparent,
    //   isScrollControlled: true,
    //   context: context,
    //   builder: (context) => FoodRecipeNewScreen(),
    // );
  }
}
