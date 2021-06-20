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
    'table_singular_name': 'product',
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
        String description = faker.lorem.sentence();
        double price = NumericHelper.roundRandomDoubleInRange(min: 0.99, max: 9.99, places: 2);
        // Color color = ColorHelper.randomMaterialColor();
        await addProduct(title: title, description: description, price: price, imageUrl: ListHelper.randomFromList(DUMMY_FOOD_IMAGE_URLS));

        // Creates a few dummy FoodRecipe objects by its id (as well as FoodRecipeProduct, FoodIngredient & RecipeStep objects):
        // foodRecipesData.generateDummyDataByProductId(product.id, 5);
        // @required this.createdAt,
        // @required this.updatedAt,
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

  Future<void> updateProduct(int id, String title, String description, double price, String imageUrl) async {
    DateTime now = DateTime.now();
    Product updatingProduct = _products.firstWhere((product) => id == product.id);

    updatingProduct.title = title;
    updatingProduct.description = description;
    updatingProduct.price = price;
    updatingProduct.imageUrl = imageUrl;
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

  Future<List<Product>> thoseFavoritesByUserId(int userId, {List<String> filtersList}) async {
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

  Future<void> setAsFavorite(int userId, int productId) async {
    FavoriteProductsData favoriteProductsData = FavoriteProductsData();
    await favoriteProductsData.addFavoriteProduct(userId: userId, productId: productId);
    // await refresh();
  }

  Future<void> setAsNotFavorite(int userId, int productId) async {
    FavoriteProductsData favoriteProductsData = FavoriteProductsData();
    await favoriteProductsData.deleteFavoriteProductWithoutConfirm(userId, productId);
    // await refresh();
  }

  Future<void> toggleFavorite(int userId, int productId) async {
    bool isFavorite = await this.isFavorite(userId, productId);
    await (isFavorite ? this.setAsNotFavorite(userId, productId) : this.setAsFavorite(userId, productId));
    await refresh();
  }

  Future<bool> isFavorite(int userId, int productId) async {
    FavoriteProductsData favoriteProductsData = FavoriteProductsData();
    List<FavoriteProduct> favoriteProducts = await favoriteProductsData.byUserId(userId);
    return favoriteProducts.any((favoriteProduct) => favoriteProduct.productId == productId);
  }
}