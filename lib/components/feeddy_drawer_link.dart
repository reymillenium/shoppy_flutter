// Packages:
import '../_inner_packages.dart';
import '../_external_packages.dart';

// Screens:
import '../screens/_screens.dart';

// Models:
import '../models/_models.dart';

// Components:
import './_components.dart';

// Helpers:
import '../helpers/_helpers.dart';
// Utilities:

class FeeddyDrawerLink extends StatelessWidget {
  // Properties:
  final IconData icon;
  final String title;
  final String screenId;

  const FeeddyDrawerLink({
    Key key,
    this.icon,
    this.title,
    this.screenId,
  }) : super(key: key);

  void onTapLink(String screenId, BuildContext context) async {
    // Working:
    // Navigator.of(context).pushNamed(screenId);

    // Initially Not working:
    // When trying to solve the error:
    //Flutter setState() or markNeedsBuild() called when widget tree was locked
    Navigator.of(context).pushReplacementNamed(screenId);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTapLink(screenId, context),
      leading: Icon(
        icon,
        color: Colors.black,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
