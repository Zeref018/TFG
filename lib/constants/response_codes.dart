// ignore_for_file: non_constant_identifier_names

class ResponseCodes {
  const ResponseCodes();

  static const ResponseCodes get = ResponseCodes();

  int get success => 200;

  int get success_no_data => 204;

  int get server_error => 500;

  int get parameters_validation_error => 400;

  int get unauthorized => 401;
}
