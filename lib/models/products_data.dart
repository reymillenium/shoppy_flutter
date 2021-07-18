// Packages:

import 'package:shoppy_flutter/helpers/firebase_realtime_db_helper.dart';

import '../_inner_packages.dart';
import '../_external_packages.dart';

// Screens:

// Models:
import '../models/_models.dart';

// Components:

// Helpers:
import '../helpers/_helpers.dart';

// Utilities:
import '../utilities/_utilities.dart';

class ProductsData with ChangeNotifier {
  // Properties:
  static const sqliteTable = {
    'table_plural_name': 'products',
    'table_singular_name': 'product',
    'fields': [
      {
        'field_name': 'id',
        'field_type': 'TEXT',
      },
      {
        'field_name': 'title',
        'field_type': 'TEXT',
      },
      {
        'field_name': 'description',
        'field_type': 'TEXT',
      },
      {
        'field_name': 'price',
        'field_type': 'REAL',
      },
      {
        'field_name': 'image_url',
        'field_type': 'TEXT',
      },
      {
        'field_name': 'created_at',
        'field_type': 'TEXT',
      },
      {
        'field_name': 'updated_at',
        'field_type': 'TEXT',
      },
    ],
  };
  final int _maxAmountDummyData = 12;
  List<Product> _products = [];
  DBHelper dbHelper;
  FirebaseRealtimeDBHelper firebaseRealtimeDBHelper;

  // Constructor:
  ProductsData() {
    // dbHelper = DBHelper();
    firebaseRealtimeDBHelper = FirebaseRealtimeDBHelper();

    // dbHelper.deleteDb();
    // _generateDummyData();
    refresh();
  }

  // Getter:
  UnmodifiableListView<Product> get products {
    return UnmodifiableListView(_products);
  }

  // SQLite || Firebase Realtime DB CRUD:
  Future<Product> _create(Product product, Map<String, dynamic> table) async {
    // SQLite DB:
    // var dbClient = await dbHelper.dbPlus();
    // product.id = await dbClient.insert(table['table_plural_name'], product.toMap());

    // Firebase Realtime DB:
    Response postResponse = await firebaseRealtimeDBHelper.postData(
      protocol: 'https',
      authority: firebaseRealtimeAuthorityURL,
      unencodedPath: '/${sqliteTable['table_plural_name']}.json',
      body: json.encode(product.toMap()),
    );
    Map<String, dynamic> postResponseBody = jsonDecode(postResponse.body);
    product.id = postResponseBody['name'];
    return product;
  }

  Future<List<dynamic>> _index(Map<String, dynamic> table) async {
    List<Product> productsList = [];
    // SQLite DB:
    // var dbClient = await dbHelper.dbPlus();
    // List<Map> tableFields = table['fields'];
    // List<Map> productsMaps = await dbClient.query(table['table_plural_name'], columns: tableFields.map<String>((field) => field['field_name']).toList());
    // if (productsMaps.length > 0) {
    //   for (int i = 0; i < productsMaps.length; i++) {
    //     Product product;
    //     product = Product.fromMap(productsMaps[i]);
    //     productsList.add(product);
    //   }
    // }

    // Firebase Realtime DB:
    FirebaseRealtimeDBHelper firebaseRealtimeDBHelper = FirebaseRealtimeDBHelper();
    Response getResponse = await firebaseRealtimeDBHelper.getData(
      protocol: 'https',
      authority: firebaseRealtimeAuthorityURL,
      unencodedPath: '/${sqliteTable['table_plural_name']}.json',
    );
    Map<String, dynamic> getResponseBody = jsonDecode(getResponse.body);
    if (getResponseBody.length > 0) {
      getResponseBody.forEach((key, value) {
        Product product;
        product = Product.fromMap(getResponseBody[key]);
        product.id = key;
        productsList.add(product);
      });
    }

    return productsList;
  }

  Future<dynamic> _destroy(dynamic id, Map<String, dynamic> table) async {
    // SQLite DB:
    // var dbClient = await dbHelper.dbPlus();
    // return await dbClient.delete(table['table_plural_name'], where: 'id = ?', whereArgs: [id]);

    // Firebase Realtime DB:
    Response deleteResponse = await firebaseRealtimeDBHelper.deleteData(
      protocol: 'https',
      authority: firebaseRealtimeAuthorityURL,
      unencodedPath: '/${sqliteTable['table_plural_name']}/$id.json',
    );
    return deleteResponse.statusCode == 200;
  }

