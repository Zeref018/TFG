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
  String get GROUP_GAME =>'/match/v5/matches';

  String get _function_get_uuid => '$API_RIOT$GROUP_ACCOUNTS/by-riot-id';

  String get _function_get_account_id => '$API_LOL$GROUP_SUMMONERS/by-puuid';

  String get _function_get_rank => '$API_LOL$GROUP_RANK/by-summoner';

  String get _function_get_game => '$API_LOL$GROUP_GAME/by-puuid';

  String get _function_get_match => '$API_LOL$GROUP_GAME';

  Map<String, ApiFunction> get _functions => {
        MapKeys.function.get_uuid: ApiFunction(_function_get_uuid, FunctionAuthority.general),
        MapKeys.function.get_account_id: ApiFunction(_function_get_account_id, FunctionAuthority.general),
        MapKeys.function.get_rank: ApiFunction(_function_get_rank, FunctionAuthority.general),
        MapKeys.function.get_game: ApiFunction(_function_get_game, FunctionAuthority.general),
        MapKeys.function.get_match: ApiFunction(_function_get_match, FunctionAuthority.general),
      };

  ApiFunction? function(String key) => _functions[key];
}
