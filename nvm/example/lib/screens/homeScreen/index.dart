import 'package:example/models/index.dart';
import 'package:flutter/material.dart';
import 'package:nvm/nvm.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  dynamic _localisedValues;

  @override
  Widget build(BuildContext context) {
    this._localisedValues =
        (Nvm.getInstance().global as AppModel).localisedValues;

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Center(
          child: Text('Home'),
        ),
      ),
    );
  }
}
