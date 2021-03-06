// Packages:
import '../_inner_packages.dart';
import '../_external_packages.dart';

// Screens:

// Models:

// Components:

// Helpers:

// Utilities:

class CustomDrawerSwitch extends StatelessWidget {
  const CustomDrawerSwitch({
    Key key,
    @required this.switchLabel,
    @required this.activeColor,
    @required this.switchValue,
    this.possibleValues = const {
      'activeText': 'On',
      'inactiveText': 'Off',
    },
    @required this.onToggle,
  }) : super(key: key);

  final String switchLabel;
  final Color activeColor;
  final bool switchValue;
  final Map<String, dynamic> possibleValues;
  final Function onToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16),
      child: SizedBox(
        // width: 30,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              switchLabel,
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(
              width: 20,
            ),
            FlutterSwitch(
              showOnOff: true,
              activeText: possibleValues['activeText'],
              inactiveText: possibleValues['inactiveText'],
              activeColor: activeColor,
              activeTextColor: Colors.black,
              inactiveTextColor: Colors.blue[50],
              width: 55.0,
              height: 25.0,
              valueFontSize: 12.0,
              toggleSize: 18.0,
              value: switchValue,
              onToggle: onToggle,
            ),
          ],
        ),
      ),
    );
  }
}
