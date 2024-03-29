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

class CartItemIndexScreen extends StatefulWidget {
  static const String screenId = 'cart_item_index_screen';

  // Properties:
  final String appTitle;
  final dynamic userId;

  const CartItemIndexScreen({
    Key key,
    this.appTitle,
    this.userId = 1,
  }) : super(key: key);

  @override
  _CartItemIndexScreenState createState() => _CartItemIndexScreenState();
}

class _CartItemIndexScreenState extends State<CartItemIndexScreen> with RouteAware, RouteObserverMixin {
  // State Properties:
  // Product _product;

  final String _screenId = CartItemIndexScreen.screenId;
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
    // _product = widget.product;
  }

  void _openFilterDialog(BuildContext context) async {
    await FilterListDialog.display<String>(
      context,
      listData: availableFilters,
      selectedListData: selectedFilters,
      height: 300,
      headlineText: "Show me the products:",
      // searchFieldHintText: "Search Here",
      choiceChipLabel: (item) {
        return item.toCamelCase.readable;
      },
      validateSelectedItem: (list, val) {
        return list.contains(val);
      },
      // onItemSearch: (list, text) {
      //   if (list.any((element) => element.toLowerCase().contains(text.toLowerCase().removeWhiteSpaces))) {
      //     return list.where((element) => element.toLowerCase().contains(text.toLowerCase().removeWhiteSpaces)).toList();
      //   } else {
      //     return [];
      //   }
      // },
      onItemSearch: (item, text) {
        return item.toLowerCase() == text.toLowerCase().removeWhiteSpaces;
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
    CartItemsData cartItemsData = Provider.of<CartItemsData>(context);

    return FutureBuilder(
        future: Future.wait([
          productsData.thoseInTheCartByUserId(widget.userId, filtersList: selectedFilters),
          productsData.priceTotalAmountInCart(widget.userId),
          productsData.quantityTotalAmountInCart(widget.userId),
          cartItemsData.byUserId(widget.userId),
        ]),
        builder: (ctx, AsyncSnapshot<List<dynamic>> snapshot) {
          List<Product> productsInTheCart = [];
          double priceTotalAmountInCart = 0;
          int quantityTotalAmountInCart = 0;
          List<CartItem> cartItems = [];
          if (snapshot.data != null) {
            productsInTheCart = snapshot.data[0];
            priceTotalAmountInCart = snapshot.data[1];
            quantityTotalAmountInCart = snapshot.data[2];
            cartItems = snapshot.data[3];
          }
          int productsInTheCartAmount = productsInTheCart.length;

          List<Widget> noProductsInCartWidgets = [
            Expanded(
              child: CustomEmptyWidget(
                packageImage: 1,
                title: 'We are sorry',
                subTitle: 'There is no products in your Shopping Cart',
              ),
            ),
          ];

          List<Widget> productsInCartWidgets = [
            // Products in Cart header:
            CartItemsDetailsHeader(
              userId: widget.userId,
              priceTotalAmountInCart: priceTotalAmountInCart,
              productsInTheCartAmount: productsInTheCartAmount,
              quantityTotalAmountInCart: quantityTotalAmountInCart,
              cartItems: cartItems,
            ),

            // Products header:
            SimpleListHeader(
              listHeader: 'Products',
            ),

            // Products in Cart List
            Expanded(
              child: ProductsInCartList(
                userId: widget.userId,
                productsInTheCart: productsInTheCart,
              ),
            ),
          ];

          return CustomScaffold(
            activeIndex: _activeTab,
            appTitle: widget.appTitle,
            innerWidgets: productsInTheCartAmount > 0 ? productsInCartWidgets : noProductsInCartWidgets,
            objectsLength: 0,
            objectName: 'product',
            appBarActionIcon: Icons.filter_alt_outlined,
            onPressedBarActionIcon: () => _openFilterDialog(context),
            onPressedFAB: () => _showModalNewFoodRecipe(context),
          );
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
class CartItemIndexScreenArguments {
  final Product product;

  CartItemIndexScreenArguments(
    this.product,
  );
}
