import 'package:example/components/snackBar/index.dart';
import 'package:flutter/material.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: this._scaffoldKey,
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text('Error'),
              onPressed: () => this._showSnackBar(1),
            ),
            RaisedButton(
              child: Text('Success'),
              onPressed: () => this._showSnackBar(2),
            ),
            RaisedButton(
              child: Text('Warning'),
              onPressed: () => this._showSnackBar(3),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(int number) {
    SnackBarStatusWidget snackBarStatusWidget;
    if (number == 1) {
      snackBarStatusWidget = SnackBarStatusWidget(
        text: 'Error. Please try again.',
        statusEnum: StatusEnum.error,
      );
    } else if (number == 2) {
      snackBarStatusWidget = SnackBarStatusWidget(
        text: 'Success. Login success.',
        statusEnum: StatusEnum.success,
      );
    } else {
      snackBarStatusWidget = SnackBarStatusWidget(
        text: 'Warning. Warning abcxyz.',
        statusEnum: StatusEnum.warning,
      );
    }

    this._scaffoldKey.currentState.showSnackBar(snackBarStatusWidget);
  }
}