  Future<dynamic> _update(Product product, Map<String, dynamic> table) async {
    // SQLite DB:
    // var dbClient = await dbHelper.dbPlus();3
    // return await dbClient.update(table['table_plural_name'], product.toMap(), where: 'id = ?', whereArgs: [product.id]);

    // Firebase Realtime DB:
    Response response = await firebaseRealtimeDBHelper.updateData(
      protocol: 'https',
      authority: firebaseRealtimeAuthorityURL,
      unencodedPath: '/${sqliteTable['table_plural_name']}/${product.id}.json',
      body: json.encode(product.toMap()),
    );
    return response.statusCode == 200;
  }

  // Private methods:
  void _generateDummyData() async {
    final List<Product> products = await _index(sqliteTable);
    final int currentLength = products.length;
    if (currentLength < _maxAmountDummyData) {
      for (int i = 0; i < (_maxAmountDummyData - currentLength); i++) {
        String title = faker.lorem.word();
        String description = faker.lorem.sentence();
        double price = NumericHelper.roundRandomDoubleInRange(min: 0.99, max: 9.99, places: 2);
        await addProduct(title: title, description: description, price: price, imageUrl: ListHelper.randomFromList(DUMMY_PRODUCT_IMAGE_URLS));
      }
    }
  }

  void _removeWhere(dynamic productId, dynamic userId) async {
    bool isFavorite = await this.isFavorite(userId, productId);
    if (isFavorite) {
      await this.setAsNotFavorite(userId, productId);
    }
    bool isInCart = await this.isInCart(userId, productId);
    if (isInCart) {
      CartItemsData cartItemsData = CartItemsData();
      await cartItemsData.deleteCartItemWithoutConfirm(userId, productId);
    }
    await _destroy(productId, sqliteTable);
    await refresh();
  }

  // Public methods:
  Future refresh() async {
    _products = await _index(sqliteTable);
    notifyListeners();
  }

  Future<Product> addProduct({String title, String description, double price, String imageUrl}) async {
    DateTime now = DateTime.now();
    Product newProduct = Product(
      title: title,
      description: description,
      price: price,
      imageUrl: imageUrl,
      createdAt: now,
      updatedAt: now,
    );
    Product product = await _create(newProduct, sqliteTable);
    refresh();
    return product;
  }

  Future<void> updateProduct(dynamic productId, String title, String description, double price, String imageUrl) async {
    DateTime now = DateTime.now();
    Product updatingProduct = _products.firstWhere((product) => productId == product.id);

    updatingProduct.title = title;
    updatingProduct.description = description;
    updatingProduct.price = price;
    updatingProduct.imageUrl = imageUrl;
    updatingProduct.updatedAt = now;

    await _update(updatingProduct, sqliteTable);
    refresh();
  }

  Future<void> deleteProductWithConfirm(dynamic productId, BuildContext context, dynamic userId) {
    DialogHelper.showDialogWithActionPlus(context, () => _removeWhere(productId, userId)).then((value) {
      (context as Element).reassemble();
      refresh();
    });
  }

  void deleteProductWithoutConfirm(dynamic id, dynamic userId) {
    _removeWhere(id, userId);
    refresh();
  }

  Future<List<Product>> thoseFavoritesByUserId(dynamic userId, {List<String> filtersList}) async {
    var dbClient = await dbHelper.dbPlus();
    List<Product> productsList = [];
    filtersList = filtersList ?? [];
    FavoriteProductsData favoriteProductsData = FavoriteProductsData();
    // Gathering of the productsIdsList on the FavoriteProducts table (favorite_products) by the user_id:
    List<FavoriteProduct> favoriteProductsList = await favoriteProductsData.byUserId(userId);

    if (favoriteProductsList.isNotEmpty) {
      List<int> productsIdsList = favoriteProductsList.map((favoriteProduct) => favoriteProduct.productId).toList();

      Map<String, Object> productsTable = ProductsData.sqliteTable;
      String productsTableName = productsTable['table_plural_name'];
      List<Map> productsTableFields = productsTable['fields'];
      String filteringString = (filtersList.isEmpty) ? '' : "(${filtersList.map((e) => "$e = 1").join(' OR ')}) AND ";
      List<Map> productsMaps = await dbClient.query(productsTableName, columns: productsTableFields.map<String>((field) => field['field_name']).toList(), where: '${filteringString}id IN (${productsIdsList.map((e) => "'$e'").join(', ')})');

      // Conversion into Product objects:
      if (productsMaps.length > 0) {
        for (int i = 0; i < productsMaps.length; i++) {
          Product product = Product.fromMap(productsMaps[i]);
          productsList.add(product);
        }
      }
    }

    return productsList;
  }

