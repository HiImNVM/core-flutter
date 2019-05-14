import 'package:example/config.dart';
import 'package:example/constants.dart';
import 'package:example/models/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:nvm/nvm.dart';
import 'package:shared_preferences/shared_preferences.dart';

void _setupENV(Nvm app) {
  final AppModel appModel = (app.global as AppModel);
  final BuildMode buildMode = Nvm.getInstance().getBuildMode();

  final String nameENV = buildMode == BuildMode.Product
      ? CONSTANT_ENVIRONMENT_RELEASE
      : CONSTANT_ENVIRONMENT_DEV;

  appModel.env = configENV[nameENV];

  print(' Setup env succeed. ');
}

void _setupApp(Nvm app) {
  SystemChrome.setPreferredOrientations(configOrientation);

  print(' Setup app succeed. ');
}

void _setupRequest(Nvm app) {
  final AppModel appModel = (app.global as AppModel);
  NvmAPI.getInstance().preURL = appModel.env[CONSTANT_SERVER_URL_NAME];
  NvmAPI.getInstance().timeOut = configRequestTimeOut;
  appModel.request = NvmAPI.getInstance();
}

void _setupSharedPreferences(Nvm app) async {
  final AppModel appModel = (app.global as AppModel);

  appModel.sharedPreferences = await SharedPreferences.getInstance();

  print(' Setup sharedPreferences succeed. ');
}

void _setupRoutes(Nvm app) {
  final AppModel appModel = (app.global as AppModel);
  appModel.routes = (routeSetting) {
    final Map<String, dynamic> arguments = routeSetting.arguments;
    final String routeName = routeSetting.name;
    Widget widget;

    if (arguments == null) {
      widget = configRoutes[routeName]();
    } else {
      widget = configRoutes[routeName](arguments);
    }

    return MaterialPageRoute(builder: (context) => widget);
  };
}

List<Function> setupAll(Nvm app) {
  return [
    () => _setupENV(app),
    () => _setupSharedPreferences(app),
    () => _setupApp(app),
    () => _setupRequest(app),
    () => _setupRoutes(app),
  ];
}
