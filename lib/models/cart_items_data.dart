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

class CartItemsData with ChangeNotifier {
  // Properties:
  static const sqliteTable = {
    'table_plural_name': 'cart_items',
    'table_singular_name': 'cart_item',
    'fields': [
      {
        'field_name': 'id',
        'field_type': 'INTEGER',
      },
      {
        'field_name': 'user_id',
        'field_type': 'INTEGER',
      },
      {
        'field_name': 'product_id',
        'field_type': 'INTEGER',
      },
      {
        'field_name': 'quantity',
        'field_type': 'INTEGER',
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
  List<CartItem> _cartItems = [];
  DBHelper dbHelper;

  // Constructor:
  CartItemsData() {
    dbHelper = DBHelper();
    refresh();
    // _generateDummyData();
  }

  // get cartItems {
  //   return _cartItems;
  // }

  UnmodifiableListView<CartItem> get cartItems {
    return UnmodifiableListView(_cartItems);
  }

  // UnmodifiableListView<CartItem> get cartItems {
  //   return UnmodifiableListView(_cartItems);
  // }

  // SQLite DB CRUD:
  Future<CartItem> _create(CartItem cartItem, Map<String, dynamic> table) async {
    var dbClient = await dbHelper.dbPlus();
    cartItem.id = await dbClient.insert(table['table_plural_name'], cartItem.toMap());
    return cartItem;
  }

  Future<List<dynamic>> _index(Map<String, dynamic> table) async {
    var dbClient = await dbHelper.dbPlus();
    List<Map> tableFields = table['fields'];
    List<Map> cartItemsMaps = await dbClient.query(table['table_plural_name'], columns: tableFields.map<String>((field) => field['field_name']).toList());

    List<CartItem> cartItemsList = [];
    if (cartItemsMaps.length > 0) {
      for (int i = 0; i < cartItemsMaps.length; i++) {
        CartItem cartItem;
        cartItem = CartItem.fromMap(cartItemsMaps[i]);
        cartItemsList.add(cartItem);
      }
    }
    return cartItemsList;
  }

  Future<List<CartItem>> byUserId(int userId, {List<String> filtersList}) async {
    var dbClient = await dbHelper.dbPlus();
    List<CartItem> cartItemsList = [];
    filtersList = filtersList ?? [];
    String filteringString = (filtersList.isEmpty) ? '' : "(${filtersList.map((e) => "$e = 1").join(' OR ')}) AND ";

    // Gathering of the CartItem Maps based on the given userId:
    Map<String, Object> cartItemsTable = CartItemsData.sqliteTable;
    String cartItemsTableName = cartItemsTable['table_plural_name'];
    List<Map> cartItemsTableFields = cartItemsTable['fields'];
    List<Map> cartItemsMaps = await dbClient.query(cartItemsTableName, columns: cartItemsTableFields.map<String>((field) => field['field_name']).toList(), where: 'user_id = ?', whereArgs: [userId]);

    // Conversion into CartItem objects:
    if (cartItemsMaps.length > 0) {
      for (int i = 0; i < cartItemsMaps.length; i++) {
        CartItem cartItem = CartItem.fromMap(cartItemsMaps[i]);
        cartItemsList.add(cartItem);
      }
    }
    return cartItemsList;
  }

  Future<int> _destroy(int userId, int productId, Map<String, dynamic> table) async {
    var dbClient = await dbHelper.dbPlus();
    return await dbClient.delete(table['table_plural_name'], where: 'user_id = ? AND product_id = ?', whereArgs: [userId, productId]);
  }

  Future<int> _update(CartItem cartItem, Map<String, dynamic> table) async {
    var dbClient = await dbHelper.dbPlus();
    return await dbClient.update(table['table_plural_name'], cartItem.toMap(), where: 'id = ?', whereArgs: [cartItem.id]);
  }

  // Private methods:

  Future<void> _removeWhere(int userId, int productId) async {
    await _destroy(userId, productId, sqliteTable);
    await refresh();
  }

  // Public methods:
  Future refresh() async {
    try {
      _cartItems = await _index(sqliteTable);
    } catch (error) {}
    notifyListeners();
  }

  Future<CartItem> addCartItem({
    int userId,
    int productId,
    int quantity,
  }) async {
    DateTime now = DateTime.now();

    // TODO: Check that this is fine
    CartItem newCartItem = CartItem(
      userId: userId,
      productId: productId,
      quantity: quantity,
      createdAt: now,
      updatedAt: now,
    );
    CartItem cartItem = await _create(newCartItem, sqliteTable);
    await refresh();
    return cartItem;
  }

  Future<void> updateCartItem(
    int id,
    // int userId,
    // int productId,
    int quantity,
  ) async {
    DateTime now = DateTime.now();
    CartItem updatingCartItem = _cartItems.firstWhere((cartItem) => id == cartItem.id);

    // updatingCartItem.userId = userId;
    // updatingCartItem.productId = productId;
    updatingCartItem.quantity = quantity;
    updatingCartItem.updatedAt = now;

    await _update(updatingCartItem, sqliteTable);
    refresh();
  }

  Future<void> deleteCartItemWithConfirm(int userId, int productId, BuildContext context) {
    DialogHelper.showDialogPlus(productId, context, () => _removeWhere(userId, productId)).then((value) {
      // This commenting, fixes an exception when deleting
      // (context as Element).reassemble();
      refresh();
    });
  }

  Future<void> deleteCartItemWithoutConfirm(int userId, int productId) {
    _removeWhere(userId, productId);
    refresh();
  }
}
