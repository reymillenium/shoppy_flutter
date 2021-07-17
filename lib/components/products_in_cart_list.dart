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

class ProductsInCartList extends StatefulWidget {
  // Properties:
  final dynamic userId;
  final List<Product> productsInTheCart;

  // Constructor:
  ProductsInCartList({
    Key key,
    this.userId = 1,
    this.productsInTheCart,
  }) : super(key: key);

  @override
  _ProductsInCartListState createState() => _ProductsInCartListState();
}

class _ProductsInCartListState extends State<ProductsInCartList> {
  final _listViewScrollController = ScrollController();
  bool _isSwapping = false;

  @override
  Widget build(BuildContext context) {
    ProductsData productsData = Provider.of<ProductsData>(context, listen: false);
    Function removeFromCart = (userId, productId) => productsData.removeFromCart(userId, productId);

    // CartItemsData cartItemsData = Provider.of<CartItemsData>(context);

    return ListView.builder(
      padding: const EdgeInsets.only(left: 0, top: 0, right: 0),
      controller: _listViewScrollController,
      itemCount: widget.productsInTheCart.length,
      // itemCount: cartItems.length,
      itemBuilder: (BuildContext context, int index) {
        // final item = productsInTheCart[index];
        final uuid = Uuid();
        final uniqueKey = UniqueKey();

        return Dismissible(
          // Not blinking, but shows error:
          // key: ValueKey(productsInTheCart[index].id),
          // key: ValueKey(cartItems[index].id),
          // Not initial error, but shows blinking:
          // key: UniqueKey(),
          // key: ValueKey(uuid.v1()),
          // Shows error fula
          // key: ValueKey(productsInTheCart[index]),
          // Worst error, persisting
          // key: Key("$index"),
          // key: uniqueKey,
          key: _isSwapping ? uniqueKey : ValueKey(widget.productsInTheCart[index].id),
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
          confirmDismiss: (DismissDirection direction) {
            return DialogHelper.showDialogDecisionPlus(context);
          },
          onDismissed: (DismissDirection direction) {
            setState(() {
              _isSwapping = true;
            });
            removeFromCart(widget.userId, widget.productsInTheCart[index].id).then((val) {
              setState(() {
                _isSwapping = false;
              });
            });
          },
          direction: DismissDirection.endToStart,
          child: ChangeNotifierProvider.value(
            value: widget.productsInTheCart[index],
            child: ProductInCartTile(
              key: ValueKey(widget.productsInTheCart[index].id),
              // key: ValueKey(cartItems[index].id),
              // key: UniqueKey(),
              userId: widget.userId,
            ),
          ),
        );
      },
    );

    // );
    // },
  }

  int findChildIndexCallback(Key key, List<Product> productsInTheCart) {
    final ValueKey valueKey = key as ValueKey;
    final dynamic id = valueKey.value;
    Product product;
    try {
      product = productsInTheCart.firstWhere((productInTheCart) => id == productInTheCart.id);
    } catch (e) {
      return null;
    }
    return productsInTheCart.indexOf(product);
  }
}
