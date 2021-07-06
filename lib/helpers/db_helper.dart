// Packages:

import '../_inner_packages.dart';
import '../_external_packages.dart';

// Models:
import '../models/_models.dart';

// Helpers:

// Utilities:

class DBHelper {
  static Database _db;
  static const String DB_NAME = 'shoppy.db';

  Future<Database> dbPlus() async {
    if (_db != null) {
      return _db;
    }
    _db = await initDbPlus();
    return _db;
  }

  initDbPlus() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    // deleteDatabase(path);
    // var db = await openDatabase(path, version: 1, onCreate: (Database db, int version) => _onCreatePlus(db, version));
    var db = await openDatabase(path, version: 1, onCreate: _onCreatePlus);
    return db;
  }

  deleteDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    deleteDatabase(path);
  }

  _onCreatePlus(Database db, int version) async {
    // products table:
    Map<String, Object> productsTable = ProductsData.sqliteTable;
    await _createTable(db, 1, productsTable);

    // favorite_products table:
    Map<String, Object> favoriteProductsTable = FavoriteProductsData.sqliteTable;
    await _createTable(db, 1, favoriteProductsTable);

    // cart_items table:
    Map<String, Object> cartItemsTable = CartItemsData.sqliteTable;
    await _createTable(db, 1, cartItemsTable);

    // orders table:
    Map<String, Object> ordersTable = OrdersData.sqliteTable;
    await _createTable(db, 1, ordersTable);

    // ordered_items table:
    Map<String, Object> orderItemsTable = OrderedItemsData.sqliteTable;
    await _createTable(db, 1, orderItemsTable);

    // products_food_recipes table:
    // Map<String, Object> productsFoodRecipesTable = ProductsFoodRecipesData.sqliteTable;
    // await _onCreateManyToManyTablePlus(db, 1, productsFoodRecipesTable, productsTable, foodRecipesTable);
  }

  _createTable(Database db, int version, Map<String, dynamic> table) async {
    String tableName = table['table_plural_name'];
    List<Map> fields = table['fields'];
    String tableFieldsString = '';
    fields.forEach((field) {
      String fieldName = field['field_name'];
      String fieldType = field['field_type'];
      tableFieldsString += "${fieldName == 'id' ? 'id INTEGER PRIMARY KEY' : ', '}${fieldName == 'id' ? '' : '$fieldName $fieldType'}";
    });
    String finalSQLSentence = "CREATE TABLE IF NOT EXISTS $tableName ($tableFieldsString)";
    await db.execute(finalSQLSentence);
  }

  _onCreateManyToManyTablePlus(Database db, int version, Map<String, dynamic> tableC, Map<String, dynamic> tableA, Map<String, dynamic> tableB) async {
    await db.execute("""
            CREATE TABLE IF NOT EXISTS ${tableC['table_plural_name']} (
              id INTEGER PRIMARY KEY, 
              ${tableA['table_singular_name']}_id INTEGER NOT NULL,
              ${tableB['table_singular_name']}_id INTEGER NOT NULL,
              createdAt TEXT,
              updatedAt TEXT,
              FOREIGN KEY (${tableA['table_singular_name']}_id) REFERENCES ${tableA['table_plural_name']} (id) 
                ON DELETE NO ACTION ON UPDATE NO ACTION,
              FOREIGN KEY (${tableB['table_singular_name']}_id) REFERENCES ${tableB['table_plural_name']} (id) 
                ON DELETE NO ACTION ON UPDATE NO ACTION
            )""");
  }

  Future closePlus() async {
    var dbClient = await dbPlus();
    dbClient.close();
  }
}
