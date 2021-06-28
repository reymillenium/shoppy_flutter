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

class FavoriteProductSmallButton extends StatelessWidget {
  // Properties:
  final int userId;
  final bool inFavoriteScreen;

  const FavoriteProductSmallButton({
    Key key,
    this.userId,
    this.inFavoriteScreen = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Product>(
      builder: (context, product, child) {
        return FutureBuilder(
            future: product.isFavorite(userId),
            builder: (ctx, AsyncSnapshot<bool> snapshot) {
              bool isFavoriteNow = false;
              if (snapshot.data != null) {
                isFavoriteNow = snapshot.data;
              }

              ProductsData productsData = Provider.of<ProductsData>(context);
              Function toggleFavoriteProductsData = (userId, productId) => productsData.toggleFavorite(userId, productId);

              return IconButton(
                icon: Icon(
                  isFavoriteNow ? Icons.favorite : Icons.favorite_border,
                  color: isFavoriteNow ? Colors.yellow : Colors.white,
                  size: 14,
                ),
                tooltip: 'Favorite',
                onPressed: () => inFavoriteScreen ? toggleFavoriteProductsData(userId, product.id) : product.toggleFavorite(userId),
              );
            });
        // return IconButton(
        //   icon: Icon(
        //     isFavorite ? Icons.favorite : Icons.favorite_border,
        //     color: isFavorite ? Colors.yellow : Colors.white,
        //     size: 14,
        //   ),
        //   tooltip: 'Favorite',
        //   onPressed: () => product.toggleFavorite(userId),
        // );
      },
    );
  }
}
