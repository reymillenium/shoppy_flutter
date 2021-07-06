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

class OrderedItemsData with ChangeNotifier {
  // Properties:
  static const sqliteTable = {
    'table_plural_name': 'ordered_items',
    'table_singular_name': 'ordered_item',
    'fields': [
      {
        'field_name': 'id',
        'field_type': 'INTEGER',
      },
      {
        'field_name': 'order_id',
        'field_type': 'INTEGER',
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
        'field_name': 'quantity',
        'field_type': 'INTEGER',
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
  List<OrderedItem> _orderedItems = [];
  DBHelper dbHelper;

  // Constructor:
  OrderedItemsData() {
    dbHelper = DBHelper();
    refresh();

    // dbHelper.deleteDb();
    // _generateDummyData();
  }

  // Getters:
  // get orderedItems {
  //   return _orderedItems;
  // }
  UnmodifiableListView<OrderedItem> get orderedItems {
    return UnmodifiableListView(_orderedItems);
  }

  // SQLite DB CRUD:
  Future<OrderedItem> _create(OrderedItem orderedItem, Map<String, dynamic> table) async {
    var dbClient = await dbHelper.dbPlus();
    orderedItem.id = await dbClient.insert(table['table_plural_name'], orderedItem.toMap());
    return orderedItem;
  }

  Future<List<dynamic>> _index(Map<String, dynamic> table) async {
    var dbClient = await dbHelper.dbPlus();
    List<Map> tableFields = table['fields'];
    List<Map> orderedItemsMaps = await dbClient.query(table['table_plural_name'], columns: tableFields.map<String>((field) => field['field_name']).toList());

    List<OrderedItem> orderedItemsList = [];
    if (orderedItemsMaps.length > 0) {
      for (int i = 0; i < orderedItemsMaps.length; i++) {
        OrderedItem orderedItem;
        orderedItem = OrderedItem.fromMap(orderedItemsMaps[i]);
        orderedItemsList.add(orderedItem);
      }
    }
    return orderedItemsList;
  }

  Future<int> _destroy(int id, Map<String, dynamic> table) async {
    var dbClient = await dbHelper.dbPlus();
    return await dbClient.delete(table['table_plural_name'], where: 'id = ?', whereArgs: [id]);
  }

  Future<int> _update(OrderedItem orderedItem, Map<String, dynamic> table) async {
    var dbClient = await dbHelper.dbPlus();
    return await dbClient.update(table['table_plural_name'], orderedItem.toMap(), where: 'id = ?', whereArgs: [orderedItem.id]);
  }

  // Private methods:
  void _generateDummyData() async {
    final List<OrderedItem> orderedItems = await _index(sqliteTable);
    final int currentLength = orderedItems.length;
    if (currentLength < _maxAmountDummyData) {
      for (int i = 0; i < (_maxAmountDummyData - currentLength); i++) {
        double price = NumericHelper.roundRandomDoubleInRange(min: 0.99, max: 9.99, places: 2);
        // double taxesAmount = price * 0.07;
        String title = faker.lorem.words(3).join(' ');
        String description = faker.lorem.sentences(4).join('. ') + '.';
        int quantity = NumericHelper.randomIntegerInRange(min: 1, max: 10);
        String imageUrl = ListHelper.randomFromList(DUMMY_PRODUCT_IMAGE_URLS);

        await addOrderedItem(orderId: 1, title: title, description: description, price: price, quantity: quantity, imageUrl: imageUrl);
      }
    }
  }

  void _removeWhere(int orderedItemId) async {
    // bool isFavorite = await this.isFavorite(userId, orderedItemId);
    // if (isFavorite) {
    //   await this.setAsNotFavorite(userId, orderedItemId);
    // }
    // bool isInCart = await this.isInCart(userId, orderedItemId);
    // if (isInCart) {
    //   CartItemsData cartItemsData = CartItemsData();
    //   await cartItemsData.deleteCartItemWithoutConfirm(userId, orderedItemId);
    // }
    await _destroy(orderedItemId, sqliteTable);
    await refresh();
  }

  // Public methods:
  Future refresh() async {
    _orderedItems = await _index(sqliteTable);
    notifyListeners();
  }

  Future<OrderedItem> addOrderedItem({int orderId, String title, String description, double price, int quantity, String imageUrl}) async {
    DateTime now = DateTime.now();
    OrderedItem newOrderedItem = OrderedItem(
      orderId: orderId,
      title: title,
      description: description,
      price: price,
      quantity: quantity,
      imageUrl: imageUrl,
      createdAt: now,
      updatedAt: now,
    );
    OrderedItem orderedItem = await _create(newOrderedItem, sqliteTable);
    refresh();
    return orderedItem;
  }

  Future<void> updateOrderedItem(int orderedItemId, String title, String description, double price, int quantity, String imageUrl) async {
    DateTime now = DateTime.now();
    OrderedItem updatingOrderedItem = _orderedItems.firstWhere((orderedItem) => orderedItemId == orderedItem.id);

    updatingOrderedItem.title = title;
    updatingOrderedItem.description = description;
    updatingOrderedItem.price = price;
    updatingOrderedItem.quantity = quantity;
    updatingOrderedItem.imageUrl = imageUrl;
    updatingOrderedItem.updatedAt = now;

    await _update(updatingOrderedItem, sqliteTable);
    refresh();
  }

  Future<void> deleteOrderedItemWithConfirm(int orderedItemId, BuildContext context, int orderId) {
    DialogHelper.showDialogPlus(orderedItemId, context, () => _removeWhere(orderedItemId)).then((value) {
      (context as Element).reassemble();
      refresh();
    });
  }

  void deleteOrderedItemWithoutConfirm(int id) {
    _removeWhere(id);
    refresh();
  }

  Future<List<OrderedItem>> byUserId(int userId, {List<String> filtersList}) async {
    var dbClient = await dbHelper.dbPlus();
    List<OrderedItem> orderedItemsList = [];
    filtersList = filtersList ?? [];
    String filteringString = (filtersList.isEmpty) ? '' : "(${filtersList.map((e) => "$e = 1").join(' OR ')}) AND ";

    // Gathering of the FavoriteProduct Maps based on the given userId:
    Map<String, Object> orderedItemsTable = OrderedItemsData.sqliteTable;
    String orderedItemsTableName = orderedItemsTable['table_plural_name'];
    List<Map> orderedItemsTableFields = orderedItemsTable['fields'];
    // List<Map> orderedItemsMaps = await dbClient.query(orderedItemsTableName, columns: orderedItemsTableFields.map<String>((field) => field['field_name']).toList(), where: 'user_id = ?', whereArgs: [userId]);
    List<Map> orderedItemsMaps = await dbClient.query(orderedItemsTableName, columns: orderedItemsTableFields.map<String>((field) => field['field_name']).toList(), where: '${filteringString}user_id = ?', whereArgs: [userId]);

    // Conversion into OrderedItem objects:
    if (orderedItemsMaps.length > 0) {
      for (int i = 0; i < orderedItemsMaps.length; i++) {
        OrderedItem favoriteProduct = OrderedItem.fromMap(orderedItemsMaps[i]);
        orderedItemsList.add(favoriteProduct);
      }
    }
    return orderedItemsList;
  }

// Future<int> quantityTotalInOrderedItemedItems(int userId, int orderedItemId) async {
//   int quantityTotalInOrderedItemedItems = 0;
//   OrderedItemedItemsData orderedItemedItemsData = OrderedItemedItemsData();
//   List<OrderedItemedItem> orderedItemedItems = await orderedItemedItemsData.byUserId(userId).map((orderedItemedItem) => orderedItemedItem.orderedItemId == orderedItemId).toList();
//
//   orderedItemedItems.forEach((orderedItemedItem) {
//     quantityTotalInOrderedItemedItems += orderedItemedItem.quantity;
//   });
//
//   return quantityTotalInOrderedItemedItems;
// }

// Future<double> priceTotalInOrderedItemedItems(int userId, int orderedItemId) async {
//   double priceTotalInOrderedItemedItems = 0;
//   OrderedItemedItemsData orderedItemedItemsData = OrderedItemedItemsData();
//   List<OrderedItemedItem> orderedItemedItems = await orderedItemedItemsData.byUserId(userId).map((orderedItemedItem) => orderedItemedItem.orderedItemId == orderedItemId).toList();
//
//   orderedItemedItems.forEach((orderedItemedItem) {
//     priceTotalInOrderedItemedItems += orderedItemedItem.price;
//   });
//
//   return priceTotalInOrderedItemedItems;
// }
}
