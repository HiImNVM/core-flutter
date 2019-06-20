import 'dart:async';
import 'package:example/models/index.dart';
import 'package:example/screens/flashScreen/index.dart';
import 'package:example/screens/homeScreen/index.dart';
import 'package:example/screens/loginScreen/index.dart';
import 'package:example/setup.dart';
import 'package:example/utils.dart';
import 'package:flutter/material.dart';
import 'package:nvm/nvm.dart';
import 'package:sentry/sentry.dart';

import 'constants.dart';

void main() async {
  // init model for application
  Nvm app = Nvm.getInstance();
  app.global = AppModel();
  print(' Init model for application succeed. ');

  // setup all before started application
  await Future.wait(
      setupAll(app).map((fn) async => await Utils.getInstance().futureFn(fn)));

  final String title = (app.global as AppModel).env[CONSTANT_APP_NAME];
  final bool debugMode = (app.global as AppModel).env[CONSTANT_IS_DEBUG];
  final RouteFactory routes = (app.global as AppModel).routes;
  final SentryClient sentryClient = (app.global as AppModel).sentryClient;

  Widget ownApp = AppWidget();
  print(' Init AppWidget succeed and START ===> ');

  runZoned(
    () => runApp(MaterialApp(
          title: title,
          debugShowCheckedModeBanner: debugMode,
          home: ownApp,
          onGenerateRoute: routes,
        )),
    onError: (error, stackTrace) {
      if (debugMode) {
        print(stackTrace);
        return;
      }

      sentryClient.captureException(
        exception: error,
        stackTrace: stackTrace,
      );
    },
  );
}

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => NvmFutureBuilder(
        future: this._loadResource(context),
        loadingBuilder: (context) => FlashWidget(),
        errorBuilder: (context, error) {},
        successBuilder: (context, data) {
          if (data == true) return LoginWidget();
          return HomeWidget();
        },
      );

  Future<dynamic> _loadResource(context) async {
    return await Future.delayed(Duration(seconds: 2), () async {
      try {
        AppModel appModel = (Nvm.getInstance().global as AppModel);
        appModel.mediaQueryData = MediaQuery.of(context);

        String pathLocale =
            appModel.sharedPreferences.getString(CONSTANT_STORE_LOCALE);

        if (pathLocale == null || pathLocale.isEmpty) {
          pathLocale = CONSTANT_LOCALES_EN;
        }

        await Utils.getInstance().changeLocale(pathLocale);
        return true;
      } catch (e) {
        throw Exception('Load resource faild. Please try again!');
      }
    });
  }
}
