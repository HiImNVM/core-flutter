import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef ErrorBuilder = Widget Function(BuildContext context, String error);
typedef LoadingBuilder = Widget Function(BuildContext context);
typedef SuccessBuilder = Widget Function(BuildContext context, dynamic data);
class NvmFutureBuilder<T> extends FutureBuilder<T> {
  @override
  final Future<T> future;
  final ErrorBuilder errorBuilder;
  final LoadingBuilder loadingBuilder;
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


typedef ResultWillPop = bool Function(bool isWillPop);
class NvmWillPopScope extends WillPopScope {
  @override
  final Widget child;
  final BuildContext context;
  final ResultWillPop onWillPopReceive;

  NvmWillPopScope({
    Key key,
    @required this.child,
    @required this.onWillPopReceive,
    @required this.context,
  }) : super(
            key: key,
            child: child,
            onWillPop: () async {
              final bool result = await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) => AlertDialog(
                        title: Text('Bạn có muốn thoát khỏi ứng dụng?'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Không'),
                            onPressed: () => Navigator.pop(context, false),
                          ),
                          FlatButton(
                            child: Text('Có'),
                            onPressed: () => Navigator.pop(context, true),
                          ),
                        ],
                      ));

              return onWillPopReceive(result);
            });
}
