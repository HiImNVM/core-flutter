import 'package:nvm/nvm.dart';

class HomeReducer implements INvmReducer {
  @override
  final String name;
  final String value;

  HomeReducer({
    this.name,
    this.value,
  });

  @override
  dynamic initialState() => null;
}
