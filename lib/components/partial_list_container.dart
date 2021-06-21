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
import '../utilities/_utilities.dart';

class PartialListContainer extends StatelessWidget {
  // Properties:
  final Widget innerWidgetList;
  const PartialListContainer({
    Key key,
    this.innerWidgetList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8, right: 8, bottom: 8),
      decoration: BoxDecoration(
        color: partialListsRefillColor,
        border: Border.all(
          color: partialListsRefillColor,
          width: 8,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 2.0,
          ),
        ],
      ),
      // height: 300,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: innerWidgetList,
      ),
    );
  }
}
