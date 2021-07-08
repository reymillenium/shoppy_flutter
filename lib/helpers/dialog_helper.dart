// Packages:

import 'dart:ffi';

import '../_inner_packages.dart';
import '../_external_packages.dart';

// Models:
// import '../models/_models.dart';

// Helpers:
import '../helpers/_helpers.dart';

// Utilities:

class DialogHelper {
  static Future<void> showDialogPlus(int id, BuildContext context, Function onAcceptPressed) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // The user must tap the buttons!
      // barrierColor: Colors.transparent, // The background color
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here

          content: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(12),
              // height: 100,
              child: Column(
                children: <Widget>[
                  Text(
                    'This action is irreversible.',
                    style: TextStyle(
                      color: Theme.of(context).errorColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Text('Would you like to confirm this message?'),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: Row(
                  children: [
                    Text('Confirm'),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.delete),
                  ],
                ),
                onPressed: () {
                  onAcceptPressed();
                  Navigator.of(context).pop();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: Row(
                  children: [
                    Text('Cancel'),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.cancel),
                  ],
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  static Alert createAlert({int id, BuildContext context, String message = '', Function onAcceptPressed}) {
    return Alert(
      context: context,
      type: AlertType.warning,
      title: "Are you sure?",
      // desc: message,
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            onAcceptPressed();
            Navigator.of(context).pop();
          },
          width: 120,
        ),
        DialogButton(
          child: Text(
            "CANCEL",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        ),
      ],
    );
  }

  static void openFilterDialog(BuildContext context, List<String> availableFilters, List<String> selectedFilters, Function onApplyButtonClick) async {
    await FilterListDialog.display<String>(
      context,
      listData: availableFilters,
      selectedListData: selectedFilters,
      height: 300,
      headlineText: "Show me the Products:",
      searchFieldHintText: "Search Here",
      choiceChipLabel: (item) {
        return item.toCamelCase.readable;
      },
      validateSelectedItem: (list, val) {
        return list.contains(val);
      },
      onItemSearch: (list, text) {
        if (list.any((element) => element.toLowerCase().contains(text.toLowerCase().removeWhiteSpaces))) {
          return list.where((element) => element.toLowerCase().contains(text.toLowerCase().removeWhiteSpaces)).toList();
        } else {
          return [];
        }
      },
      // onApplyButtonClick: (list) {
      //   if (list != null) {
      //     setState(() {
      //       selectedFilters = List.from(list);
      //     });
      //   }
      //   Navigator.pop(context);
      // },
      onApplyButtonClick: (list) => onApplyButtonClick(list, context),
      useRootNavigator: false,
    );
  }

  static SnackBar buildSnackBar({
    @required String snackBarMessage,
    String snackBarActionLabel = 'Undo',
    int durationInSeconds = 3,
    @required Function actionOnPressed,
  }) {
    return SnackBar(
      elevation: 2,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      action: SnackBarAction(
        label: snackBarActionLabel,
        onPressed: actionOnPressed ?? () {},
      ),
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: durationInSeconds),
      content: Row(
        children: [
          Text(snackBarMessage),
        ],
      ),
    );
  }
}
