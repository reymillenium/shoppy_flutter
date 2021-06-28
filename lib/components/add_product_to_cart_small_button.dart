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

class AddProductToCartSmallButton extends StatelessWidget {
  final int userId;

  const AddProductToCartSmallButton({
    Key key,
    this.userId = 1,
  }) : super(key: key);

  @override
  // Works
  Widget build(BuildContext context) {
    return Consumer<Product>(
      builder: (context, product, child) {
        // Function addToCart = (userId, quantity) => product.addToCart(userId, quantity);
        ProductsData productsData = Provider.of<ProductsData>(context);
        Function addToCart = (userId, productId, quantity) => productsData.addToCart(userId, productId, quantity);

        return Tooltip(
          padding: EdgeInsets.all(0),
          message: 'Add product to cart',
          child: IconButton(
            padding: EdgeInsets.all(0),
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
              size: 14,
            ),
            // onPressed: () => addToCart(userId, 1),
            onPressed: () => addToCart(userId, product.id, 1),
          ),
        );
      },
    );
  }
  // Works too:
  // Widget build(BuildContext context) {
  //   Product product = Provider.of<Product>(context);
  //   // Works
  //   ProductsData productsData = Provider.of<ProductsData>(context);
  //   Function addToCart = (userId, productId, quantity) => productsData.addToCart(userId, productId, quantity);
  //   // Does not Works
  //   // Function addToCart = (userId, quantity) => product.addToCart(userId, quantity);
  //   // Works too...
  //   CartItemsData cartItemsData = Provider.of<CartItemsData>(context);
  //   Function addCartItem = (userId, productId, quantity) => cartItemsData.addCartItem(userId: userId, productId: productId, quantity: quantity);
  //
  //   return Tooltip(
  //     padding: EdgeInsets.all(0),
  //     message: 'Add product to cart',
  //     child: IconButton(
  //       padding: EdgeInsets.all(0),
  //       icon: Icon(
  //         Icons.shopping_cart_outlined,
  //         color: Colors.white,
  //         size: 14,
  //       ),
  //       onPressed: () => addToCart(userId, product.id, 1), // Works
  //       // onPressed: () => addToCart(userId, 1), // Do not Works
  //       // onPressed: () => addCartItem(userId, product.id, 1), // Works
  //     ),
  //   );
  // }
}
