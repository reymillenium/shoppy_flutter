// Packages:

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

class OrdersData with ChangeNotifier {
  // Properties:
  static const sqliteTable = {
    'table_plural_name': 'orders',
    'table_singular_name': 'order',
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
        'field_name': 'taxes_amount',
        'field_type': 'REAL',
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
  List<Order> _orders = [];
  DBHelper dbHelper;

  // Constructor:
  OrdersData() {
    dbHelper = DBHelper();
    refresh();

    // dbHelper.deleteDb();
    // _generateDummyData();
  }

  // Getters:
  // get orders {
  //   return _orders;
  // }
  UnmodifiableListView<Order> get orders {
    return UnmodifiableListView(_orders);
  }

  // SQLite DB CRUD:
  Future<Order> _create(Order order, Map<String, dynamic> table) async {
    var dbClient = await dbHelper.dbPlus();
    order.id = await dbClient.insert(table['table_plural_name'], order.toMap());
    return order;
  }

  Future<List<dynamic>> _index(Map<String, dynamic> table) async {
    var dbClient = await dbHelper.dbPlus();
    List<Map> tableFields = table['fields'];
    List<Map> ordersMaps = await dbClient.query(table['table_plural_name'], columns: tableFields.map<String>((field) => field['field_name']).toList());

    List<Order> ordersList = [];
    if (ordersMaps.length > 0) {
      for (int i = 0; i < ordersMaps.length; i++) {
        Order order;
        order = Order.fromMap(ordersMaps[i]);
        ordersList.add(order);
      }
    }
    return ordersList;
  }

  Future<int> _destroy(int id, Map<String, dynamic> table) async {
    var dbClient = await dbHelper.dbPlus();
    return await dbClient.delete(table['table_plural_name'], where: 'id = ?', whereArgs: [id]);
  }

  Future<int> _update(Order order, Map<String, dynamic> table) async {
    var dbClient = await dbHelper.dbPlus();
    return await dbClient.update(table['table_plural_name'], order.toMap(), where: 'id = ?', whereArgs: [order.id]);
  }

  // Private methods:
  void _generateDummyData() async {
    final List<Order> orders = await _index(sqliteTable);
    final int currentLength = orders.length;
    if (currentLength < _maxAmountDummyData) {
      for (int i = 0; i < (_maxAmountDummyData - currentLength); i++) {
        double price = NumericHelper.roundRandomDoubleInRange(min: 0.99, max: 9.99, places: 2);
        double taxesAmount = price * 0.07;
        await addOrder(userId: 1, taxesAmount: taxesAmount);
      }
    }
  }

  void _removeWhere(int orderId, int userId) async {
    // bool isFavorite = await this.isFavorite(userId, orderId);
    // if (isFavorite) {
    //   await this.setAsNotFavorite(userId, orderId);
    // }
    // bool isInCart = await this.isInCart(userId, orderId);
    // if (isInCart) {
    //   CartItemsData cartItemsData = CartItemsData();
    //   await cartItemsData.deleteCartItemWithoutConfirm(userId, orderId);
    // }
    await _destroy(orderId, sqliteTable);
    await refresh();
  }

  // Public methods:
  Future refresh() async {
    _orders = await _index(sqliteTable);
    notifyListeners();
  }

  Future<Order> addOrder({int userId, double taxesAmount}) async {
    DateTime now = DateTime.now();
    Order newOrder = Order(
      userId: userId,
      taxesAmount: taxesAmount,
      createdAt: now,
      updatedAt: now,
    );
    Order order = await _create(newOrder, sqliteTable);
    refresh();
    return order;
  }

  Future<void> updateOrder(int orderId, double taxesAmount) async {
    DateTime now = DateTime.now();
    Order updatingOrder = _orders.firstWhere((order) => orderId == order.id);

    updatingOrder.taxesAmount = taxesAmount;
    updatingOrder.updatedAt = now;

    await _update(updatingOrder, sqliteTable);
    refresh();
  }

  Future<void> deleteOrderWithConfirm(int orderId, BuildContext context, int userId) {
    DialogHelper.showDialogPlus(orderId, context, () => _removeWhere(orderId, userId)).then((value) {
      (context as Element).reassemble();
      refresh();
    });
  }

  void deleteOrderWithoutConfirm(int id, int userId) {
    _removeWhere(id, userId);
    refresh();
  }

  Future<List<Order>> byUserId(int userId, {List<String> filtersList}) async {
    var dbClient = await dbHelper.dbPlus();
    List<Order> ordersList = [];
    filtersList = filtersList ?? [];
    String filteringString = (filtersList.isEmpty) ? '' : "(${filtersList.map((e) => "$e = 1").join(' OR ')}) AND ";

    // Gathering of the FavoriteProduct Maps based on the given userId:
    Map<String, Object> ordersTable = OrdersData.sqliteTable;
    String ordersTableName = ordersTable['table_plural_name'];
    List<Map> ordersTableFields = ordersTable['fields'];
    // List<Map> ordersMaps = await dbClient.query(ordersTableName, columns: ordersTableFields.map<String>((field) => field['field_name']).toList(), where: 'user_id = ?', whereArgs: [userId]);
    List<Map> ordersMaps = await dbClient.query(ordersTableName, columns: ordersTableFields.map<String>((field) => field['field_name']).toList(), where: '${filteringString}user_id = ?', whereArgs: [userId]);

    // Conversion into Order objects:
    if (ordersMaps.length > 0) {
      for (int i = 0; i < ordersMaps.length; i++) {
        Order favoriteProduct = Order.fromMap(ordersMaps[i]);
        ordersList.add(favoriteProduct);
      }
    }
    return ordersList;
  }

  Future<int> quantityTotalInOrderedItems(int userId, int orderId) async {
    int quantityTotalInOrderedItems = 0;
    OrderedItemsData orderedItemsData = OrderedItemsData();
    List<OrderedItem> orderedItemsByUser = await orderedItemsData.byUserId(userId);
    List<OrderedItem> orderedItemsByUserAndOrder = orderedItemsByUser.where((orderedItem) => orderedItem.orderId == orderId).toList();

    orderedItemsByUserAndOrder.forEach((orderedItem) {
      quantityTotalInOrderedItems += orderedItem.quantity;
    });

    return quantityTotalInOrderedItems;
  }

  Future<double> priceTotalInOrderedItems(int userId, int orderId) async {
    double priceTotalInOrderedItems = 0;
    OrderedItemsData orderedItemsData = OrderedItemsData();
    List<OrderedItem> orderedItemsByUser = await orderedItemsData.byUserId(userId);
    List<OrderedItem> orderedItemsByUserAndOrder = orderedItemsByUser.where((orderedItem) => orderedItem.orderId == orderId).toList();

    orderedItemsByUserAndOrder.forEach((orderedItem) {
      priceTotalInOrderedItems += orderedItem.price;
    });

    return priceTotalInOrderedItems;
  }
}
