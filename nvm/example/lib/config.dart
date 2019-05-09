import 'package:example/constants.dart';
import 'package:flutter/services.dart';

Map<String, dynamic> configENV = {
  '$CONFIG_ENVIRONMENT_DEV': {
    '$CONFIG_APP_NAME': 'Dev Nvm App',
    '$CONFIG_IS_DEBUG': true,
    '$CONFIG_SERVER_URL_NAME':
        'https://5cd46056b231210014e3d893.mockapi.io/api/v1',
  },
  '$CONFIG_ENVIRONMENT_RELEASE': {
    '$CONFIG_APP_NAME': 'Release Nvm App',
    '$CONFIG_IS_DEBUG': false,
    '$CONFIG_SERVER_URL_NAME':
        'https://5cd46056b231210014e3d893.mockapi.io/api/v1',
  },
};

List<DeviceOrientation> configOrientation = [DeviceOrientation.portraitUp];
int configRequestTimeOut = 10;
