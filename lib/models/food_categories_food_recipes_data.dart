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

class ProductsFoodRecipesData with ChangeNotifier {
  // Properties:
  static const sqliteTable = {
    'table_plural_name': 'products_food_recipes',
    'table_singular_name': 'food_product_food_recipe',
    'fields': [
      {
        'field_name': 'id',
        'field_type': 'INTEGER',
      },
      {
        'field_name': 'food_product_id',
        'field_type': 'INTEGER',
      },
      {
        'field_name': 'food_recipe_id',
        'field_type': 'INTEGER',
      },
      {
        'field_name': 'createdAt',
        'field_type': 'TEXT',
      },
      {
        'field_name': 'updatedAt',
        'field_type': 'TEXT',
      },
    ],
  };
  final int _maxAmountDummyData = 12;
  List<ProductFoodRecipe> _productsFoodRecipes = [];
  DBHelper dbHelper;

  // Constructor:
  ProductsFoodRecipesData() {
    dbHelper = DBHelper();
    refresh();
    // _generateDummyData();
  }

  // Getters:
  // static get sqliteTable {
  //   return _sqliteTable;
  // }

  get productsFoodRecipes {
    return _productsFoodRecipes;
  }

  // SQLite DB CRUD:
  Future<ProductFoodRecipe> _create(ProductFoodRecipe productFoodRecipe, Map<String, dynamic> tableC, Map<String, dynamic> tableA, Map<String, dynamic> tableB) async {
    // var dbClient = await dbHelper.dbManyToManyTablePlus(tableC, tableA, tableB);
    var dbClient = await dbHelper.dbPlus();
    productFoodRecipe.id = await dbClient.insert(tableC['table_plural_name'], productFoodRecipe.toMap());
    return productFoodRecipe;
  }

  Future<List<dynamic>> _index(Map<String, dynamic> tableC, Map<String, dynamic> tableA, Map<String, dynamic> tableB) async {
    var dbClient = await dbHelper.dbPlus();
    List<Map> tableFields = tableC['fields'];
    List<Map> productFoodRecipeMaps = await dbClient.query(tableC['table_plural_name'], columns: tableFields.map<String>((field) => field['field_name']).toList());
    //List<Map> objectMaps = await dbClient.rawQuery("SELECT * FROM $TABLE");

    List<ProductFoodRecipe> productsFoodRecipesList = [];
    if (productFoodRecipeMaps.length > 0) {
      for (int i = 0; i < productFoodRecipeMaps.length; i++) {
        ProductFoodRecipe productFoodRecipe;
        productFoodRecipe = ProductFoodRecipe.fromMap(productFoodRecipeMaps[i]);
        productsFoodRecipesList.add(productFoodRecipe);
      }
    }
    return productsFoodRecipesList;
  }

  Future<int> _destroy(int id, Map<String, dynamic> tableC, Map<String, dynamic> tableA, Map<String, dynamic> tableB) async {
    var dbClient = await dbHelper.dbPlus();
    return await dbClient.delete(tableC['table_plural_name'], where: 'id = ?', whereArgs: [id]);
  }

  Future<int> _update(ProductFoodRecipe productFoodRecipe, Map<String, dynamic> tableC, Map<String, dynamic> tableA, Map<String, dynamic> tableB) async {
    var dbClient = await dbHelper.dbPlus();
    return await dbClient.update(tableC['table_plural_name'], productFoodRecipe.toMap(), where: 'id = ?', whereArgs: [productFoodRecipe.id]);
  }

  // Private methods:
  void _generateDummyData() async {
    final List<ProductFoodRecipe> productsFoodRecipesList = await _index(sqliteTable, ProductsData.sqliteTable, FoodRecipesData.sqliteTable);
    final int currentLength = productsFoodRecipesList.length;
    if (currentLength < _maxAmountDummyData) {
      for (int i = 0; i < (_maxAmountDummyData - currentLength); i++) {
        // String title = faker.food.dish();
        // // Color color = ColorHelper.randomColor();
        // Color color = ColorHelper.randomMaterialColor();
        // await addProduct(title, color);
      }
    }
  }

  void _removeWhere(int id) async {
    await _destroy(id, sqliteTable, ProductsData.sqliteTable, FoodRecipesData.sqliteTable);
    await refresh();
  }

  // Public methods:
  Future refresh() async {
    _productsFoodRecipes = await _index(sqliteTable, ProductsData.sqliteTable, FoodRecipesData.sqliteTable);
    notifyListeners();
  }

  Future<void> addProductFoodRecipe(int productId, int foodRecipeId) async {
    DateTime now = DateTime.now();

    ProductFoodRecipe newProductFoodRecipe = ProductFoodRecipe(
      productId: productId,
      foodRecipeId: foodRecipeId,
      createdAt: now,
      updatedAt: now,
    );
    await _create(newProductFoodRecipe, sqliteTable, ProductsData.sqliteTable, FoodRecipesData.sqliteTable);
    refresh();
  }

  Future<void> updateProductFoodRecipe(int id, int productId, int foodRecipeId) async {
    DateTime now = DateTime.now();
    ProductFoodRecipe updatingProductFoodRecipe = _productsFoodRecipes.firstWhere((productFoodRecipe) => id == productFoodRecipe.id);

    updatingProductFoodRecipe.productId = productId;
    updatingProductFoodRecipe.foodRecipeId = foodRecipeId;
    updatingProductFoodRecipe.updatedAt = now;

    await _update(updatingProductFoodRecipe, sqliteTable, ProductsData.sqliteTable, FoodRecipesData.sqliteTable);
    refresh();
  }

  Future<void> deleteProductFoodRecipeWithConfirm(int id, BuildContext context) {
    DialogHelper.showDialogPlus(id, context, () => _removeWhere(id)).then((value) {
      (context as Element).reassemble();
      refresh();
    });
  }

  void deleteProductFoodRecipeWithoutConfirm(int id) {
    _removeWhere(id);
    // refresh();
  }
}
