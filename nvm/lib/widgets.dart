import 'package:flutter/widgets.dart';

typedef ErrorBuilder = Widget Function(BuildContext context, String error);
typedef LoadingBuilder = Widget Function(BuildContext context);
typedef SuccessBuilder = Widget Function(BuildContext context, dynamic data);

class NvmFutureBuilder<T> extends FutureBuilder<T> {
  @required
  final Future<T> future;

  @required
  final AsyncWidgetBuilder<T> builder;

  @required
  final ErrorBuilder errorBuilder;

  @required
  final LoadingBuilder loadingBuilder;

  @required
  final SuccessBuilder successBuilder;

  NvmFutureBuilder(
      {Key key,
      this.future,
      this.builder,
      this.errorBuilder,
      this.loadingBuilder,
      this.successBuilder})
      : super(
          key: key,
          future: future,
          builder: builder,
        );
}
