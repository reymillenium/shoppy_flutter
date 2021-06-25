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

class Product with ChangeNotifier {
  // Properties:
  int id;
  String title;
  String description;
  double price;
  String imageUrl;
  DateTime createdAt;
  DateTime updatedAt;

  // Constructors:
  Product({
    this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    @required this.createdAt,
    @required this.updatedAt,
  });

  Product.fromMap(Map<String, dynamic> productMap) {
    id = productMap['id'];
    title = productMap['title'];
    description = productMap['description'];
    price = productMap['price'];
    imageUrl = productMap['image_url'];

    createdAt = DateTime.parse(productMap['created_at']);
    updatedAt = DateTime.parse(productMap['updated_at']);
  }

  Map<String, dynamic> toMap() {
    var productMap = <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'created_at': createdAt.toString(),
      'updated_at': updatedAt.toString(),
    };
    return productMap;
  }

  Future<void> setAsFavorite(int userId) async {
    FavoriteProductsData favoriteProductsData = FavoriteProductsData();
    await favoriteProductsData.addFavoriteProduct(userId: userId, productId: id);
    // await refresh();
  }

  Future<void> setAsNotFavorite(int userId) async {
    FavoriteProductsData favoriteProductsData = FavoriteProductsData();
    await favoriteProductsData.deleteFavoriteProductWithoutConfirm(userId, id);
    // await refresh();
  }

  Future<void> toggleFavorite(int userId) async {
    bool isFavorite = await this.isFavorite(userId);
    await (isFavorite ? this.setAsNotFavorite(userId) : this.setAsFavorite(userId));
    // await refresh();
    notifyListeners();
  }

  Future<bool> isFavorite(int userId) async {
    FavoriteProductsData favoriteProductsData = FavoriteProductsData();
    List<FavoriteProduct> favoriteProducts = await favoriteProductsData.byUserId(userId);
    return favoriteProducts.any((favoriteProduct) => favoriteProduct.productId == id);
  }
}
