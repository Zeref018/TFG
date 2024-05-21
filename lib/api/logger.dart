import 'package:tfg/constants/general_configuration.dart';

class Logger {
  static void logException(dynamic e, StackTrace? stackTrace, {String? function, String? bodySent, String? extraInformation}) async {
    if (GeneralConfiguration.get.errors_log) {
      print('-------------------------------------');
      print('[C] EXCEPTION');
      print('-------------------------------------');
      print('[C] Error: ${e.toString()}');
      print('-------------------------------------');
      print('[C] StackTrace: ${stackTrace.toString()}');
      print('-------------------------------------');
      if (function != null) {
        print('[C] Function: $function');
        print('-------------------------------------');
      }
      if (bodySent != null) {
        print('[C] Body Sent: $bodySent');
        print('-------------------------------------');
      }
      if (extraInformation != null) {
        print('[C] extraInformation: $extraInformation');
        print('-------------------------------------');
      }
    }
    // Map<String, dynamic> body = {
    //   MapKeys.body.exception: e.toString(),
    //   MapKeys.body.stack_trace: stackTrace.toString(),
    //   if (function != null) MapKeys.body.function: function,
    //   if (bodySent != null) MapKeys.body.body_sent: bodySent,
    //   if (extraInformation != null) MapKeys.body.extra_information: extraInformation,
    // };
  }

  static void logUnknownError(String code, String response, {String? function, String? bodySent, String? extraInformation}) async {
    if (GeneralConfiguration.get.errors_log) {
      print('-------------------------------------');
      print('[C] UNKNOWN ERROR');
      print('-------------------------------------');
      print('[C] Code: $code');
      print('-------------------------------------');
      print('[C] Response: $response');
      print('-------------------------------------');
      if (function != null) {
        print('[C] Function: $function');
        print('-------------------------------------');
      }
      if (bodySent != null) {
        print('[C] Body Sent: $bodySent');
        print('-------------------------------------');
      }
      if (extraInformation != null) {
        print('[C] extraInformation: $extraInformation');
        print('-------------------------------------');
      }
    }
  }
}
