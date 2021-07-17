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

class FavoriteProductBigButton extends StatelessWidget {
  // Properties:
  final dynamic userId;

  const FavoriteProductBigButton({
    Key key,
    this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Product product = Provider.of<Product>(context);
    Function toggleFavorite = (userId) => product.toggleFavorite(userId);

    return FutureBuilder(
        future: product.isFavorite(userId),
        builder: (ctx, AsyncSnapshot<bool> snapshot) {
          bool isFavorite = false;
          if (snapshot.data != null) {
            isFavorite = snapshot.data;
          }
          return CircleAvatar(
            radius: 24,
            backgroundColor: Colors.black26,
            child: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_outline,
                color: isFavorite ? Colors.yellow : Colors.white,
                size: 32,
              ),
              tooltip: 'Favorite',
              onPressed: () => toggleFavorite(userId),
            ),
          );
        });
  }
}
