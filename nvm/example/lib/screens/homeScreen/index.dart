import 'package:example/components/loader/index.dart';
import 'package:example/constants.dart';
import 'package:example/model/index.dart';
import 'package:example/utils.dart';
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
          child: Text('${this._localisedValues[LOCALES_HOME_TITLE]}'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => this._switchLocale(context),
        child: Icon(Icons.refresh),
      ),
    );
  }

  void _switchLocale(context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => new Center(child: LoadingWidget()));

    Utils.getInstance().changeLocale(CONFIG_LOCALES_VI).then((_) {
      Navigator.pop(context);
      this.setState(() {});
    });
  }
}
