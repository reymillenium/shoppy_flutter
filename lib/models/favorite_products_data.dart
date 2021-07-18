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

class FavoriteProductsData with ChangeNotifier {
  // Properties:
  static const sqliteTable = {
    'table_plural_name': 'favorite_products',
    'table_singular_name': 'favorite_product',
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
  List<FavoriteProduct> _favoriteProducts = [];
  DBHelper dbHelper;
  FirebaseRealtimeDBHelper firebaseRealtimeDBHelper;

  // Constructor:
  FavoriteProductsData() {
    // dbHelper = DBHelper();
    firebaseRealtimeDBHelper = FirebaseRealtimeDBHelper();
    refresh();
    // _generateDummyData();
  }

  // Getter:
  get favoriteProducts {
    return _favoriteProducts;
  }

  // SQLite DB || Firebase Realtime DB CRUD:
  Future<FavoriteProduct> _create(FavoriteProduct favoriteProduct, Map<String, dynamic> table) async {
    // SQLite DB:
    // var dbClient = await dbHelper.dbPlus();
    // favoriteProduct.id = await dbClient.insert(table['table_plural_name'], favoriteProduct.toMap());

    // Firebase Realtime DB:
    Response postResponse = await firebaseRealtimeDBHelper.postData(
      protocol: 'https',
      authority: firebaseRealtimeAuthorityURL,
      unencodedPath: '/${sqliteTable['table_plural_name']}.json',
      body: json.encode(favoriteProduct.toMap()),
    );
    Map<String, dynamic> postResponseBody = jsonDecode(postResponse.body);
    favoriteProduct.id = postResponseBody['name'];
    return favoriteProduct;
  }

  Future<List<dynamic>> _index(Map<String, dynamic> table) async {
    List<FavoriteProduct> favoriteProductsList = [];
    // SQLite DB:
    // var dbClient = await dbHelper.dbPlus();
    // List<Map> tableFields = table['fields'];
    // List<Map> favoriteProductsMaps = await dbClient.query(table['table_plural_name'], columns: tableFields.map<String>((field) => field['field_name']).toList());
    //
    // if (favoriteProductsMaps.length > 0) {
    //   for (int i = 0; i < favoriteProductsMaps.length; i++) {
    //     FavoriteProduct favoriteProduct;
    //     favoriteProduct = FavoriteProduct.fromMap(favoriteProductsMaps[i]);
    //     favoriteProductsList.add(favoriteProduct);
    //   }
    // }

    // Firebase Realtime DB:
    Response getResponse = await firebaseRealtimeDBHelper.getData(
      protocol: 'https',
      authority: firebaseRealtimeAuthorityURL,
      unencodedPath: '/${sqliteTable['table_plural_name']}.json',
    );
    Map<String, dynamic> getResponseBody = jsonDecode(getResponse.body);
    if (getResponseBody.length > 0) {
      getResponseBody.forEach((key, value) {
        FavoriteProduct favoriteProduct;
        favoriteProduct = FavoriteProduct.fromMap(getResponseBody[key]);
        favoriteProduct.id = key;
        favoriteProductsList.add(favoriteProduct);
      });
    }

    return favoriteProductsList;
  }

  Future<List<FavoriteProduct>> byUserId(dynamic userId, {List<String> filtersList}) async {
    List<FavoriteProduct> favoriteProductsList = [];
    // SQLite DB:
    // var dbClient = await dbHelper.dbPlus();
    // filtersList = filtersList ?? [];
    // String filteringString = (filtersList.isEmpty) ? '' : "(${filtersList.map((e) => "$e = 1").join(' OR ')}) AND ";
    //
    // // Gathering of the FavoriteProduct Maps based on the given userId:
    // Map<String, Object> favoriteProductsTable = FavoriteProductsData.sqliteTable;
    // String favoriteProductsTableName = favoriteProductsTable['table_plural_name'];
    // List<Map> favoriteProductsTableFields = favoriteProductsTable['fields'];
    // List<Map> favoriteProductsMaps = await dbClient.query(favoriteProductsTableName, columns: favoriteProductsTableFields.map<String>((field) => field['field_name']).toList(), where: 'user_id = ?', whereArgs: [userId]);
    //
    // // Conversion into FavoriteProduct objects:
    // if (favoriteProductsMaps.length > 0) {
    //   for (int i = 0; i < favoriteProductsMaps.length; i++) {
    //     FavoriteProduct favoriteProduct = FavoriteProduct.fromMap(favoriteProductsMaps[i]);
    //     favoriteProductsList.add(favoriteProduct);
    //   }
    // }

    // Firebase Realtime DB:
    Response getResponse = await firebaseRealtimeDBHelper.getData(
      protocol: 'https',
      authority: firebaseRealtimeAuthorityURL,
      unencodedPath: '/${sqliteTable['table_plural_name']}.json',
      queryParameters: {'userId': '$userId'},
    );
    Map<String, dynamic> getResponseBody = {};
    getResponseBody = jsonDecode(getResponse.body);
    if (getResponseBody != null && getResponseBody.length > 0) {
      getResponseBody.forEach((key, value) {
        FavoriteProduct favoriteProduct;
        favoriteProduct = FavoriteProduct.fromMap(getResponseBody[key]);
        favoriteProduct.id = key;
        favoriteProductsList.add(favoriteProduct);
      });
    }

    return favoriteProductsList;
  }

  Future<dynamic> _destroy(dynamic userId, dynamic productId, Map<String, dynamic> table) async {
    // SQLite DB:
    // var dbClient = await dbHelper.dbPlus();
    // return await dbClient.delete(table['table_plural_name'], where: 'user_id = ? AND product_id = ?', whereArgs: [userId, productId]);

    // Firebase Realtime DB:
    List<FavoriteProduct> favoriteProductsList = await _index(sqliteTable);
    // Gets the specific FavoriteProduct object:
    FavoriteProduct favoriteProduct = favoriteProductsList.firstWhere((favoriteProduct) => (favoriteProduct.userId == userId && favoriteProduct.productId == productId));
    Response deleteResponse = await firebaseRealtimeDBHelper.deleteData(
      protocol: 'https',
      authority: firebaseRealtimeAuthorityURL,
      unencodedPath: '/${sqliteTable['table_plural_name']}/${favoriteProduct.id}.json',
    );
    return deleteResponse.statusCode == 200;
  }

  Future<dynamic> _update(FavoriteProduct favoriteProduct, Map<String, dynamic> table) async {
    // SQLite DB:
    // var dbClient = await dbHelper.dbPlus();
    // return await dbClient.update(table['table_plural_name'], favoriteProduct.toMap(), where: 'id = ?', whereArgs: [favoriteProduct.id]);

    // Firebase Realtime DB:
    Response response = await firebaseRealtimeDBHelper.updateData(
      protocol: 'https',
      authority: firebaseRealtimeAuthorityURL,
      unencodedPath: '/${sqliteTable['table_plural_name']}/${favoriteProduct.id}.json',
      body: json.encode(favoriteProduct.toMap()),
    );
    return response.statusCode == 200;
  }

  // Private methods:

  Future<void> _removeWhere(dynamic userId, dynamic productId) async {
    await _destroy(userId, productId, sqliteTable);
    await refresh();
  }

  // Public methods:
  Future refresh() async {
    try {
      _favoriteProducts = await _index(sqliteTable);
    } catch (error) {}
    notifyListeners();
  }

  Future<FavoriteProduct> addFavoriteProduct({
    dynamic userId,
    dynamic productId,
  }) async {
    DateTime now = DateTime.now();

    // TODO: Check that this is fine
    FavoriteProduct newFavoriteProduct = FavoriteProduct(
      userId: userId,
      productId: productId,
      createdAt: now,
      updatedAt: now,
    );
    FavoriteProduct favoriteProduct = await _create(newFavoriteProduct, sqliteTable);
    await refresh();
    return favoriteProduct;
  }

  Future<void> updateFavoriteProduct(
    dynamic id,
    dynamic userId,
    dynamic productId,
  ) async {
    DateTime now = DateTime.now();
    FavoriteProduct updatingFavoriteProduct = _favoriteProducts.firstWhere((favoriteProduct) => id == favoriteProduct.id);

    updatingFavoriteProduct.userId = userId;
    updatingFavoriteProduct.productId = productId;
    updatingFavoriteProduct.updatedAt = now;

    await _update(updatingFavoriteProduct, sqliteTable);
    refresh();
  }

  Future<void> deleteFavoriteProductWithConfirm(dynamic userId, dynamic productId, BuildContext context) {
    DialogHelper.showDialogWithActionPlus(context, () => _removeWhere(userId, productId)).then((value) {
      // This commenting, fixes an exception when deleting
      // (context as Element).reassemble();
      refresh();
    });
  }

  Future<void> deleteFavoriteProductWithoutConfirm(dynamic userId, dynamic productId) async {
    await _removeWhere(userId, productId);
    refresh();
  }
}
