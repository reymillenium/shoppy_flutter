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

class FoodRecipesData with ChangeNotifier {
  // Properties:
  static const sqliteTable = {
    'table_plural_name': 'food_recipes',
    'table_singular_name': 'food_recipe',
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
        'field_name': 'imageUrl',
        'field_type': 'TEXT',
      },
      {
        'field_name': 'duration',
        'field_type': 'INTEGER',
      },
      {
        'field_name': 'complexity',
        'field_type': 'TEXT',
      },
      {
        'field_name': 'affordability',
        'field_type': 'TEXT',
      },
      {
        'field_name': 'isGlutenFree',
        'field_type': 'INTEGER',
      },
      {
        'field_name': 'isLactoseFree',
        'field_type': 'INTEGER',
      },
      {
        'field_name': 'isVegan',
        'field_type': 'INTEGER',
      },
      {
        'field_name': 'isVegetarian',
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
  List<FoodRecipe> _foodRecipes = [];
  DBHelper dbHelper;

  // Constructor:
  FoodRecipesData() {
    dbHelper = DBHelper();
    refresh();
    // _generateDummyData();
  }

  // Getters:
  // static get sqliteTable {
  //   return _sqliteTable;
  // }

  get foodRecipes {
    return _foodRecipes;
  }

  // SQLite DB CRUD:
  Future<FoodRecipe> _create(FoodRecipe foodRecipe, Map<String, dynamic> table) async {
    var dbClient = await dbHelper.dbPlus();
    foodRecipe.id = await dbClient.insert(table['table_plural_name'], foodRecipe.toMap());
    return foodRecipe;
  }

  Future<List<dynamic>> _index(Map<String, dynamic> table) async {
    var dbClient = await dbHelper.dbPlus();
    List<Map> tableFields = table['fields'];
    List<Map> foodRecipesMaps = await dbClient.query(table['table_plural_name'], columns: tableFields.map<String>((field) => field['field_name']).toList());

    List<FoodRecipe> foodRecipesList = [];
    if (foodRecipesMaps.length > 0) {
      for (int i = 0; i < foodRecipesMaps.length; i++) {
        FoodRecipe foodRecipe;
        foodRecipe = FoodRecipe.fromMap(foodRecipesMaps[i]);
        // List<Map> productsMaps = await dbClient.query(table['table_plural_name'], columns: tableFields.map<String>((field) => field['field_name']).toList());

        // Declaration of temporal empty lists:
        List<ProductFoodRecipe> productsFoodRecipesList = [];
        List<Product> productsList = [];

        // try {
        //   // Gathering on the join table (products_food_recipes) by the productId:
        //   List<Map> productsFoodRecipesTableFields = ProductsFoodRecipesData.sqliteTable['fields'];
        //
        //   List<Map> productsFoodRecipesMaps = await dbClient.query(ProductsFoodRecipesData.sqliteTable['table_plural_name'], columns: productsFoodRecipesTableFields.map<String>((field) => field['field_name']).toList(), where: 'foodRecipeId = ?', whereArgs: [foodRecipe.id]);
        //   if (productsFoodRecipesMaps.length > 0) {
        //     // If the FoodRecipe object belongs to at least one associated Product...
        //     for (int j = 0; j < productsFoodRecipesMaps.length; j++) {
        //       ProductFoodRecipe productFoodRecipe;
        //       productFoodRecipe = ProductFoodRecipe.fromMap(productsFoodRecipesMaps[j]);
        //       // Adding the ProductFoodRecipe object to the temporal list:
        //       productsFoodRecipesList.add(productFoodRecipe);
        //     }
        //
        //     List<int> productsIdsList = productsFoodRecipesList.map((productFoodRecipe) => productFoodRecipe.productId).toList();
        //     // Gathering of its Product objects based on the possibly gathered ProductFoodRecipe objects:
        //     List<Map> productsTableFields = ProductsData.sqliteTable['fields'];
        //     List<Map> productsMaps = await dbClient.query(ProductsData.sqliteTable['table_plural_name'], columns: productsTableFields.map<String>((field) => field['field_name']).toList(), where: 'id = ?', whereArgs: productsIdsList);
        //
        //     for (int k = 0; k < foodRecipesMaps.length; k++) {
        //       Product product;
        //       product = Product.fromMap(productsMaps[k]);
        //       // Adding the ProductFoodRecipe object to the temporal list:
        //       productsList.add(product);
        //     }
        //   }
        // } catch (error) {
        //   // No rows on the join table or there is any other error there.
        // }

        foodRecipe.products = productsList;
        // Adding the FoodRecipe object with everything inside to the list:
        foodRecipesList.add(foodRecipe);
      }
    }
    return foodRecipesList;
  }

  Future<List<FoodRecipe>> byProduct(Product product, {List<String> filtersList}) async {
    var dbClient = await dbHelper.dbPlus();
    List<FoodRecipe> foodRecipesList = [];
    filtersList = filtersList ?? [];

    // Gathering on the join table (products_food_recipes) by the food_product_id:
    Map<String, Object> productsFoodRecipesTable = ProductsFoodRecipesData.sqliteTable;
    String productsFoodRecipesTableName = productsFoodRecipesTable['table_plural_name'];
    List<Map> productsFoodRecipesTableFields = productsFoodRecipesTable['fields'];
    List<Map> productsFoodRecipesMaps = await dbClient.query(productsFoodRecipesTableName, columns: productsFoodRecipesTableFields.map<String>((field) => field['field_name']).toList(), where: 'food_product_id = ?', whereArgs: [product.id]);

    if (productsFoodRecipesMaps.length > 0) {
      // If some association was found (If the given Product has at least one FoodRecipe)
      // Conversion into ProductFoodRecipe objects:
      List<ProductFoodRecipe> productsFoodRecipesList = [];
      for (int j = 0; j < productsFoodRecipesMaps.length; j++) {
        ProductFoodRecipe productFoodRecipe;
        productFoodRecipe = ProductFoodRecipe.fromMap(productsFoodRecipesMaps[j]);
        // Adding the ProductFoodRecipe object to the temporal list:
        productsFoodRecipesList.add(productFoodRecipe);
      }

      // Gathering of the FoodRecipe Maps based on the gathered ProductFoodRecipe objects:
      List<int> foodRecipesIdsList = productsFoodRecipesList.map((productFoodRecipe) => productFoodRecipe.foodRecipeId).toList();
      Map<String, Object> foodRecipesTable = FoodRecipesData.sqliteTable;
      String foodRecipesTableName = foodRecipesTable['table_plural_name'];
      List<Map> foodRecipesTableFields = foodRecipesTable['fields'];
      // Original query by the foodRecipesIdsList only:
      // List<Map> foodRecipesMaps = await dbClient.query(foodRecipesTableName, columns: foodRecipesTableFields.map<String>((field) => field['field_name']).toList(), where: 'id IN (${foodRecipesIdsList.map((e) => "'$e'").join(', ')})');
      // Improved query by the foodRecipesIdsList and adding filtering:
      String filteringString = (filtersList.isEmpty) ? '' : "(${filtersList.map((e) => "$e = 1").join(' OR ')}) AND ";
      // print('filteringString: $filteringString');
      List<Map> foodRecipesMaps = await dbClient.query(foodRecipesTableName, columns: foodRecipesTableFields.map<String>((field) => field['field_name']).toList(), where: '${filteringString}id IN (${foodRecipesIdsList.map((e) => "'$e'").join(', ')})');

      // Conversion into FoodRecipe objects:
      if (foodRecipesMaps.length > 0) {
        for (int i = 0; i < foodRecipesMaps.length; i++) {
          FoodRecipe foodRecipe = FoodRecipe.fromMap(foodRecipesMaps[i]);
          foodRecipesList.add(foodRecipe);
        }
      }

      // Permissive filtering (Not necessary anymore. Now it is performed on the sqlite query):
      // foodRecipesList = filterFoodRecipesByDietPermissive(foodRecipesList, filtersList); // First version
      // foodRecipesList = filterFoodRecipesByDietPlusPermissive(foodRecipesList, filtersList); // Improved version
      // foodRecipesList = filterFoodRecipesByDietPlusUltraPermissive(foodRecipesList, filtersList); // An even more improved version
    }
    return foodRecipesList;
  }

  Future<List<FoodRecipe>> thoseFavoritesByUserId(int userId, {List<String> filtersList}) async {
    var dbClient = await dbHelper.dbPlus();
    List<FoodRecipe> foodRecipesList = [];
    filtersList = filtersList ?? [];
    FavoriteFoodRecipesData favoriteFoodRecipesData = FavoriteFoodRecipesData();
    // Gathering of the foodRecipesIdsList on the FavoriteFoodRecipes table (favorite_food_recipes) by the user_id:
    List<FavoriteFoodRecipe> favoriteFoodRecipesList = await favoriteFoodRecipesData.byUserId(userId);

    if (favoriteFoodRecipesList.isNotEmpty) {
      List<int> foodRecipesIdsList = favoriteFoodRecipesList.map((favoriteFoodRecipe) => favoriteFoodRecipe.foodRecipeId).toList();

      Map<String, Object> foodRecipesTable = FoodRecipesData.sqliteTable;
      String foodRecipesTableName = foodRecipesTable['table_plural_name'];
      List<Map> foodRecipesTableFields = foodRecipesTable['fields'];
      String filteringString = (filtersList.isEmpty) ? '' : "(${filtersList.map((e) => "$e = 1").join(' OR ')}) AND ";
      List<Map> foodRecipesMaps = await dbClient.query(foodRecipesTableName, columns: foodRecipesTableFields.map<String>((field) => field['field_name']).toList(), where: '${filteringString}id IN (${foodRecipesIdsList.map((e) => "'$e'").join(', ')})');

      // Conversion into FoodRecipe objects:
      if (foodRecipesMaps.length > 0) {
        for (int i = 0; i < foodRecipesMaps.length; i++) {
          FoodRecipe foodRecipe = FoodRecipe.fromMap(foodRecipesMaps[i]);
          foodRecipesList.add(foodRecipe);
        }
      }
    }

    return foodRecipesList;
  }

  Future<void> setAsFavorite(int userId, int foodRecipeId) async {
    FavoriteFoodRecipesData favoriteFoodRecipesData = FavoriteFoodRecipesData();
    await favoriteFoodRecipesData.addFavoriteFoodRecipe(userId: userId, foodRecipeId: foodRecipeId);
    // await refresh();
  }

  Future<void> setAsNotFavorite(int userId, int foodRecipeId) async {
    FavoriteFoodRecipesData favoriteFoodRecipesData = FavoriteFoodRecipesData();
    await favoriteFoodRecipesData.deleteFavoriteFoodRecipeWithoutConfirm(userId, foodRecipeId);
    // await refresh();
  }

  Future<void> toggleFavorite(int userId, int foodRecipeId) async {
    bool isFavorite = await this.isFavorite(userId, foodRecipeId);
    await (isFavorite ? this.setAsNotFavorite(userId, foodRecipeId) : this.setAsFavorite(userId, foodRecipeId));
    await refresh();
  }

  Future<bool> isFavorite(int userId, int foodRecipeId) async {
    FavoriteFoodRecipesData favoriteFoodRecipesData = FavoriteFoodRecipesData();
    List<FavoriteFoodRecipe> favoriteFoodRecipes = await favoriteFoodRecipesData.byUserId(userId);
    return favoriteFoodRecipes.any((favoriteFoodRecipe) => favoriteFoodRecipe.foodRecipeId == foodRecipeId);
  }

  List<FoodRecipe> filterFoodRecipesByDietPermissive(List<FoodRecipe> foodRecipesList, List<String> filtersList) {
    if (filtersList.isNotEmpty) {
      List<FoodRecipe> foodRecipesIsGlutenFree = [];
      List<FoodRecipe> foodRecipesIsVegan = [];
      List<FoodRecipe> foodRecipesIsVegetarian = [];
      List<FoodRecipe> foodRecipesIsLactoseFree = [];
      filtersList.forEach((filter) {
        switch (filter) {
          case 'isGlutenFree':
            foodRecipesIsGlutenFree = foodRecipesList.where((foodRecipe) => foodRecipe.isGlutenFree == true).toList();
            break;
          case 'isVegan':
            foodRecipesIsVegan = foodRecipesList.where((foodRecipe) => foodRecipe.isVegan == true).toList();
            break;
          case 'isVegetarian':
            foodRecipesIsVegetarian = foodRecipesList.where((foodRecipe) => foodRecipe.isVegetarian == true).toList();
            break;
          case 'isLactoseFree':
            foodRecipesIsLactoseFree = foodRecipesList.where((foodRecipe) => foodRecipe.isLactoseFree == true).toList();
            break;
        }
      });

      // Joining all the diet specific lists (removes the duplicates):
      foodRecipesList = [
        ...foodRecipesIsGlutenFree,
        ...foodRecipesIsVegan,
        ...foodRecipesIsVegetarian,
        ...foodRecipesIsLactoseFree,
      ].toSet().toList();
    }
    return foodRecipesList;
  }

  // Permissive filtering (same behavior, shorter extension)
  List<FoodRecipe> filterFoodRecipesByDietPlusPermissive(List<FoodRecipe> foodRecipesList, List<String> filtersList) {
    if (filtersList.isNotEmpty) {
      foodRecipesList.removeWhere((foodRecipe) {
        return ((filtersList.contains('isGlutenFree') && !foodRecipe.isGlutenFree) || (filtersList.contains('isVegan') && !foodRecipe.isVegan) || (filtersList.contains('isVegetarian') && !foodRecipe.isVegetarian) || (filtersList.contains('isLactoseFree') && !foodRecipe.isLactoseFree));
      });
    }
    return foodRecipesList;
  }

  // Permissive filtering (same behavior, even shorter)
  List<FoodRecipe> filterFoodRecipesByDietPlusUltraPermissive(List<FoodRecipe> foodRecipesList, List<String> filtersList) {
    if (filtersList.isNotEmpty) {
      foodRecipesList = foodRecipesList.where((foodRecipe) {
        return (filtersList.any((filter) => foodRecipe.getProp(filter)));
      }).toList();
    }
    return foodRecipesList;
  }

  // Strict filtering (different behavior. Another alternative for another chance)
  List<FoodRecipe> filterFoodRecipesByDietPlusUltraRestrictive(List<FoodRecipe> foodRecipesList, List<String> filtersList) {
    if (filtersList.isNotEmpty) {
      foodRecipesList.removeWhere((foodRecipe) {
        return (filtersList.any((filter) => !foodRecipe.getProp(filter)));
      });
    }
    return foodRecipesList;
  }

  Future<int> _destroy(int id, Map<String, dynamic> table) async {
    var dbClient = await dbHelper.dbPlus();
    return await dbClient.delete(table['table_plural_name'], where: 'id = ?', whereArgs: [id]);
  }

  Future<int> _update(FoodRecipe product, Map<String, dynamic> table) async {
    var dbClient = await dbHelper.dbPlus();
    return await dbClient.update(table['table_plural_name'], product.toMap(), where: 'id = ?', whereArgs: [product.id]);
  }

  // Private methods:
  void _generateDummyData() async {
    // final List<Product> products = await _index(sqliteTable);
    // final int currentLength = products.length;
    // if (currentLength < _maxAmountDummyData) {
    //   for (int i = 0; i < (_maxAmountDummyData - currentLength); i++) {
    //     String title = faker.food.dish();
    //     // Color color = ColorHelper.randomColor();
    //     Color color = ColorHelper.randomMaterialColor();
    //     await addFoodRecipe(title, color);
    //   }
    // }
  }

  void generateDummyDataByProductId(int productId, int amount) async {
    ProductsFoodRecipesData productsFoodRecipesData = ProductsFoodRecipesData();
    FoodIngredientsData foodIngredientsData = FoodIngredientsData();
    RecipeStepsData recipeStepsData = RecipeStepsData();

    for (int j = 0; j < amount; j++) {
      try {
        FoodRecipe foodRecipe = await addFoodRecipe(
          title: faker.food.dish(),
          imageUrl: ListHelper.randomFromList(DUMMY_FOOD_IMAGE_URLS),
          duration: NumericHelper.randomIntegerInRange(min: 20, max: 45),
          complexity: Complexity.simple,
          affordability: Affordability.affordable,
          isGlutenFree: false,
          isLactoseFree: false,
          isVegan: false,
          isVegetarian: false,
        );
        // ProductsFoodRecipe objects to keep consistency (relations between tables) on the DB containing the dummy data:
        await productsFoodRecipesData.addProductFoodRecipe(productId, foodRecipe.id);
        // FoodIngredient objects as dummy data:
        await foodIngredientsData.generateDummyDataByFoodRecipeId(foodRecipe.id, 12);
        // RecipeStep objects as dummy data:
        await recipeStepsData.generateDummyDataByFoodRecipeId(foodRecipe.id, 12);
      } catch (error) {
        print(error);
      }
    }
  }

  void _removeWhere(int id) async {
    await _destroy(id, sqliteTable);
    // TODO: Add destruction of all the ProductFoodRecipe objects with matching food_recipe_id
    await refresh();
  }

  // Public methods:
  Future refresh() async {
    try {
      _foodRecipes = await _index(sqliteTable);
    } catch (error) {}
    notifyListeners();
  }

  Future<FoodRecipe> addFoodRecipe({
    String title,
    List<Product> products,
    String imageUrl,
    List<FoodIngredient> foodIngredients,
    List<RecipeStep> recipeSteps,
    int duration,
    Complexity complexity,
    Affordability affordability,
    bool isGlutenFree,
    bool isLactoseFree,
    bool isVegan,
    bool isVegetarian,
  }) async {
    DateTime now = DateTime.now();

    // TODO: Check that this is fine
    FoodRecipe newRecipe = FoodRecipe(
      title: title,
      imageUrl: imageUrl,
      duration: duration,
      complexity: complexity,
      affordability: affordability,
      isGlutenFree: isGlutenFree,
      isLactoseFree: isLactoseFree,
      isVegan: isVegan,
      isVegetarian: isVegetarian,
      createdAt: now,
      updatedAt: now,
    );
    FoodRecipe foodRecipe = await _create(newRecipe, sqliteTable);
    refresh();
    return foodRecipe;
  }

  Future<void> updateFoodRecipe(
    int id,
    String title,
    // List<Product> products,
    String imageUrl,
    // List<FoodIngredient> foodIngredients,
    // List<RecipeStep> recipeSteps,
    int duration,
    Complexity complexity,
    Affordability affordability,
    bool isGlutenFree,
    bool isLactoseFree,
    bool isVegan,
    bool isVegetarian,
  ) async {
    DateTime now = DateTime.now();
    FoodRecipe updatingFoodRecipe = _foodRecipes.firstWhere((foodRecipe) => id == foodRecipe.id);

    updatingFoodRecipe.title = title;
    updatingFoodRecipe.imageUrl = imageUrl;
    updatingFoodRecipe.duration = duration;
    updatingFoodRecipe.complexity = complexity;
    updatingFoodRecipe.affordability = affordability;
    updatingFoodRecipe.isGlutenFree = isGlutenFree;
    updatingFoodRecipe.isLactoseFree = isLactoseFree;
    updatingFoodRecipe.isVegan = isVegan;
    updatingFoodRecipe.isVegetarian = isVegetarian;
    updatingFoodRecipe.updatedAt = now;

    await _update(updatingFoodRecipe, sqliteTable);
    refresh();
  }

  Future<void> deleteFoodRecipeWithConfirm(int id, BuildContext context) {
    DialogHelper.showDialogPlus(id, context, () => _removeWhere(id)).then((value) {
      // This commenting, fixes an exception when deleting
      // (context as Element).reassemble();
      refresh();
    });
  }

  void deleteFoodRecipeWithoutConfirm(int id) {
    _removeWhere(id);
    // refresh();
  }
}
