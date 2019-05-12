import 'package:example/components/snackBar/style.dart';
import 'package:flutter/material.dart';

enum StatusEnum {
  error,
  success,
  warning,
}

class SnackBarStatusWidget extends SnackBar {
  final StatusEnum statusEnum;
  final String text;

  SnackBarStatusWidget({
    Key key,
    @required this.text,
    @required this.statusEnum,
  }) : super(
          key: key,
          content: _renderStatus(statusEnum, text),
          duration: Duration(seconds: 7),
          backgroundColor: _renderBackgroundColorStatus(statusEnum),
        );
}

Widget _renderStatus(StatusEnum statusEnum, String text) {
  Icon icon;
  TextStyle textStyle = baseTextStyle;

  if (statusEnum == StatusEnum.success) {
    icon = Icon(
      Icons.done,
      color: colorTextAndIcon,
    );
  } else if (statusEnum == StatusEnum.error) {
    icon = Icon(
      Icons.cancel,
      color: colorTextAndIcon,
    );
  } else {
    icon = Icon(
      Icons.warning,
      color: colorTextAndIcon,
    );
  }

  return Row(
    children: <Widget>[
      Expanded(flex: 0, child: icon),
      SizedBox(
        width: 10,
      ),
      Expanded(
        flex: 1,
        child: Text(
          '$text',
          style: textStyle,
        ),
      ),
    ],
  );
}

Color _renderBackgroundColorStatus(StatusEnum statusEnum) {
  if (statusEnum == StatusEnum.error) {
    return backgroundColorError;
  } else if (statusEnum == StatusEnum.success) {
    return backgroundColorSuccess;
  } else {
    return backgroundColorWarning;
  }
}
