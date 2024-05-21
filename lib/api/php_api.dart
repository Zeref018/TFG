// ignore_for_file: prefer_interpolation_to_compose_strings
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:tfg/constants/functions.dart';
import 'package:tfg/constants/general_configuration.dart';

class PhpApiRepository {
  Future<http.Response> get(
          {required String function,
          Map<String, dynamic>? body,
          Map<String, String>? headers,
          int? timeout,
          String uri = '',
          bool isEuw = true}) async =>
      _get(function, body ?? {}, headers, timeout, uri, isEuw);

  Future<http.Response> _get(String function, Map<String, dynamic> body,
      Map<String, String>? headers, timeout, String uri, bool isEuw) async {
    final apiFunction = Functions.get.function(function)!;
    http.Response response;
    try {
      Map<String, String>? headers = {
        'Content-Type': 'application/json',
        'Accept': '*/*',
      };

      response = await http
          .get(
              Uri.parse((isEuw
                      ? GeneralConfiguration.get.EUW_SERVER_URL
                      : GeneralConfiguration.get.EUROPE_SERVER_URL) +
                  apiFunction.path +
                  uri),
              headers: headers)
          .timeout(Duration(seconds: timeout ?? 10));
      if (GeneralConfiguration.get.functions_log) {
        debugPrint('\nGetting...');
        debugPrint('Target url:' +
            (isEuw
                ? GeneralConfiguration.get.EUW_SERVER_URL
                : GeneralConfiguration.get.EUROPE_SERVER_URL) +
            apiFunction.path +
            uri);
        debugPrint('Body sent: ' + body.toString());
        debugPrint('Response status code: ' + (response.statusCode).toString());
        debugPrint('Response body: ' + response.body);
      }
    } catch (e, stackTrace) {
      if (GeneralConfiguration.get.functions_log) {
        debugPrint('\nGetting...');
        debugPrint('Target url:' +
            (isEuw
                ? GeneralConfiguration.get.EUW_SERVER_URL
                : GeneralConfiguration.get.EUROPE_SERVER_URL) +
            apiFunction.path +
            uri);
        debugPrint('Body sent: ' + body.toString());
        debugPrint(e.toString());
        debugPrint(stackTrace.toString());
      }
      rethrow;
    }

    return response;
  }
}
