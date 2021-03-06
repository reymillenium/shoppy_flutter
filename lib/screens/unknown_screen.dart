// Packages:
import '../_inner_packages.dart';
import '../_external_packages.dart';

// Screens:
import './_screens.dart';

// Models:
import '../models/_models.dart';

// Components:
import '../components/_components.dart';

// Helpers:
import '../helpers/_helpers.dart';
// Utilities:

class UnknownScreen extends StatefulWidget {
  static const String screenId = 'unknown_screen';

  // Properties:
  final String appTitle;

  const UnknownScreen({
    Key key,
    this.appTitle,
  }) : super(key: key);

  @override
  _UnknownScreenState createState() => _UnknownScreenState();
}

class _UnknownScreenState extends State<UnknownScreen> with RouteAware, RouteObserverMixin {
  // State Properties:
  bool _showPortraitOnly = false;
  String _appTitle;
  final String _screenId = UnknownScreen.screenId;
  int _activeTab = 0;

  /// Called when the top route has been popped off, and the current route
  /// shows up.
  @override
  void didPopNext() {
    print('didPopNext => Emerges: $_screenId');
    setState(() {
      _activeTab = 0;
    });
  }

  /// Called when the current route has been pushed.
  @override
  void didPush() {
    print('didPush => Arriving to: $_screenId');
    setState(() {
      _activeTab = 0;
    });
  }

  /// Called when the current route has been popped off.
  @override
  void didPop() {
    print('didPop => Popping of: $_screenId');
  }

  /// Called when a new route has been pushed, and the current route is no
  /// longer visible.
  @override
  void didPushNext() {
    print('didPushNext => Covering: $_screenId');
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   print("Back To old Screen");
  //   super.dispose();
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _appTitle = widget.appTitle;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      activeIndex: _activeTab,
      appTitle: _appTitle,
      innerWidgets: [
        CustomEmptyWidget(
          packageImage: 1,
          title: 'We are sorry',
          subTitle: 'That screen does not exist',
        ),
      ],
      onPressedFAB: () => _showModalNewThing(context),
      objectsLength: 0,
      objectName: 'thing',
    );
  }

  void _showModalNewThing(BuildContext context) {
    SoundHelper().playSmallButtonClick();
    // showModalBottomSheet(
    //   backgroundColor: Colors.transparent,
    //   isScrollControlled: true,
    //   context: context,
    //   builder: (context) => ProductNewScreen(),
    // );
  }
}
