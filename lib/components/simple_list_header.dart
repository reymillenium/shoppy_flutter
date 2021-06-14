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

class SimpleListHeader extends StatelessWidget {
  //Properties:
  final String listHeader;
  const SimpleListHeader({
    Key key,
    this.listHeader,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8, right: 8, top: 8),
      decoration: BoxDecoration(
        color: TinyColor(partialListsRefillColor).darken(6).color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 2.0,
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border(
            bottom: BorderSide(
              width: 1.0,
              color: Colors.black45,
            ),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Center(
          child: Text(
            listHeader,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ),
    );
  }
}
