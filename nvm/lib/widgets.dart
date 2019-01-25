import 'package:flutter/widgets.dart';

typedef ErrorBuilder = Widget Function(BuildContext context, String error);
typedef LoadingBuilder = Widget Function(BuildContext context);
typedef SuccessBuilder = Widget Function(BuildContext context, dynamic data);

class NvmFutureBuilder<T> extends FutureBuilder<T> {
  @required
  @override
  final Future<T> future;

  @required
  final ErrorBuilder errorBuilder;

  @required
  final LoadingBuilder loadingBuilder;

  @required
  final SuccessBuilder successBuilder;

  NvmFutureBuilder(
      {Key key,
      @required this.future,
      @required this.errorBuilder,
      @required this.loadingBuilder,
      @required this.successBuilder})
      : assert(future != null),
        assert(loadingBuilder != null),
        assert(errorBuilder != null),
        assert(successBuilder != null),
        super(
            key: key,
            future: future,
            builder: (BuildContext context, AsyncSnapshot<T> snapShot) {
              if (snapShot.hasError) {
                return errorBuilder(context, snapShot.error.toString());
              }

              return snapShot.hasData
                  ? successBuilder(context, snapShot.data)
                  : loadingBuilder(context);
            });
}
