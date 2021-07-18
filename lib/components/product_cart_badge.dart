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

class ProductCartBadge extends StatelessWidget {
  final dynamic userId;
  final String objectName;

  final IconData cartIcon;
  final Function onPressedGoToCart;

  const ProductCartBadge({
    Key key,
    this.userId = 1,
    this.objectName,
    this.cartIcon = Icons.shopping_cart_outlined,
    this.onPressedGoToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProductsData productsData = Provider.of<ProductsData>(context);
    CartItemsData cartItemsData = Provider.of<CartItemsData>(context);
    // print('Running lib/components/product_cart_badge.dart => build');

    return FutureBuilder(
        future: Future.wait([productsData.thoseInTheCartByUserId(userId), cartItemsData.byUserId(userId)]),
        builder: (ctx, AsyncSnapshot<List<dynamic>> snapshot) {
          List<Product> productsInCart = [];
          List<CartItem> cartItems = [];
          if (snapshot.data != null) {
            productsInCart = snapshot.data[0];
            cartItems = snapshot.data[1];
          }
          int productsInCartAmount = productsInCart.length;
          int cartItemsAmount = cartItems.length;

          return productsInCartAmount == 0
              ? IconButton(
                  iconSize: 32,
                  padding: EdgeInsets.all(0),
                  icon: Icon(
                    cartIcon,
                    color: Colors.white,
                    // size: 32,
                  ),
                  tooltip: '${objectName.inCaps}s in the cart',
                  onPressed: onPressedGoToCart,
                )
              : GestureDetector(
                  child: Badge(
                    child: Tooltip(
                      padding: EdgeInsets.all(0),
                      message: 'Add product to cart',
                      child: IconButton(
                        iconSize: 32,
                        padding: EdgeInsets.all(0),
                        icon: Icon(
                          cartIcon,
                          color: Colors.white,
                          // size: 32,
                        ),
                        tooltip: '${objectName.inCaps}s in the cart',
                        // onPressed: onPressedGoToCart,
                      ),
                    ),
                    value: productsInCartAmount.toString(),
                    // value: cartItemsAmount.toString(),
                  ),
                  onTap: onPressedGoToCart,
                );
        });
  }
}