  Future<List<Product>> thoseInTheCartByUserId(dynamic userId, {List<String> filtersList}) async {
    var dbClient = await dbHelper.dbPlus();
    List<Product> productsList = [];
    filtersList = filtersList ?? [];
    CartItemsData cartItemsData = CartItemsData();
    // Gathering of the productsIdsList on the CartItemsData table (cart_items) by the user_id:
    List<CartItem> cartItemsList = await cartItemsData.byUserId(userId);

    if (cartItemsList.isNotEmpty) {
      List<int> productsIdsList = cartItemsList.map((cartItem) => cartItem.productId).toList();

      Map<String, Object> productsTable = ProductsData.sqliteTable;
      String productsTableName = productsTable['table_plural_name'];
      List<Map> productsTableFields = productsTable['fields'];
      String filteringString = (filtersList.isEmpty) ? '' : "(${filtersList.map((e) => "$e = 1").join(' OR ')}) AND ";
      List<Map> productsMaps = await dbClient.query(productsTableName, columns: productsTableFields.map<String>((field) => field['field_name']).toList(), where: '${filteringString}id IN (${productsIdsList.map((e) => "'$e'").join(', ')})');

      // Conversion into Product objects:
      if (productsMaps.length > 0) {
        for (int i = 0; i < productsMaps.length; i++) {
          Product product = Product.fromMap(productsMaps[i]);
          productsList.add(product);
        }
      }
    }

    return productsList;
  }

  Future<void> setAsFavorite(dynamic userId, dynamic productId) async {
    FavoriteProductsData favoriteProductsData = FavoriteProductsData();
    await favoriteProductsData.addFavoriteProduct(userId: userId, productId: productId);
    // await refresh();
  }

  Future<void> setAsNotFavorite(dynamic userId, dynamic productId) async {
    FavoriteProductsData favoriteProductsData = FavoriteProductsData();
    await favoriteProductsData.deleteFavoriteProductWithoutConfirm(userId, productId);
    // await refresh();
  }

  Future<void> toggleFavorite(dynamic userId, dynamic productId) async {
    bool isFavorite = await this.isFavorite(userId, productId);
    await (isFavorite ? this.setAsNotFavorite(userId, productId) : this.setAsFavorite(userId, productId));
    await refresh();
  }

  Future<bool> isFavorite(dynamic userId, dynamic productId) async {
    FavoriteProductsData favoriteProductsData = FavoriteProductsData();
    List<FavoriteProduct> favoriteProducts = await favoriteProductsData.byUserId(userId);
    return favoriteProducts.any((favoriteProduct) => favoriteProduct.productId == productId);
  }

  // Add to Cart feature:
  Future<void> addToCart(dynamic userId, dynamic productId, int quantity) async {
    CartItemsData cartItemsData = CartItemsData();
    List<CartItem> cartItems = await cartItemsData.byUserId(userId);
    bool isInCart = cartItems.any((cartItem) => cartItem.productId == productId);

    if (isInCart) {
      CartItem cartItem = cartItems.firstWhere((cartItem) => cartItem.productId == productId);
      await cartItemsData.updateCartItem(cartItem.id, cartItem.quantity + 1);
    } else {
      await cartItemsData.addCartItem(userId: userId, productId: productId, quantity: quantity);
    }
    await refresh();
  }

  Future<void> decreaseFromCart(dynamic userId, dynamic productId) async {
    bool hasOneInCart = false;
    CartItemsData cartItemsData = CartItemsData();
    List<CartItem> cartItems = await cartItemsData.byUserId(userId);
    bool isInCart = cartItems.any((cartItem) => cartItem.productId == productId);

    if (isInCart) {
      CartItem cartItem = cartItems.firstWhere((cartItem) => cartItem.productId == productId);
      hasOneInCart = (cartItem.quantity == 1 ? true : false);
      if (hasOneInCart) {
        await cartItemsData.deleteCartItemWithoutConfirm(userId, productId);
      } else {
        await cartItemsData.updateCartItem(cartItem.id, cartItem.quantity - 1);
      }
    }
    await refresh();
  }

