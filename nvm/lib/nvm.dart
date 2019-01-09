library nvm;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

abstract class IReducer {
  String name;
  dynamic initialState();
  dynamic initialReducer(dynamic preState, dynamic action);
}

class Nvm extends MaterialApp {
  List<IReducer> reducers;
  Store<dynamic> _store;

  Nvm({this.reducers}) : super() {
    final Map<String, dynamic> initialState = Map<String, dynamic>();

    reducers.forEach((IReducer aReducer) {
      final String nameReducer = aReducer.name;
      final dynamic reducer =  aReducer.initialState(); 

      initialState.putIfAbsent(nameReducer, () => reducer);
    });

    this._store = Store<dynamic>(
      (dynamic preState, dynamic action) => 
      reducers.firstWhere((IReducer aReducer) => 
      aReducer., orElse: () => null),
      initialState: initialState,
    );
  }
}

// class NvmStore extends StatelessWidget {
//   final MaterialApp child;
//   final Store<dynamic> store;

//   NvmStore({this.child, this.store});

//   @override
//   Widget build(BuildContext context) => StoreProvider<dynamic>(
//         store: this.store,
//         child: this.child.r,
//       );
// }
