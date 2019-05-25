import 'package:example/models/index.dart';
import 'package:nvm/nvm.dart';
import 'package:intl/intl.dart';

class Utils {
  static final Utils _instance = Utils();
  static Utils getInstance() => _instance;

  Future<void> changeLocale(String newPath) async {
    AppModel appModel = Nvm.getInstance().global;
    appModel.localisedValues = await Nvm.getInstance().readLocales(newPath);
  }

  String convertShortStringWithAppendChars(
      int maxChars, String str, String charsAppend) {
    if (str == null || str.isEmpty) {
      return '';
    }

    if (charsAppend == null || charsAppend.isEmpty) {
      return str;
    }

    if (maxChars >= str.length) {
      return str;
    }

    return str.substring(0, maxChars) + charsAppend;
  }

  String convertMiliToTimeFormat(int mili, String formatted) {
    final DateTime dateTimeConverted =
        DateTime.fromMillisecondsSinceEpoch(mili);
    final DateFormat dateFormat = DateFormat(formatted);

    return dateFormat.format(dateTimeConverted);
  }

  Future<void> futureFn(Function fn) => Future<void>(fn);
}