  Future<void> removeFromCart(dynamic userId, dynamic productId) async {
    CartItemsData cartItemsData = CartItemsData();
    List<CartItem> cartItems = await cartItemsData.byUserId(userId);
    bool isInCart = cartItems.any((cartItem) => cartItem.productId == productId);

    if (isInCart) {
      await cartItemsData.deleteCartItemWithoutConfirm(userId, productId);
    }
    // await refresh();
    notifyListeners();
  }

  Future<void> removeAllFromCart(dynamic userId, List<CartItem> cartItems) async {
    CartItemsData cartItemsData = CartItemsData();
    // Loop in a Future: Creates each one of the related OrderedItem objects:
    await Future.forEach(cartItems, (cartItem) async {
      List<Product> products = await this.thoseInTheCartByUserId(userId);
      Product product = products.firstWhere((product) => product.id == cartItem.productId);

      // We destroy the CartItem object:
      await cartItemsData.deleteCartItemWithoutConfirm(userId, product.id);
    });
    await refresh();
    // notifyListeners();
  }

  Future<void> updateOnCart(dynamic userId, dynamic productId, int quantity) async {
    CartItemsData cartItemsData = CartItemsData();
    List<CartItem> cartItems = await cartItemsData.byUserId(userId);
    bool isInCart = cartItems.any((cartItem) => cartItem.productId == productId);

    if (isInCart) {
      CartItem cartItem = cartItems.firstWhere((cartItem) => cartItem.productId == productId);
      cartItemsData.updateCartItem(cartItem.id, quantity);
    }
    // await refresh();
    notifyListeners();
  }

  Future<bool> isInCart(dynamic userId, dynamic productId) async {
    CartItemsData cartItemsData = CartItemsData();
    List<CartItem> cartItems = await cartItemsData.byUserId(userId);
    return cartItems.any((cartItem) => cartItem.productId == productId);
  }

  Future<bool> hasOneInCart(dynamic userId, dynamic productId) async {
    bool hasOneInCart = false;
    CartItemsData cartItemsData = CartItemsData();
    List<CartItem> cartItems = await cartItemsData.byUserId(userId);
    bool isInCart = cartItems.any((cartItem) => cartItem.productId == productId);

    if (isInCart) {
      CartItem cartItem = cartItems.firstWhere((cartItem) => cartItem.productId == productId);
      hasOneInCart = (cartItem.quantity == 1 ? true : false);
    }

    return hasOneInCart;
  }

  Future<int> quantityAmountInCart(dynamic userId, dynamic productId) async {
    int quantityAmountInCart = 0;
    CartItemsData cartItemsData = CartItemsData();
    List<CartItem> cartItems = await cartItemsData.byUserId(userId);
    bool isInCart = cartItems.any((cartItem) => cartItem.productId == productId);

    if (isInCart) {
      CartItem cartItem = cartItems.firstWhere((cartItem) => cartItem.productId == productId);
      quantityAmountInCart = cartItem.quantity;
    }

    return quantityAmountInCart;
  }

  Future<int> quantityTotalAmountInCart(dynamic userId) async {
    int quantityTotalAmountInCart = 0;
    List<Product> productsInCart = await this.thoseInTheCartByUserId(userId);

    // Loop in a Future:
    await Future.forEach(productsInCart, (productInCart) async {
      int temp = await this.quantityAmountInCart(userId, productInCart.id);
      quantityTotalAmountInCart += temp;
    });

    return quantityTotalAmountInCart;
  }

  Future<double> priceAmountInCart(dynamic userId, dynamic productId) async {
    double priceAmountInCart = 0;
    CartItemsData cartItemsData = CartItemsData();
    List<CartItem> cartItems = await cartItemsData.byUserId(userId);
    bool isInCart = cartItems.any((cartItem) => cartItem.productId == productId);

    if (isInCart) {
      CartItem cartItem = cartItems.firstWhere((cartItem) => cartItem.productId == productId);
      Product product = _products.firstWhere((product) => product.id == productId);
      priceAmountInCart = cartItem.quantity * product.price;
    }

    return priceAmountInCart;
  }

  Future<double> priceTotalAmountInCart(dynamic userId) async {
    double priceTotalAmountInCart = 0.0;
    List<Product> productsInCart = await this.thoseInTheCartByUserId(userId);

    // Loop in a Future:
    await Future.forEach(productsInCart, (productInCart) async {
      double temp = await this.priceAmountInCart(userId, productInCart.id);
      priceTotalAmountInCart += temp;
    });

    return priceTotalAmountInCart;
  }
}
