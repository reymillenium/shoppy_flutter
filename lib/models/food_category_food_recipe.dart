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

class ProductFoodRecipe {
  // Properties:
  int id;
  int productId;
  int foodRecipeId;
  DateTime createdAt;
  DateTime updatedAt;

  // Constructors:
  ProductFoodRecipe({
    this.id,
    @required this.productId,
    @required this.foodRecipeId,
    @required this.createdAt,
    @required this.updatedAt,
  });

  ProductFoodRecipe.fromMap(Map<String, dynamic> recipeStepMap) {
    id = recipeStepMap['id'];
    // productId = recipeStepMap['productId'];
    productId = recipeStepMap['food_product_id'];
    // foodRecipeId = recipeStepMap['foodRecipeId'];
    foodRecipeId = recipeStepMap['food_recipe_id'];

    createdAt = DateTime.parse(recipeStepMap['createdAt']);
    updatedAt = DateTime.parse(recipeStepMap['updatedAt']);
  }

  Map<String, dynamic> toMap() {
    var recipeStepMap = <String, dynamic>{
      'id': id,
      // 'productId': productId,
      'food_product_id': productId,
      // 'foodRecipeId': foodRecipeId,
      'food_recipe_id': foodRecipeId,
      'createdAt': createdAt.toString(),
      'updatedAt': updatedAt.toString(),
    };
    return recipeStepMap;
  }
}
