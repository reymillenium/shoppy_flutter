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

class Product {
  // Properties:
  int id;
  String title;
  Color color;
  List<FoodRecipe> foodRecipes;
  DateTime createdAt;
  DateTime updatedAt;

  // Constructors:
  Product({
    this.id,
    @required this.title,
    this.color = Colors.orangeAccent,
    this.foodRecipes,
    @required this.createdAt,
    @required this.updatedAt,
  });

  Product.fromMap(Map<String, dynamic> productMap) {
    id = productMap['id'];
    title = productMap['title'];
    color = ColorHelper.fromHex(productMap['color']);
    createdAt = DateTime.parse(productMap['created_at']);
    updatedAt = DateTime.parse(productMap['updated_at']);
  }

  Map<String, dynamic> toMap() {
    var productMap = <String, dynamic>{
      'id': id,
      'title': title,
      'color': color.toHex(leadingHashSign: true),
      'created_at': createdAt.toString(),
      'updated_at': updatedAt.toString(),
    };
    return productMap;
  }

// Map<String, dynamic> toMap() => {
//       'id': id,
//       'title': title,
//       'color': color.toHex(leadingHashSign: true),
//       'createdAt': createdAt.toString(),
//       'updatedAt': updatedAt.toString(),
//     };
}
