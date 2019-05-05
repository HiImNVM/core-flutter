import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

class NvmUtil {
  static final NvmUtil _instance = NvmUtil();
  static NvmUtil getInstance() => _instance;

  String saltKey = '!z9';

  String parseMiliToString(int miliseconds) {
    DateTime result = new DateTime.fromMillisecondsSinceEpoch(miliseconds);
    return result.hour.toString() +
        ':' +
        result.minute.toString() +
        ' ' +
        result.day.toString() +
        '/' +
        result.month.toString() +
        '/' +
        result.year.toString();
  }

  String generateMd5(String pass) {
    final List<int> content =
        new Utf8Encoder().convert('$saltKey$pass!$saltKey');
    final Digest digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }
}
