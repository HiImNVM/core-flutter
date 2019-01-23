library nvm;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:nvm/api.dart';
import 'package:redux/redux.dart';

abstract class INvmReducer {
  @required
  final String name;

  INvmReducer({this.name});

  INvmReducer initialState();
}

@immutable
class NvmApp extends MaterialApp {
  @required
  final List<INvmReducer> reducers;

  @required
  final Widget home;

  @required
  final Map<String, MaterialPageRoute> routers;

  Store<dynamic> _store;

  NvmApp({this.reducers, this.home, this.routers}) : super(home: home) {
    final Map<String, dynamic> initialState = Map<String, dynamic>();
    reducers.forEach((INvmReducer aReducer) {
      final String nameReducer = aReducer.name;
      final dynamic reducer = aReducer.initialState();

      initialState.putIfAbsent(nameReducer, () => reducer);
    });

    this._store = Store<dynamic>(
      (dynamic state, dynamic action) => state,
      initialState: initialState,
    );
  }
}
