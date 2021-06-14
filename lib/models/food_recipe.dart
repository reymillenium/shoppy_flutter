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

enum Complexity {
  verySimple,
  simple,
  medium,
  challenging,
  hard,
  veryHard,
}
enum Affordability {
  veryCheap,
  cheap,
  affordable,
  pricey,
  expensive,
  luxurious,
}

class FoodRecipe {
  // Properties:
  int id;
  String title;
  List<Product> products; // Has many relationship
  String imageUrl;
  List<FoodIngredient> foodIngredients; // Has many relationship
  List<RecipeStep> recipeSteps; // Has many relationship
  int duration;
  Complexity complexity;
  Affordability affordability;
  bool isGlutenFree;
  bool isLactoseFree;
  bool isVegan;
  bool isVegetarian;
  DateTime createdAt;
  DateTime updatedAt;

  // Constructors:
  FoodRecipe({
    this.id,
    @required this.title,
    this.products,
    @required this.imageUrl,
    this.foodIngredients,
    this.recipeSteps,
    @required this.duration,
    @required this.complexity,
    @required this.affordability,
    @required this.isGlutenFree,
    @required this.isLactoseFree,
    @required this.isVegan,
    @required this.isVegetarian,
    @required this.createdAt,
    @required this.updatedAt,
  });

  bool get hasDietQuirks {
    return (isGlutenFree || isLactoseFree || isVegan || isVegetarian);
  }

  FoodRecipe.fromMap(Map<String, dynamic> foodRecipeMap) {
    id = foodRecipeMap['id'];
    title = foodRecipeMap['title'];
    // products = foodRecipeMap['products']; // TODO: Implement the loading of the products
    imageUrl = foodRecipeMap['imageUrl'];
    // foodIngredients = foodRecipeMap['foodIngredients']; // TODO: Implement the loading of the foodIngredients from the DB into a FoodRecipe object
    // recipeSteps = foodRecipeMap['recipeSteps']; // TODO: Implement the loading of the recipeSteps from the DB into a FoodRecipe object
    duration = foodRecipeMap['duration'];
    complexity = EnumToString.fromString(Complexity.values, foodRecipeMap['complexity']);
    affordability = EnumToString.fromString(Affordability.values, foodRecipeMap['affordability']);
    isGlutenFree = foodRecipeMap['isGlutenFree'] == 1 ? true : false;
    isLactoseFree = foodRecipeMap['isLactoseFree'] == 1 ? true : false;
    isVegan = foodRecipeMap['isVegan'] == 1 ? true : false;
    isVegetarian = foodRecipeMap['isVegetarian'] == 1 ? true : false;

    createdAt = DateTime.parse(foodRecipeMap['createdAt']);
    updatedAt = DateTime.parse(foodRecipeMap['updatedAt']);
  }

  Map<String, dynamic> toMap() {
    var foodRecipeMap = <String, dynamic>{
      'id': id,
      'title': title,
      // 'products': products,
      'imageUrl': imageUrl,
      // 'ingredients': foodIngredients,
      // 'recipeSteps': recipeSteps,
      'duration': duration,
      'complexity': EnumToString.convertToString(complexity),
      'affordability': EnumToString.convertToString(affordability),
      'isGlutenFree': isGlutenFree ? 1 : 0,
      'isLactoseFree': isLactoseFree ? 1 : 0,
      'isVegan': isVegan ? 1 : 0,
      'isVegetarian': isVegetarian ? 1 : 0,
      'createdAt': createdAt.toString(),
      'updatedAt': updatedAt.toString(),
    };
    return foodRecipeMap;
  }

  dynamic getProp(String key) => <String, dynamic>{
        'isGlutenFree': isGlutenFree,
        'isLactoseFree': isLactoseFree,
        'isVegan': isVegan,
        'isVegetarian': isVegetarian,
      }[key];
}
