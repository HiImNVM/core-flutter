library nvm;

import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

// redux
typedef State NvmReducer<State>(State state);
typedef void NvmMiddleware<State>(
  NvmStore<State> store,
  NvmNextDispatcher next,
);
typedef void NvmNextDispatcher();

class NvmStore<State> {
  final StreamController<State> _changeController;
  State _state;
  List<NvmNextDispatcher> _dispatchers;

  State get state => this._state;
  Stream<State> get onChange => this._changeController.stream;

  NvmStore({
    State initialState,
    List<NvmMiddleware<State>> middleware = const <NvmMiddleware<State>>[],
  }) : this._changeController = StreamController<State>.broadcast(sync: false) {
    this._state = initialState;
    this._dispatchers = _createDispatchers(
      middleware,
      _createReduceAndNotify(),
    );
  }

  List<NvmNextDispatcher> _createDispatchers(
    List<NvmMiddleware<State>> middleware,
    NvmNextDispatcher reduceAndNotify,
  ) {
    final List<NvmNextDispatcher> dispatchers = <NvmNextDispatcher>[]
      ..add(reduceAndNotify);

    for (NvmMiddleware<State> nextMiddleware in middleware.reversed) {
      final NvmNextDispatcher next = dispatchers.last;
      dispatchers.add(
        () => nextMiddleware(this, next),
      );
    }
    return dispatchers.reversed.toList();
  }

  NvmNextDispatcher _createReduceAndNotify() =>
      () => _changeController.add(_state);

  void dispatch() => _dispatchers[0]();

  Future<dynamic> teardown() {
    _state = null;
    return _changeController.close();
  }
}

// core

class System extends StatelessWidget {
  final Widget initialApp;
  NvmStore<dynamic> store;

  System({
    Key key,
    this.initialApp,
    this.store,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StoreProvider<dynamic>(
    store: 
    child: this.initialApp,
  );
}
