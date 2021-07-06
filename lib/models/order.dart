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

class Order with ChangeNotifier {
  // Properties:
  int id;
  int userId;

  double taxesAmount;

  DateTime createdAt;
  DateTime updatedAt;

  // Constructors:
  Order({
    this.id,
    @required this.userId,
    @required this.taxesAmount,
    @required this.createdAt,
    @required this.updatedAt,
  });

  Order.fromMap(Map<String, dynamic> orderMap) {
    id = orderMap['id'];
    userId = orderMap['user_id'];

    taxesAmount = orderMap['taxes_amount'];

    createdAt = DateTime.parse(orderMap['created_at']);
    updatedAt = DateTime.parse(orderMap['updated_at']);
  }

  Map<String, dynamic> toMap() {
    var orderMap = <String, dynamic>{
      'id': id,
      'user_id': userId,
      'taxes_amount': taxesAmount,
      'created_at': createdAt.toString(),
      'updated_at': updatedAt.toString(),
    };
    return orderMap;
  }
}
