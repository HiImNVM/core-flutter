import 'package:example/components/loader/config.dart';
import 'package:example/components/loader/constants.dart';
import 'package:flutter/material.dart';
import 'package:nvm/widgets.dart';

class LoadingWidget extends NvmLoading {
  final List<Color> colors;
  final Duration duration;
  LoadingWidget({
    Key key,
    this.colors = CONFIG_LOADER_LOADING_WIDGET_COLORS,
    this.duration = CONFIG_LOADER_LOADING_WIDGET_DURATION,
  }) : super(key: key, colors: colors, duration: duration);
}

class ErrorLoadingWidget extends StatelessWidget {
  final Function onRefresh;
  final String error;

  ErrorLoadingWidget({
    Key key,
    @required this.onRefresh,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          (this.error == null || this.error.isEmpty)
              ? Text('$CONSTANT_LOADER_ERROR')
              : Text('$error'),
          IconButton(
            onPressed: this.onRefresh,
            icon: Icon(Icons.refresh),
          )
        ],
      ),
    );
  }
}

class RotatingPlaneLoadingWidget extends NvmRotatingPlane {
  final Color color;

  RotatingPlaneLoadingWidget({
    Key key,
    this.color = CONFIG_LOADER_ROTATINGPLANE_LOADING_WIDGET_COLOR,
  }) : super(key: key, color: color);
}
