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

  Future<int> _destroy(dynamic id, Map<String, dynamic> table) async {
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

  void _removeWhere(dynamic orderId) async {
    // First mwe must eliminate the related OrderedItem object from the database:
    OrderedItemsData orderedItemsData = OrderedItemsData();
    List<OrderedItem> orderedItems = orderedItemsData.orderedItems.where((orderedItem) => orderedItem.orderId == orderId);
    // Loop in a Future: Destroys each one of the related OrderedItem objects:
    await Future.forEach(orderedItems, (orderedItem) async {
      await orderedItemsData.deleteOrderedItemWithoutConfirm(orderedItem.id);
    });

    await _destroy(orderId, sqliteTable);
    await refresh();
  }

  // Public methods:
  Future refresh() async {
    _orders = await _index(sqliteTable);
    notifyListeners();
  }

  Future<Order> addOrder({dynamic userId, double taxesAmount, List<CartItem> cartItems}) async {
    DateTime now = DateTime.now();
    Order newOrder = Order(
      userId: userId,
      taxesAmount: taxesAmount,
      createdAt: now,
      updatedAt: now,
    );
    Order order = await _create(newOrder, sqliteTable);
    // ProductsData productsData = Provider.of<ProductsData>(context, listen: false); // Lets try this way later (could solve triggering of notifyListeners() remotely)
    ProductsData productsData = ProductsData();
    OrderedItemsData orderedItemsData = OrderedItemsData();
    // CartItemsData cartItemsData = CartItemsData();

    // Loop in a Future: Creates each one of the related OrderedItem objects:
    await Future.forEach(cartItems, (cartItem) async {
      List<Product> products = await productsData.thoseInTheCartByUserId(userId);
      Product product = products.firstWhere((product) => product.id == cartItem.productId);

      await orderedItemsData.addOrderedItem(
        orderId: order.id,
        title: product.title,
        imageUrl: product.imageUrl,
        quantity: cartItem.quantity,
        price: product.price,
        description: product.description,
      );

      // And finally we destroy the CartItem object: (will be triggered directly on ProductsData, so the widget tree gets updated)
      // await cartItemsData.deleteCartItemWithoutConfirm(userId, product.id);
    });

    refresh();
    return order;
  }

  Future<void> updateOrder(dynamic orderId, double taxesAmount) async {
    DateTime now = DateTime.now();
    Order updatingOrder = _orders.firstWhere((order) => orderId == order.id);

    updatingOrder.taxesAmount = taxesAmount;
    updatingOrder.updatedAt = now;

    await _update(updatingOrder, sqliteTable);
    refresh();
  }

  Future<void> deleteOrderWithConfirm(dynamic orderId, BuildContext context, dynamic userId) {
    DialogHelper.showDialogWithActionPlus(context, () => _removeWhere(orderId)).then((value) {
      (context as Element).reassemble();
      refresh();
    });
  }

  void deleteOrderWithoutConfirm(dynamic id, dynamic userId) {
    _removeWhere(id);
    refresh();
  }

  Future<List<Order>> byUserId(dynamic userId, {List<String> filtersList}) async {
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

  Future<int> quantityTotalInOrderedItems(dynamic userId, dynamic orderId) async {
    int quantityTotalInOrderedItems = 0;
    OrderedItemsData orderedItemsData = OrderedItemsData();
    List<OrderedItem> orderedItemsByUser = await orderedItemsData.byOrderId(orderId);
    List<OrderedItem> orderedItemsByUserAndOrder = orderedItemsByUser.where((orderedItem) => orderedItem.orderId == orderId).toList();

    orderedItemsByUserAndOrder.forEach((orderedItem) {
      quantityTotalInOrderedItems += orderedItem.quantity;
    });

    return quantityTotalInOrderedItems;
  }

  Future<double> priceTotalInOrderedItems(dynamic userId, dynamic orderId) async {
    double priceTotalInOrderedItems = 0;
    OrderedItemsData orderedItemsData = OrderedItemsData();
    List<OrderedItem> orderedItemsByUser = await orderedItemsData.byOrderId(orderId);
    List<OrderedItem> orderedItemsByUserAndOrder = orderedItemsByUser.where((orderedItem) => orderedItem.orderId == orderId).toList();

    orderedItemsByUserAndOrder.forEach((orderedItem) {
      priceTotalInOrderedItems += orderedItem.price;
    });

    return priceTotalInOrderedItems;
  }
}
