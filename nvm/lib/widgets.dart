import 'dart:async';
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
  final String question;
  final String nameCancel;
  final String nameOK;

  NvmWillPopScope({
    Key key,
    @required this.child,
    @required this.onWillPopReceive,
    @required this.context,
    @required this.question,
    @required this.nameOK,
    @required this.nameCancel,
  }) : super(
            key: key,
            child: child,
            onWillPop: () async {
              final bool result = await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) => AlertDialog(
                        title: Text('$question'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('$nameCancel'),
                            onPressed: () => Navigator.pop(context, false),
                          ),
                          FlatButton(
                            child: Text('$nameOK'),
                            onPressed: () => Navigator.pop(context, true),
                          ),
                        ],
                      ));

              return onWillPopReceive(result);
            });
}

class NvmLoading extends StatefulWidget {
  final List<Color> colors;
  final Duration duration;

  NvmLoading({Key key, @required this.colors, @required this.duration})
      : super(key: key);

  @override
  _NvmLoadingState createState() =>
      _NvmLoadingState(this.colors, this.duration);
}

class _NvmLoadingState extends State<NvmLoading>
    with SingleTickerProviderStateMixin {
  final List<Color> colors;
  final Duration duration;
  Timer timer;

  _NvmLoadingState(this.colors, this.duration);

  //noSuchMethod(Invocation i) => super.noSuchMethod(i);

  List<ColorTween> tweenAnimations = [];
  int tweenIndex = 0;

  AnimationController controller;
  List<Animation<Color>> colorAnimations = [];

  @override
  void initState() {
    super.initState();

    controller = new AnimationController(
      vsync: this,
      duration: duration,
    );

    for (int i = 0; i < colors.length - 1; i++) {
      tweenAnimations.add(ColorTween(begin: colors[i], end: colors[i + 1]));
    }

    tweenAnimations
        .add(ColorTween(begin: colors[colors.length - 1], end: colors[0]));

    for (int i = 0; i < colors.length; i++) {
      Animation<Color> animation = tweenAnimations[i].animate(CurvedAnimation(
          parent: controller,
          curve: Interval((1 / colors.length) * (i + 1) - 0.05,
              (1 / colors.length) * (i + 1),
              curve: Curves.linear)));

      colorAnimations.add(animation);
    }

    print(colorAnimations.length);

    tweenIndex = 0;

    timer = Timer.periodic(duration, (Timer t) {
      setState(() {
        tweenIndex = (tweenIndex + 1) % colors.length;
      });
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 5.0,
          valueColor: colorAnimations[tweenIndex],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    controller.dispose();
    super.dispose();
  }
}

class NvmRotatingPlane extends StatefulWidget {
  NvmRotatingPlane({
    Key key,
    this.color,
    this.size = 50.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 1200),
  })  : assert(
            !(itemBuilder is IndexedWidgetBuilder && color is Color) &&
                !(itemBuilder == null && color == null),
            'You should specify either a itemBuilder or a color'),
        assert(size != null),
        super(key: key);

  final Color color;
  final double size;
  final IndexedWidgetBuilder itemBuilder;
  final Duration duration;

  @override
  _NvmRotatingPlaneState createState() => _NvmRotatingPlaneState();
}

class _NvmRotatingPlaneState extends State<NvmRotatingPlane>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation1;
  Animation<double> _animation2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation1 = Tween(begin: 0.0, end: 180.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    )..addListener(() => setState(() => <String, void>{}));

    _animation2 = Tween(begin: 0.0, end: 180.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    )..addListener(() => setState(() => <String, void>{}));

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Matrix4 transform = Matrix4.identity()
      ..rotateX((0 - _animation1.value) * 0.0174533)
      ..rotateY((0 - _animation2.value) * 0.0174533);
    return Center(
      child: Transform(
        transform: transform,
        alignment: FractionalOffset.center,
        child: SizedBox.fromSize(
          size: Size.square(widget.size),
          child: _itemBuilder(0),
        ),
      ),
    );
  }

  Widget _itemBuilder(int index) {
    return widget.itemBuilder != null
        ? widget.itemBuilder(context, index)
        : DecoratedBox(
            decoration: BoxDecoration(
              color: widget.color,
            ),
          );
  }
}
