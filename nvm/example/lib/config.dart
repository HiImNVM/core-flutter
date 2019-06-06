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
  },
  '$CONSTANT_ENVIRONMENT_RELEASE': {
    '$CONSTANT_APP_NAME': 'Release Nvm App',
    '$CONSTANT_IS_DEBUG': false,
    '$CONSTANT_SERVER_URL_NAME':
        'https://5cd46056b231210014e3d893.mockapi.io/api/v1',
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
