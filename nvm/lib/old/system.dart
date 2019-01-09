import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'constant.dart';

abstract class IScreen {
  dynamic convertStoreToView(screenState, dispatch);

  dynamic widgetDidMount(screenState, dispatch);

  dynamic _widgetWillUnmount(screenState, dispatch) {
    screenState = null;
    dispatch();
  }

  dynamic build(BuildContext context, viewModel);
}

abstract class IRedux {}

class Screen {
  final String _routerName;
  final Function _iScreen;
  final Function _iRedux;
  final bool _isScreenMain;

  Screen(this._routerName, this._iScreen, this._iRedux,
      [this._isScreenMain = false]);
}

class DefaultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(SystemContant.TITLE_DEFAULT_SCREEN),
      ),
      body: new Text(SystemContant.TITLE_DEFAULT_SCREEN),
    );
  }
}

class System extends StatefulWidget {
  final Set<Screen> screens;
  final String titleApp;
  final ThemeData theme;
  final dynamic localStore;

  System({this.screens, this.titleApp, this.theme, this.localStore});

  @override
  _SystemState createState() => _SystemState();
}

class _SystemState extends State<System> {
  Store<dynamic> store;

  @override
  void initState() {
    super.initState();

    store = new Store<dynamic>(
      reducer,
      initialState: initialState(),
    );
  }

  dynamic reducer(state, action) {
    return state;
  }

  @override
  void dispose() {
    store = null;

    super.dispose();
  }

  dynamic initialState() {
    Map<String, dynamic> result = new Map<String, dynamic>();
    result.putIfAbsent(SystemContant.SYSTEM_STORE, () => widget.localStore);
    dynamic screens = widget.screens;

    screens.forEach(
        (aScreen) => result.putIfAbsent(aScreen._routerName, () => null));
    return result;
  }

  dynamic convertStoreToViewModel(Store store) {
    Screen mainScreen = widget.screens.firstWhere(
        (aScreen) => aScreen._isScreenMain == true,
        orElse: () => null);

    return {
      SystemContant.TITLE_APP:
          widget.titleApp ?? SystemContant.NAME_APP_DEFAULT,
      SystemContant.THEME_APP: widget.theme ?? ThemeData.light(),
      SystemContant.HOME_APP: connectStoreToScreen(mainScreen._routerName,
              mainScreen._iScreen, mainScreen._iRedux) ??
          new DefaultScreen(),
      SystemContant.ROUTERS_APP: convertToRouters(widget.screens),
    };
  }

  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
      store: store,
      child: new StoreConnector(
        converter: (Store store) => convertStoreToViewModel(store),
        builder: (BuildContext context, dynamic systemVM) => new MaterialApp(
              title: systemVM[SystemContant.TITLE_APP],
              theme: systemVM[SystemContant.THEME_APP],
              home: systemVM[SystemContant.HOME_APP],
              routes: systemVM[SystemContant.ROUTERS_APP],
            ),
      ),
    );
  }

  Widget connectStoreToScreen(String routerName, Function initInstanceScreen,
      Function initInstanceStateOfScreen) {
    final IScreen iScreen = initInstanceScreen();

    return new StoreConnector(
      converter: (Store store) => iScreen.convertStoreToView(
          store.state[routerName] ??= initInstanceStateOfScreen(),
          () => dispatchWrapper(store.dispatch)),
      builder: (BuildContext context, dynamic viewModel) =>
          iScreen.build(context, viewModel),
      onInitialBuild: (viewModel) => iScreen.widgetDidMount(
          store.state[routerName],
          () => dispatchWrapper(store.dispatch)),
      onDispose: (store) => iScreen._widgetWillUnmount(
          store.state[routerName], () => dispatchWrapper(store.dispatch)),
    );
  }

  dynamic dispatchWrapper(dispatch) => dispatch('');

  Map<String, WidgetBuilder> convertToRouters(Set<Screen> screens) {
    if (screens == null) return null;
    Map<String, WidgetBuilder> routers = new Map<String, WidgetBuilder>();

    screens.forEach((aScreen) => routers.putIfAbsent(
        aScreen._routerName,
        () => (BuildContext context) => connectStoreToScreen(
            aScreen._routerName, aScreen._iScreen, aScreen._iRedux)));

    return routers;
  }
}