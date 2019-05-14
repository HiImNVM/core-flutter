import 'package:example/constants.dart';
import 'package:example/models/index.dart';
import 'package:example/screens/homeScreen/chatScreen/index.dart';
import 'package:example/screens/homeScreen/settingScreen/index.dart';
import 'package:flutter/material.dart';
import 'package:nvm/nvm.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  dynamic _localisedValues;
  int _currentIndex;

  final List<Widget> _menuApp = [
    ChatWidget(),
    SettingWidget(),
  ];

  @override
  void initState() {
    super.initState();

    this._currentIndex = 0;
  }

  Widget _renderBody() => this._menuApp[this._currentIndex];

  Widget _renderBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: this._currentIndex,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          title:
              Text('${this._localisedValues[CONSTANT_HOME_SCREEN_TITLE_CHAT]}'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          title: Text(
              '${this._localisedValues[CONSTANT_HOME_SCREEN_TITLE_SETTING]}'),
        )
      ],
      onTap: this._switchScreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    this._localisedValues =
        (Nvm.getInstance().global as AppModel).localisedValues;

    return Scaffold(
      body: this._renderBody(),
      bottomNavigationBar: this._renderBottomNavigationBar(),
    );
  }

  void _switchScreen(int currentIndex) =>
      this.setState(() => this._currentIndex = currentIndex);
}
