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

class AddProductToCartUpperLeftStyled extends StatelessWidget {
  // Properties:
  final dynamic userId;

  const AddProductToCartUpperLeftStyled({
    Key key,
    this.userId = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Product product = Provider.of<Product>(context);
    // Works
    ProductsData productsData = Provider.of<ProductsData>(context);
    Function addToCart = (userId, productId, quantity) => productsData.addToCart(userId, productId, quantity);
    Function decreaseFromCart = (userId, productId) => productsData.decreaseFromCart(userId, productId);
    // Works too...
    // CartItemsData cartItemsData = Provider.of<CartItemsData>(context);
    // Function addCartItem = (userId, productId, quantity) => cartItemsData.addCartItem(userId: userId, productId: productId, quantity: quantity);

    return FutureBuilder(
      future: Future.wait([product.isInCart(userId), product.quantityAmountInCart(userId)]),
      builder: (ctx, AsyncSnapshot<List<dynamic>> snapshot) {
        bool isInCart = false;
        int quantityAmountInCart = 0;
        if (snapshot.data != null) {
          isInCart = snapshot.data[0];
          quantityAmountInCart = snapshot.data[1];
        }

        // print(quantityAmountInCart);
        var verticalDivider = VerticalDivider(
          color: Colors.white30,
          width: 12,
          indent: 0,
          endIndent: 0,
          thickness: 1,
        );

        return Container(
          height: 26,
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: quantityAmountInCart == 0
              ? Tooltip(
                  padding: EdgeInsets.all(0),
                  message: 'Add product to cart',
                  child: IconButton(
                    padding: EdgeInsets.all(0),
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      color: isInCart ? Colors.red : Colors.white,
                      size: 14,
                    ),
                    onPressed: () {
                      addToCart(userId, product.id, 1); // Works
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      final snackBar = DialogHelper.buildSnackBar(
                        snackBarMessage: 'The product has being added to the Cart',
                        actionOnPressed: () => decreaseFromCart(userId, product.id),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                  ),
                )
              : Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Decrease from Cart Button:
                      Tooltip(
                          message: 'Decrease',
                          child: GestureDetector(
                            child: Container(
                              // margin: EdgeInsets.only(right: 8),
                              child: Icon(
                                Icons.remove,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                            onTap: () {
                              decreaseFromCart(userId, product.id);
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              final snackBar = DialogHelper.buildSnackBar(
                                snackBarMessage: 'The product has being removed from the Cart',
                                actionOnPressed: () => addToCart(userId, product.id, 1),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            },
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

                      // Increase in Cart Button:
                      Tooltip(
                        message: 'Increase',
                        child: GestureDetector(
                          child: Container(
                            // margin: EdgeInsets.only(left: 8),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                          onTap: () {
                            addToCart(userId, product.id, 1);
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            final snackBar = DialogHelper.buildSnackBar(
                              snackBarMessage: 'The product has being added to the Cart',
                              actionOnPressed: () => decreaseFromCart(userId, product.id),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
