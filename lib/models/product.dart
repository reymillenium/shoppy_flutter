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

  // Add to Cart feature:
  Future<void> addToCart(int userId, int quantity) async {
    // print('Inside lib/models/product.dart => addToCart');
    CartItemsData cartItemsData = CartItemsData();
    List<CartItem> cartItems = await cartItemsData.byUserId(userId);
    bool isInCart = cartItems.any((cartItem) => cartItem.productId == id);
    if (isInCart) {
      CartItem cartItem = cartItems.firstWhere((cartItem) => cartItem.productId == id);
      await cartItemsData.updateCartItem(cartItem.id, cartItem.quantity + 1);
    } else {
      await cartItemsData.addCartItem(userId: userId, productId: id, quantity: quantity);
    }
    // await refresh();
    notifyListeners();
  }

  Future<void> removeFromCart(int userId) async {
    bool hasOneInCart = false;
    CartItemsData cartItemsData = CartItemsData();
    List<CartItem> cartItems = await cartItemsData.byUserId(userId);
    bool isInCart = cartItems.any((cartItem) => cartItem.productId == id);

    if (isInCart) {
      CartItem cartItem = cartItems.firstWhere((cartItem) => cartItem.productId == id);
      hasOneInCart = (cartItem.quantity == 1 ? true : false);
      if (hasOneInCart) {
        await cartItemsData.deleteCartItemWithoutConfirm(userId, id);
      } else {
        await cartItemsData.updateCartItem(cartItem.id, cartItem.quantity - 1);
      }
    }
    // await refresh();
    notifyListeners();
  }

  Future<void> updateOnCart(int userId, int quantity) async {
    CartItemsData cartItemsData = CartItemsData();
    List<CartItem> cartItems = await cartItemsData.byUserId(userId);
    bool isInCart = cartItems.any((cartItem) => cartItem.productId == id);

    if (isInCart) {
      CartItem cartItem = cartItems.firstWhere((cartItem) => cartItem.productId == id);
      await cartItemsData.updateCartItem(cartItem.id, quantity);
    }
    // await refresh();
    notifyListeners();
  }

  Future<bool> isInCart(int userId) async {
    CartItemsData cartItemsData = CartItemsData();
    List<CartItem> cartItems = await cartItemsData.byUserId(userId);
    return cartItems.any((cartItem) => cartItem.productId == id);
  }

  Future<bool> hasOneInCart(int userId) async {
    bool hasOneInCart = false;
    CartItemsData cartItemsData = CartItemsData();
    List<CartItem> cartItems = await cartItemsData.byUserId(userId);
    bool isInCart = cartItems.any((cartItem) => cartItem.productId == id);

    if (isInCart) {
      CartItem cartItem = cartItems.firstWhere((cartItem) => cartItem.productId == id);
      hasOneInCart = (cartItem.quantity == 1 ? true : false);
    }

    return hasOneInCart;
  }
}
