import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart';

enum eMethod { GET, POST }

class NvmAPI {
  static int timeOut = 5;
  static Future<dynamic> call(
      [eMethod method = eMethod.GET,
      String url = '',
      Map<dynamic, dynamic> body,
      Map<String, String> headers = const {
        'Content-Type': 'application/json'
      }]) async {
    if (method == null) {
      throw Exception('The method is null');
    }

    if (url == null || url.isEmpty) {
      throw Exception('The URL is null or empty');
    }

    if (body == null) {
      throw Exception('The body is null or empty');
    }

    if (headers == null) {
      throw Exception('The headers is null or empty');
    }

    Response response;
    final String newUrl = '$url';
    if (eMethod.GET == method) {
      response = await get(newUrl, headers: headers)
          .timeout(Duration(seconds: timeOut));
    } else if (eMethod.POST == method) {
      response = await post(newUrl, headers: headers, body: jsonEncode(body))
          .timeout(Duration(seconds: timeOut));
    } else {
      throw Exception('The method is not support');
    }

    final int statusCode = response.statusCode;

    if (statusCode != 200) {
      throw Exception('The status code is not support');
    }

    final Uint8List bodyBytes = response.bodyBytes;

    return jsonDecode(utf8.decode(bodyBytes));
  }
}
