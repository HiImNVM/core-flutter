library nvm;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class NvmStore extends MaterialApp {
  final Widget initialApp;
  final Store<dynamic> store;

  NvmStore({
    Key key,
    this.initialApp,
    this.store,
  }) : super(key: key);

  Widget build(BuildContext context) => StoreProvider<dynamic>(
        store: this.store,
        child: this.initialApp,
      );
}
