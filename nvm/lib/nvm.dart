library nvm;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

abstract class INvmReducer {
  @required
  final String name;

  INvmReducer({this.name});

  dynamic initialState();
}


class NvmApp extends MaterialApp {
  List<INvmReducer> reducers;
  Widget home;
  Store<dynamic> _store;
  Map<String, MaterialPageRoute> routers;

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