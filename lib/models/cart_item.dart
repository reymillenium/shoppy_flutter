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

class CartItem with ChangeNotifier {
  // Properties:
  dynamic id;
  dynamic userId;
  dynamic productId;
  int quantity;
  DateTime createdAt;
  DateTime updatedAt;

  // Constructors:
  CartItem({
    this.id,
    @required this.userId,
    @required this.productId,
    @required this.quantity,
    @required this.createdAt,
    @required this.updatedAt,
  });

  CartItem.fromMap(Map<String, dynamic> productMap) {
    id = productMap['id'];
    userId = productMap['user_id'];
    productId = productMap['product_id'];
    quantity = productMap['quantity'];

    createdAt = DateTime.parse(productMap['created_at']);
    updatedAt = DateTime.parse(productMap['updated_at']);
  }

  Map<String, dynamic> toMap() {
    var cartItemMap = <String, dynamic>{
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'quantity': quantity,
      'created_at': createdAt.toString(),
      'updated_at': updatedAt.toString(),
    };
    return cartItemMap;
  }
}
