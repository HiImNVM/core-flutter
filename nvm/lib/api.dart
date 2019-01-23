import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart';

enum eMethod { GET, POST }

class NvmAPI {
  static Future<dynamic> call(
      eMethod method, String url, Map<String, dynamic> body,
      [Map<String, String> headers]) async {
    Response response;
    headers = headers ?? {'Content-Type': 'application/json'};
    final String newUrl = '$url';
    if (eMethod.GET == method) {
      response =
          await get(newUrl, headers: headers).timeout(Duration(seconds: 5));
    } else if (eMethod.POST == method) {
      response = await post(newUrl, headers: headers, body: jsonEncode(body))
          .timeout(Duration(seconds: 5));
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
