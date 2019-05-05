library nvm;

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

export 'api.dart';
export 'widgets.dart';
export 'utils.dart';

enum BuildMode { Debug, Product }

class Nvm {
  static final Nvm _instance = Nvm();
  static Nvm getInstance() => _instance;

  BuildMode getBuildMode() => bool.fromEnvironment('dart.vm.product')
      ? BuildMode.Product
      : BuildMode.Debug;

  dynamic global;

  Future<dynamic> readLocales(String path) async {
    try {
      if (path == null || path.isEmpty) {
        throw Exception('The path is null or empty.');
      }
      final String result = await rootBundle.loadString('$path');
      return json.decode(result);
    } catch (e) {
      throw Exception('Read locales is something went wrong.');
    }
  }
}
