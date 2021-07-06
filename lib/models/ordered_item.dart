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

class OrderedItem with ChangeNotifier {
  // Properties:
  int id;
  int orderId;

  String title;
  String description;
  double price;
  int quantity;
  String imageUrl;

  DateTime createdAt;
  DateTime updatedAt;

  // Constructors:
  OrderedItem({
    this.id,
    @required this.orderId,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.quantity,
    @required this.imageUrl,
    @required this.createdAt,
    @required this.updatedAt,
  });

  OrderedItem.fromMap(Map<String, dynamic> orderedItemMap) {
    id = orderedItemMap['id'];
    orderId = orderedItemMap['order_id'];

    title = orderedItemMap['title'];
    description = orderedItemMap['description'];
    price = orderedItemMap['price'];
    quantity = orderedItemMap['quantity'];
    imageUrl = orderedItemMap['image_url'];

    createdAt = DateTime.parse(orderedItemMap['created_at']);
    updatedAt = DateTime.parse(orderedItemMap['updated_at']);
  }

  Map<String, dynamic> toMap() {
    var orderedItemMap = <String, dynamic>{
      'id': id,
      'order_id': orderId,
      'title': title,
      'description': description,
      'price': price,
      'quantity': quantity,
      'image_url': imageUrl,
      'created_at': createdAt.toString(),
      'updated_at': updatedAt.toString(),
    };
    return orderedItemMap;
  }
}
