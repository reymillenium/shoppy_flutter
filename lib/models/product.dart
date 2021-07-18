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
  dynamic id;
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

  // To use with Sqlite
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

  // To use with Firebase Realtime DB:
  // Product.fromSnapshot(DataSnapshot snapshot)
  //     : id = snapshot.key,
  //       imageUrl = snapshot.value["imageUrl"],
  //       caption = snapshot.value["caption"],
  //       title = snapshot.value["postTitle"];

  Future<void> setAsFavorite(dynamic userId) async {
    FavoriteProductsData favoriteProductsData = FavoriteProductsData();
    await favoriteProductsData.addFavoriteProduct(userId: userId, productId: id);
    // await refresh();
  }

  Future<void> setAsNotFavorite(dynamic userId) async {
    FavoriteProductsData favoriteProductsData = FavoriteProductsData();
    await favoriteProductsData.deleteFavoriteProductWithoutConfirm(userId, id);
    // await refresh();
  }

  Future<void> toggleFavorite(dynamic userId) async {
    bool isFavorite = await this.isFavorite(userId);
    await (isFavorite ? this.setAsNotFavorite(userId) : this.setAsFavorite(userId));
    // await refresh();
    notifyListeners();
  }

  Future<bool> isFavorite(dynamic userId) async {
    FavoriteProductsData favoriteProductsData = FavoriteProductsData();
    List<FavoriteProduct> favoriteProducts = await favoriteProductsData.byUserId(userId);
    return favoriteProducts.any((favoriteProduct) => favoriteProduct.productId == id);
  }

  // Add to Cart feature:
  Future<void> addToCart(dynamic userId, int quantity) async {
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

  Future<void> decreaseFromCart(dynamic userId) async {
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

  Future<void> removeFromCart(dynamic userId) async {
    CartItemsData cartItemsData = CartItemsData();
    List<CartItem> cartItems = await cartItemsData.byUserId(userId);
    bool isInCart = cartItems.any((cartItem) => cartItem.productId == id);

    if (isInCart) {
      await cartItemsData.deleteCartItemWithoutConfirm(userId, id);
    }
    // await refresh();
    notifyListeners();
  }

  Future<void> updateOnCart(dynamic userId, int quantity) async {
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

  Future<bool> isInCart(dynamic userId) async {
    CartItemsData cartItemsData = CartItemsData();
    List<CartItem> cartItems = await cartItemsData.byUserId(userId);
    return cartItems.any((cartItem) => cartItem.productId == id);
  }

  Future<bool> hasOneInCart(dynamic userId) async {
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

  Future<int> quantityAmountInCart(dynamic userId) async {
    int quantityAmountInCart = 0;
    CartItemsData cartItemsData = CartItemsData();
    List<CartItem> cartItems = await cartItemsData.byUserId(userId);
    bool isInCart = cartItems.any((cartItem) => cartItem.productId == id);

    if (isInCart) {
      CartItem cartItem = cartItems.firstWhere((cartItem) => cartItem.productId == id);
      quantityAmountInCart = cartItem.quantity;
    }

    return quantityAmountInCart;
  }

  Future<double> priceAmountInCart(dynamic userId) async {
    double priceAmountInCart = 0;
    CartItemsData cartItemsData = CartItemsData();
    List<CartItem> cartItems = await cartItemsData.byUserId(userId);
    bool isInCart = cartItems.any((cartItem) => cartItem.productId == id);

    if (isInCart) {
      CartItem cartItem = cartItems.firstWhere((cartItem) => cartItem.productId == id);
      priceAmountInCart = cartItem.quantity * price;
    }

    return priceAmountInCart;
  }
}
