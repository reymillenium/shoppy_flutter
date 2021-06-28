import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  const Badge({
    Key key,
    @required this.child,
    @required this.value,
    this.color,
  }) : super(key: key);

  final Widget child;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: EdgeInsets.all(2.0),
            // color: Theme.of(context).accentColor,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                // color: color != null ? color : Theme.of(context).accentColor,
                color: color != null ? color : Colors.red,
                // color: color != null ? color : Colors.white,
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                )),
            constraints: BoxConstraints(
              minWidth: 20,
              minHeight: 20,
            ),
            child: Center(
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
