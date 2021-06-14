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
import '../utilities/constants.dart';

class ProductsData with ChangeNotifier {
  // Properties:
  static const sqliteTable = {
    'table_plural_name': 'products',
    'table_singular_name': 'food_product',
    'fields': [
      {
        'field_name': 'id',
        'field_type': 'INTEGER',
      },
      {
        'field_name': 'title',
        'field_type': 'TEXT',
      },
      {
        'field_name': 'color',
        'field_type': 'TEXT',
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
  List<Product> _products = [];
  DBHelper dbHelper;

  // Constructor:
  ProductsData() {
    dbHelper = DBHelper();
    refresh();

    // dbHelper.deleteDb();
    _generateDummyData();
  }

  // Getters:
  get products {
    return _products;
  }

  // SQLite DB CRUD:
  Future<Product> _create(Product product, Map<String, dynamic> table) async {
    var dbClient = await dbHelper.dbPlus();
    product.id = await dbClient.insert(table['table_plural_name'], product.toMap());
    return product;
  }

  Future<List<dynamic>> _index(Map<String, dynamic> table) async {
    var dbClient = await dbHelper.dbPlus();
    List<Map> tableFields = table['fields'];
    List<Map> productsMaps = await dbClient.query(table['table_plural_name'], columns: tableFields.map<String>((field) => field['field_name']).toList());
    //List<Map> objectMaps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    // var dbClientJoinedTables = await dbHelper.dbManyToManyTablePlus(productsFoodRecipesData.sqliteTable, table, FoodRecipesData.sqliteTable);

    List<Product> productsList = [];
    if (productsMaps.length > 0) {
      for (int i = 0; i < productsMaps.length; i++) {
        Product product;
        product = Product.fromMap(productsMaps[i]);
        // Declaration of temporal empty lists:
        // List<FoodCategoryFoodRecipe> foodCategoriesFoodRecipesList = [];
        // List<FoodRecipe> foodRecipesList = [];

        // try {
        //   // Gathering on the join table (food_categories_food_recipes) by the foodCategoryId:
        //   List<Map> foodCategoriesFoodRecipesTableFields = FoodCategoriesFoodRecipesData.sqliteTable['fields'];
        //   String foodCategoriesFoodRecipesTableName = FoodCategoriesFoodRecipesData.sqliteTable['table_plural_name'];
        //
        //   List<Map> foodCategoriesFoodRecipesMaps = await dbClient.query(foodCategoriesFoodRecipesTableName, columns: foodCategoriesFoodRecipesTableFields.map<String>((field) => field['field_name']).toList(), where: 'food_category_id = ?', whereArgs: [foodCategory.id]);
        //   if (foodCategoriesFoodRecipesMaps.length > 0) {
        //     // If the FoodCategory object has at least one associated FoodRecipe...
        //     for (int j = 0; j < foodCategoriesFoodRecipesMaps.length; j++) {
        //       FoodCategoryFoodRecipe foodCategoryFoodRecipe;
        //       foodCategoryFoodRecipe = FoodCategoryFoodRecipe.fromMap(foodCategoriesFoodRecipesMaps[j]);
        //       // Adding the FoodCategoryFoodRecipe object to the temporal list:
        //       foodCategoriesFoodRecipesList.add(foodCategoryFoodRecipe);
        //     }
        //
        //     List<int> foodRecipesIdsList = foodCategoriesFoodRecipesList.map((foodCategoryFoodRecipe) => foodCategoryFoodRecipe.foodRecipeId).toList();
        //     // Gathering of its FoodRecipe objects based on then possibly gathered FoodCategoryFoodRecipe objects:
        //     List<Map> foodRecipesTableFields = FoodRecipesData.sqliteTable['fields'];
        //     // List<Map> foodRecipesMaps = await dbClient.query(FoodRecipesData.sqliteTable['table_plural_name'], columns: foodRecipesTableFields.map<String>((field) => field['field_name']).toList(), where: 'id = ?', whereArgs: foodRecipesIdsList);
        //     List<Map> foodRecipesMaps = await dbClient.query(FoodRecipesData.sqliteTable['table_plural_name'], columns: foodRecipesTableFields.map<String>((field) => field['field_name']).toList(), where: 'id IN (${foodRecipesIdsList.map((e) => "'$e'").join(', ')})');
        //
        //     for (int k = 0; k < foodRecipesMaps.length; k++) {
        //       FoodRecipe foodRecipe;
        //       foodRecipe = FoodRecipe.fromMap(foodRecipesMaps[k]);
        //       // Adding the FoodCategoryFoodRecipe object to the temporal list:
        //       foodRecipesList.add(foodRecipe);
        //     }
        //   }
        // } catch (error) {
        //   // No rows on the join table or there is any other error there.
        //   print(error);
        // }

        // product.foodRecipes = foodRecipesList;
        // Adding the Product object with everything inside to the list:
        productsList.add(product);
      }
    }
    return productsList;
  }

  Future<int> _destroy(int id, Map<String, dynamic> table) async {
    var dbClient = await dbHelper.dbPlus();
    return await dbClient.delete(table['table_plural_name'], where: 'id = ?', whereArgs: [id]);
  }

  Future<int> _update(Product Product, Map<String, dynamic> table) async {
    var dbClient = await dbHelper.dbPlus();
    return await dbClient.update(table['table_plural_name'], Product.toMap(), where: 'id = ?', whereArgs: [Product.id]);
  }

  // Private methods:
  void _generateDummyData() async {
    final List<Product> products = await _index(sqliteTable);
    final int currentLength = products.length;
    if (currentLength < _maxAmountDummyData) {
      // FoodRecipesData foodRecipesData = FoodRecipesData();
      // FoodCategoriesFoodRecipesData foodCategoriesFoodRecipesData = FoodCategoriesFoodRecipesData();
      for (int i = 0; i < (_maxAmountDummyData - currentLength); i++) {
        String title = faker.food.cuisine();
        Color color = ColorHelper.randomMaterialColor();
        Product product = await addProduct(title, color);

        // Creates a few dummy FoodRecipe objects by its id (as well as FoodRecipeProduct, FoodIngredient & RecipeStep objects):
        // foodRecipesData.generateDummyDataByProductId(product.id, 5);
      }
    }
  }

  void _removeWhere(int id) async {
    await _destroy(id, sqliteTable);
    await refresh();
  }

  // Public methods:
  Future refresh() async {
    _products = await _index(sqliteTable);
    notifyListeners();
  }

  Future<Product> addProduct(String title, Color color) async {
    DateTime now = DateTime.now();
    Product newProduct = Product(
      title: title,
      color: color,
      createdAt: now,
      updatedAt: now,
    );
    Product product = await _create(newProduct, sqliteTable);
    refresh();
    return product;
  }

  Future<void> updateProduct(int id, String title, Color color) async {
    DateTime now = DateTime.now();
    Product updatingProduct = _products.firstWhere((Product) => id == Product.id);

    updatingProduct.title = title;
    updatingProduct.color = color;
    updatingProduct.updatedAt = now;

    await _update(updatingProduct, sqliteTable);
    refresh();
  }

  Future<void> deleteProductWithConfirm(int id, BuildContext context) {
    DialogHelper.showDialogPlus(id, context, () => _removeWhere(id)).then((value) {
      (context as Element).reassemble();
      refresh();
    });
  }

  void deleteProductWithoutConfirm(int id) {
    _removeWhere(id);
    // refresh();
  }
}
