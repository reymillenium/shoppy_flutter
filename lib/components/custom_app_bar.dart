// Packages:
import '../_inner_packages.dart';
import '../_external_packages.dart';

// Screens:

// Models:
import '../models/_models.dart';

// Components:
import './_components.dart';

// Helpers:
import '../helpers/_helpers.dart';

// Utilities:
import '../utilities/constants.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  // Properties:
  final String appTitle;
  final int userId;
  final String objectName;

  final bool showFirstActionButton;
  final IconData actionIcon;
  final Function onPressedAdd;

  final IconData cartIcon;
  final Function onPressedGoToCart;

  const CustomAppBar({
    Key key,
    this.appTitle,
    this.userId = 1,
    this.objectName,
    this.showFirstActionButton = false,
    this.actionIcon = Icons.add,
    this.onPressedAdd,
    this.cartIcon = Icons.shopping_cart_outlined,
    this.onPressedGoToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);
    Map currentThemeFont = appData.currentThemeFont;

    return AppBar(
      centerTitle: true,
      title: Text(
        appTitle,
        // style: TextStyle(
        //   fontSize: 24,
        //   fontWeight: FontWeight.bold,
        //   fontFamily: currentThemeFont['fontFamily'],
        // ),
        style: Theme.of(context).appBarTheme.textTheme.headline6.copyWith(
              fontFamily: currentThemeFont['fontFamily'],
            ),
      ),
      actions: [
        if (showFirstActionButton) ...[
          IconButton(
            iconSize: 32,
            icon: Icon(actionIcon),
            tooltip: 'Add ${objectName.inCaps}',
            onPressed: onPressedAdd,
          ),
        ],

        // IconButton(
        //   iconSize: 32,
        //   icon: Icon(cartIcon),
        //   tooltip: 'Add ${objectName.inCaps} to cart',
        //   onPressed: onPressedAddToCart,
        // ),

        if (objectName == 'product' || objectName == 'favoriteProduct' || objectName == 'order') ...[
          ProductCartBadge(
            userId: userId,
            objectName: objectName,
            cartIcon: cartIcon,
            onPressedGoToCart: onPressedGoToCart,
          ),
        ]
      ],
      // bottom: PreferredSize(
      //   preferredSize: Size.fromHeight(100.0),
      // ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolBarHeight);
}
