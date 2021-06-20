// Packages:
import '../_inner_packages.dart';
import '../_external_packages.dart';

// Screens:

// Models:
import '../models/_models.dart';

// Components:
import './_components.dart';

// Helpers:
import '../helpers/_helpers.dart';

// Utilities:
import '../utilities/constants.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  // Properties:
  final String appTitle;
  final Function onPressedAdd;
  final String objectName;
  final IconData actionIcon;

  const CustomAppBar({
    Key key,
    this.appTitle,
    this.onPressedAdd,
    this.objectName,
    this.actionIcon = Icons.add,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context, listen: true);
    Map currentThemeFont = appData.currentThemeFont;

    return AppBar(
      title: Text(
        appTitle,
        // style: TextStyle(
        //   fontSize: 24,
        //   fontWeight: FontWeight.bold,
        //   fontFamily: currentThemeFont['fontFamily'],
        // ),
        style: Theme.of(context).appBarTheme.textTheme.headline6.copyWith(
              fontFamily: currentThemeFont['fontFamily'],
            ),
      ),
      actions: [
        IconButton(
          iconSize: 32,
          icon: Icon(actionIcon),
          tooltip: 'Add ${objectName.inCaps}',
          onPressed: onPressedAdd,
        ),
      ],
      // bottom: PreferredSize(
      //   preferredSize: Size.fromHeight(100.0),
      // ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolBarHeight);
}