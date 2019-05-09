import 'package:flutter/widgets.dart';
import 'package:nvm/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppModel {
  SharedPreferences sharedPreferences;
  dynamic localisedValues;
  MediaQueryData mediaQueryData;
  Map<String, dynamic> env;
  NvmAPI request;

  AppModel({
    this.sharedPreferences,
    this.localisedValues,
    this.mediaQueryData,
    this.env,
    this.request,
  });
}
