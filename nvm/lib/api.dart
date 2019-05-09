import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart';

enum MethodEnum { GET, POST, PUT, DELETE }

class NvmAPI {
  static final NvmAPI _instance = NvmAPI();
  static NvmAPI getInstance() => _instance;

  int timeOut = 5;
  String preURL = '';

  Future<dynamic> call(
      [MethodEnum method = MethodEnum.GET,
      String url = '',
      Map<dynamic, dynamic> body,
      Map<String, String> headers = const {
        HttpHeaders.contentTypeHeader: 'application/json'
      }]) async {
    if (method == null) {
      throw Exception('The method is null or empty.');
    }

    if (url == null || url.isEmpty) {
      throw Exception('The URL is null or empty.');
    }

    if (body == null || body.isEmpty) {
      throw Exception('The body is null or empty.');
    }

    if (headers == null || headers.isEmpty) {
      throw Exception('The headers is null or empty.');
    }

    Response response;
    final String newUrl = Uri.encodeFull(this.preURL + '$url');
    try {
      if (MethodEnum.GET == method) {
        response = await get(newUrl, headers: headers)
            .timeout(Duration(seconds: timeOut));
      } else if (MethodEnum.POST == method) {
        response = await post(newUrl, headers: headers, body: jsonEncode(body))
            .timeout(Duration(seconds: timeOut));
      } else if (MethodEnum.PUT == method) {
        response = await put(newUrl, headers: headers, body: jsonEncode(body))
            .timeout(Duration(seconds: timeOut));
      } else if (MethodEnum.DELETE == method) {
        response = await delete(newUrl, headers: headers)
            .timeout(Duration(seconds: timeOut));
      } else {
        throw Exception('The method is not support.');
      }

      final int statusCode = response.statusCode;

      if (statusCode != 200) {
        throw Exception('The status code is not support.');
      }

      final Uint8List bodyBytes = response.bodyBytes;

      return jsonDecode(utf8.decode(bodyBytes));
    } catch (e) {
      throw Exception('The something went wrong.');
    }
  }
}
