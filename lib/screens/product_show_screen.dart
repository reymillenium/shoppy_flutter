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

class ProductShowScreen extends StatefulWidget {
  static const String screenId = 'food_product_show_screen';

  // Properties:
  final Product product;

  const ProductShowScreen({
    Key key,
    this.product,
  }) : super(key: key);

  @override
  _ProductShowScreenState createState() => _ProductShowScreenState();
}

class _ProductShowScreenState extends State<ProductShowScreen> with RouteAware, RouteObserverMixin {
  // State Properties:
  Product _product;
  final String _screenId = ProductShowScreen.screenId;
  int _activeTab = 0;
  List<String> availableFilters = ["isGlutenFree", "isLactoseFree", "isVegan", "isVegetarian"];
  List<String> selectedFilters = [];

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
  void initState() {
    // TODO: implement initState
    super.initState();
    _product = widget.product;
  }

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
    FoodRecipesData foodRecipesData = Provider.of<FoodRecipesData>(context, listen: true);
    FavoriteFoodRecipesData favoriteFoodRecipesData = Provider.of<FavoriteFoodRecipesData>(context, listen: true);

    return FutureBuilder(
        // future: foodRecipesData.byProduct(_product, filtersList: selectedFilters),
        future: Future.wait([foodRecipesData.byProduct(_product, filtersList: selectedFilters), favoriteFoodRecipesData.byUserId(1)]),
        builder: (ctx, AsyncSnapshot<List<dynamic>> snapshot) {
          List<FoodRecipe> foodRecipes;
          List<FavoriteFoodRecipe> favoriteFoodRecipes;
          if (snapshot.data != null) {
            foodRecipes = snapshot.data[0] ?? [];
            favoriteFoodRecipes = snapshot.data[1] ?? [];
          }

          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return foodRecipes.isEmpty
                  ? CustomScaffold(
                      activeIndex: _activeTab,
                      appTitle: _product.title,
                      innerWidgets: [
                        CustomEmptyWidget(
                          packageImage: 1,
                          title: 'We are sorry',
                          subTitle: 'There is no recipes',
                        ),
                      ],
                      objectsLength: 0,
                      objectName: 'recipe',
                      appBarActionIcon: Icons.filter_alt_outlined,
                      iconFAB: FontAwesomeIcons.question,
                      onPressedBarActionIcon: () => _openFilterDialog(context),
                      onPressedFAB: () => _showModalNewFoodRecipe(context),
                    )
                  : CustomScaffold(
                      activeIndex: _activeTab,
                      appTitle: _product.title,
                      innerWidgets: [
                        // Expanded(
                        //   flex: 5,
                        //   child: FoodRecipesList(
                        //     selectedFilters: selectedFilters,
                        //     foodRecipes: foodRecipes,
                        //     favoriteFoodRecipes: favoriteFoodRecipes,
                        //     pageStorageKey: _product.id.toString(),
                        //   ),
                        // ),
                      ],
                      objectsLength: foodRecipes.length,
                      objectName: 'recipe',
                      appBarActionIcon: Icons.filter_alt_outlined,
                      onPressedBarActionIcon: () => _openFilterDialog(context),
                      onPressedFAB: () => _showModalNewFoodRecipe(context),
                    );
            default:
              return CustomScaffold(
                activeIndex: _activeTab,
                appTitle: _product.title,
                innerWidgets: [
                  CustomEmptyWidget(
                    packageImage: 1,
                    title: 'We are sorry',
                    subTitle: 'There is no recipes',
                  ),
                ],
                objectsLength: 0,
                objectName: 'recipe',
                appBarActionIcon: Icons.filter_alt_outlined,
                iconFAB: FontAwesomeIcons.question,
                onPressedBarActionIcon: () => _openFilterDialog(context),
                onPressedFAB: () => _showModalNewFoodRecipe(context),
              );
          }
        });
  }

  void _showModalNewFoodRecipe(BuildContext context) {
    SoundHelper().playSmallButtonClick();
    // showModalBottomSheet(
    //   backgroundColor: Colors.transparent,
    //   isScrollControlled: true,
    //   context: context,
    //   builder: (context) => FoodRecipeNewScreen(),
    // );
  }
}

// Argument class to receive the arguments sent on the route settings arguments parameter:
class ProductShowScreenArguments {
  final Product product;

  ProductShowScreenArguments(
    this.product,
  );
}
