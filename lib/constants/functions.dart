// ignore_for_file: non_constant_identifier_names

import 'package:tfg/constants/map_keys/map_keys.dart';
import 'package:tfg/enums/function_authority_enum.dart';
import 'package:tfg/models/api_function.dart';

class Functions {
  const Functions();

  static const Functions get = Functions();

  String get API_RIOT => '/riot';
  String get API_LOL => '/lol';

  String get GROUP_SUMMONERS => '/summoner/v4/summoners';
  String get GROUP_ACCOUNTS => '/account/v1/accounts';
  String get GROUP_RANK => '/league/v4/entries';

  String get _function_get_uuid => '$API_RIOT$GROUP_ACCOUNTS/by-riot-id';

  String get _function_get_account_id => '$API_LOL$GROUP_SUMMONERS/by-puuid';

  String get _function_get_rank => '$API_LOL$GROUP_RANK/by-summoner';

  Map<String, ApiFunction> get _functions => {
        MapKeys.function.get_uuid: ApiFunction(_function_get_uuid, FunctionAuthority.general),
        MapKeys.function.get_account_id: ApiFunction(_function_get_account_id, FunctionAuthority.general),
        MapKeys.function.get_rank: ApiFunction(_function_get_rank, FunctionAuthority.general),
      };

  ApiFunction? function(String key) => _functions[key];
}
