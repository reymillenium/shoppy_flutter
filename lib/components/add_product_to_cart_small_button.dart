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
  final dynamic userId;
  final bool listenProductsData;

  const AddProductToCartSmallButton({
    Key key,
    this.userId = 1,
    this.listenProductsData = false,
  }) : super(key: key);

  @override
  // Works
  // Widget build(BuildContext context) {
  //   return Consumer<Product>(
  //     builder: (context, product, child) {
  //       // Function addToCart = (userId, quantity) => product.addToCart(userId, quantity);
  //       ProductsData productsData = Provider.of<ProductsData>(context);
  //       Function addToCart = (userId, productId, quantity) => productsData.addToCart(userId, productId, quantity);
  //
  //       return Tooltip(
  //         padding: EdgeInsets.all(0),
  //         message: 'Add product to cart',
  //         child: IconButton(
  //           padding: EdgeInsets.all(0),
  //           icon: Icon(
  //             Icons.shopping_cart_outlined,
  //             color: Colors.white,
  //             size: 14,
  //           ),
  //           // onPressed: () => addToCart(userId, 1),
  //           onPressed: () => addToCart(userId, product.id, 1),
  //         ),
  //       );
  //     },
  //   );
  // }
  // Works too:
  Widget build(BuildContext context) {
    Product product = Provider.of<Product>(context, listen: false);
    Function addToCartOnProduct = (userId, quantity) => product.addToCart(userId, quantity);
    Function decreaseFromCartOnProduct = (userId) => product.decreaseFromCart(userId);

    // print('lib/components/add_product_to_cart_small_button.dart => build');
    // Works
    ProductsData productsData = Provider.of<ProductsData>(context, listen: listenProductsData);
    Function addToCart = (userId, productId, quantity) => productsData.addToCart(userId, productId, quantity);
    Function decreaseFromCart = (userId, productId) => productsData.decreaseFromCart(userId, productId);
    // Works too...
    // CartItemsData cartItemsData = Provider.of<CartItemsData>(context, listen: false);
    // Function addCartItem = (userId, productId, quantity) => cartItemsData.addCartItem(userId: userId, productId: productId, quantity: quantity);
    // Function addToCartOnCartItemsData = (userId, productId, quantity) => cartItemsData.addToCart(userId, productId, quantity);
    // Function decreaseFromCartOnCartItemsData = (userId, productId) => cartItemsData.decreaseFromCart(userId, productId);

    return FutureBuilder(
      future: Future.wait([
        // product.isInCart(userId),
        product.quantityAmountInCart(userId),
      ]),
      builder: (ctx, AsyncSnapshot<List<dynamic>> snapshot) {
        // bool isInCart = false;
        int quantityAmountInCart = 0;
        if (snapshot.data != null) {
          // isInCart = snapshot.data[0];
          quantityAmountInCart = snapshot.data[0];
        }

        var verticalDivider = VerticalDivider(
          color: Colors.white30,
          width: 12,
          indent: 0,
          endIndent: 0,
          thickness: 1,
        );

        return quantityAmountInCart == 0
            ? Tooltip(
                padding: EdgeInsets.all(0),
                message: 'Add product to cart',
                child: GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(right: 32, top: 6, bottom: 6),
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.black,
                      size: 14,
                    ),
                  ),
                  onTap: () => addToCart(userId, product.id, 1),
                ),
              )
            : Container(
                height: 26,
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Remove from Cart Button:
                    Tooltip(
                        message: 'Remove',
                        child: GestureDetector(
                          child: Container(
                            // margin: EdgeInsets.only(right: 8),
                            child: Icon(
                              quantityAmountInCart == 1 ? Icons.delete : Icons.remove,
                              // Icons.remove,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                          // onTap: () => decreaseFromCartOnProduct(widget.userId),
                          // onTap: () => decreaseFromCart(userId, product.id),
                          onTap: () => quantityAmountInCart == 1 ? DialogHelper.showDialogWithActionPlus(context, () => decreaseFromCart(userId, product.id)) : decreaseFromCart(userId, product.id),
                          // onTap: () => decreaseFromCartOnCartItemsData(widget.userId, product.id),
                        )),

                    verticalDivider,

                    // Amount in Cart Label:
                    FittedBox(
                      child: Text(
                        '$quantityAmountInCart',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          // fontStyle: FontStyle.italic,
                          // fontSize: priceFontSize,
                        ),
                      ),
                    ),

                    verticalDivider,

                    // Add to Cart Button:
                    Tooltip(
                      message: 'Add',
                      child: GestureDetector(
                        child: Container(
                          // margin: EdgeInsets.only(left: 8),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                        // onTap: () => addToCartOnProduct(widget.userId, 1),
                        onTap: () => addToCart(userId, product.id, 1),
                        // onTap: () => addToCartOnCartItemsData(widget.userId, product.id, 1),
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }
}
