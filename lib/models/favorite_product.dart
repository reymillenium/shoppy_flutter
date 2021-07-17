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

class FavoriteProduct {
  // Properties:
  dynamic id;
  int userId;
  int productId;
  DateTime updatedAt;
  DateTime createdAt;

  // Constructors:
  FavoriteProduct({
    this.id,
    @required this.userId,
    @required this.productId,
    @required this.createdAt,
    @required this.updatedAt,
  });

  FavoriteProduct.fromMap(Map<String, dynamic> favoriteProductMap) {
    id = favoriteProductMap['id'];
    userId = favoriteProductMap['user_id'];
    productId = favoriteProductMap['product_id'];

    createdAt = DateTime.parse(favoriteProductMap['created_at']);
    updatedAt = DateTime.parse(favoriteProductMap['updated_at']);
  }

  Map<String, dynamic> toMap() {
    var favoriteProductMap = <String, dynamic>{
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'created_at': createdAt.toString(),
      'updated_at': updatedAt.toString(),
    };
    return favoriteProductMap;
  }

  dynamic getProp(String key) => <String, dynamic>{
        'id': id,
        'userId': userId,
        'productId': productId,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      }[key];
}
