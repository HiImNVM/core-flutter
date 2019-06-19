import 'package:example/constants.dart';
import 'package:example/screens/homeScreen/chatScreen/chatContentScreen/index.dart';
import 'package:example/screens/homeScreen/index.dart';
import 'package:flutter/services.dart';
import 'package:example/screens/loginScreen/index.dart';

Map<String, dynamic> configENV = {
  '$CONSTANT_ENVIRONMENT_DEV': {
    '$CONSTANT_APP_NAME': 'Dev Nvm App',
    '$CONSTANT_IS_DEBUG': true,
    '$CONSTANT_SERVER_URL_NAME':
        'https://5cd46056b231210014e3d893.mockapi.io/api/v1',
    '$CONSTANT_SENTRY_DNS': ''
  },
  '$CONSTANT_ENVIRONMENT_RELEASE': {
    '$CONSTANT_APP_NAME': 'Release Nvm App',
    '$CONSTANT_IS_DEBUG': false,
    '$CONSTANT_SERVER_URL_NAME':
        'https://5cd46056b231210014e3d893.mockapi.io/api/v1',
    '$CONSTANT_SENTRY_DNS':
        'https://a7e6b72d2af34a7c91c5f0c7d55ae16d:e3d3910a1d3d40b3a572e4f2811092e6@sentry.io/1485113'
  },
};

List<DeviceOrientation> configOrientation = [DeviceOrientation.portraitUp];

int configRequestTimeOut = 8;

Map<String, Function> configRoutes = {
  '/home': () => HomeWidget(),
  '/login': () => LoginWidget(),
  '/chat': (user) => ChatContentWidget(
        user: user,
      ),
};
