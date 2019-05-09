import 'package:example/model/index.dart';
import 'package:nvm/nvm.dart';

class Utils {
  static final Utils _instance = Utils();
  static Utils getInstance() => _instance;

  Future<void> changeLocale(String newPath) async {
    AppModel appModel = Nvm.getInstance().global;
    appModel.localisedValues = await Nvm.getInstance().readLocales(newPath);
  }

  Future<void> futureFn(Function fn) => Future<void>(fn);
}
