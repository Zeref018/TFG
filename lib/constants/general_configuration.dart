// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:flutter/foundation.dart';

class GeneralConfiguration {
  const GeneralConfiguration();

  static const GeneralConfiguration get = GeneralConfiguration();

  String get EUROPE_SERVER_URL => 'https://europe.api.riotgames.com';

  String get EUW_SERVER_URL => 'https://euw1.api.riotgames.com';

  bool get functions_log => kReleaseMode ? false : true;

  bool get errors_log => kReleaseMode ? false : true;

  String get api_key => 'RGAPI-2099b18e-7ece-4e20-a88a-e764abda320b';
}
