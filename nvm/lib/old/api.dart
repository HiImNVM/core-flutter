import 'dart:io';
import 'dart:convert';

enum eMethod { GET, POST }


class API {
  static const String IP = "http://221.132.18.21";
  static const String PORT = "7979";
  static const String PRE_URL = "/api/v1.0/";

  static const String ERROR_NOT_SUPPORT_METHOD = "The method is not support";
  static const String ERROR_STATUS_CODE = "The status code is not support";

  static const String IS_SUCCESS = 'success';
  static const String MESSAGE = 'message';
  static const String RESULT = 'result';

  static Future call(String url, eMethod enumMethod, dynamic body,
      [dynamic headers]) async {
    dynamic response;
    final String URL = '$IP:$PORT$PRE_URL$url';

    if (eMethod.GET == enumMethod) {
      response = await http
        ..get(URL, headers: headers);
    } else if (eMethod.POST == enumMethod) {
      response =
          await http.post(URL, headers: headers, body: json.encode(body));
    } else {
      throw new Exception(ERROR_NOT_SUPPORT_METHOD);
    }

    if (response.statusCode != 200) {
      throw new Exception(ERROR_STATUS_CODE);
    }
    return response.body;
  }
}
